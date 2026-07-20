import { ApiError } from "../errors";
import { DefinitionService } from "../definitions/definition-service";
import { decodeOpaqueCursor, encodeOpaqueCursor } from "../lib/cursor";
import { normalizeText } from "../lib/normalize";
import { uuidv7 } from "../lib/uuidv7";
import { readingPattern } from "../schemas/word";
import { readingSubGroup } from "../words/reading-sub-group";

type DraftBindings = {
  AVATAR_BASE_URL: string;
  DB: D1Database;
};

type DraftVisibility = "public" | "private";

type DraftRow = {
  id: string;
  user_id: string;
  word_id: string | null;
  word: string;
  reading: string;
  body: string;
  visibility: DraftVisibility;
  finalized_definition_id: string | null;
  created_at: number;
  updated_at: number;
};

type WordRow = { id: string; word: string; reading: string };

type DraftCursor = {
  id: string;
  kind: "definition_drafts";
  updatedAt: number;
  version: 1;
};

export type PutDefinitionDraftInput = {
  wordId?: string | null | undefined;
  word: string;
  reading: string;
  body: string;
  visibility: DraftVisibility;
};

export class WordReadingMismatchError extends ApiError {
  constructor(readonly existingWord: WordRow) {
    super(409, "word_reading_mismatch", "Word reading differs from the existing word");
  }
}

function draftNotFound(): never {
  throw new ApiError(404, "definition_draft_not_found", "Definition draft not found");
}

function toDraft(row: DraftRow) {
  return {
    body: row.body,
    createdAt: new Date(row.created_at).toISOString(),
    finalizedDefinitionId: row.finalized_definition_id,
    id: row.id,
    reading: row.reading,
    updatedAt: new Date(row.updated_at).toISOString(),
    visibility: row.visibility,
    word: row.word,
    wordId: row.word_id,
  };
}

function decodeDraftCursor(value: string): DraftCursor {
  const parsed = decodeOpaqueCursor(value);
  if (
    parsed["version"] !== 1 ||
    parsed["kind"] !== "definition_drafts" ||
    typeof parsed["updatedAt"] !== "number" ||
    !Number.isSafeInteger(parsed["updatedAt"]) ||
    typeof parsed["id"] !== "string" ||
    parsed["id"].length === 0
  ) {
    throw new ApiError(400, "invalid_cursor", "Invalid cursor");
  }
  return parsed as unknown as DraftCursor;
}

/**
 * 本人専用 Draft の冪等保存・一覧・削除・確定を扱う。
 *
 * @doc doc/specs/workers-api-server.md#定義-draft
 */
export class DefinitionDraftService {
  constructor(private readonly env: DraftBindings) {}

  async #requireActiveUser(uid: string): Promise<void> {
    const user = await this.env.DB.prepare(
      "select id from users where id = ? and deleted_at is null",
    )
      .bind(uid)
      .first();
    if (user === null) throw new ApiError(404, "user_not_found", "User not found");
  }

  async #findOwned(uid: string, id: string, includeFinalized: boolean): Promise<DraftRow | null> {
    const finalizedClause = includeFinalized ? "" : "and finalized_definition_id is null";
    return this.env.DB.prepare(
      `select id, user_id, word_id, word, reading, body, visibility,
              finalized_definition_id, created_at, updated_at
       from definition_drafts
       where id = ? and user_id = ? ${finalizedClause}`,
    )
      .bind(id, uid)
      .first<DraftRow>();
  }

  async put(uid: string, id: string, input: PutDefinitionDraftInput) {
    await this.#requireActiveUser(uid);
    if (input.word === "" && input.reading === "" && input.body === "") {
      throw new ApiError(400, "draft_empty", "Definition draft is empty");
    }
    if (input.wordId !== undefined && input.wordId !== null) {
      const word = await this.env.DB.prepare("select id from words where id = ?")
        .bind(input.wordId)
        .first();
      if (word === null) throw new ApiError(404, "word_not_found", "Word not found");
    }

    const now = Date.now();
    const result = await this.env.DB.prepare(
      `insert into definition_drafts
       (id, user_id, word_id, word, reading, body, visibility, created_at, updated_at)
       values (?, ?, ?, ?, ?, ?, ?, ?, ?)
       on conflict(id) do update set
         word_id = excluded.word_id,
         word = excluded.word,
         reading = excluded.reading,
         body = excluded.body,
         visibility = excluded.visibility,
         updated_at = excluded.updated_at
       where definition_drafts.user_id = excluded.user_id
         and definition_drafts.finalized_definition_id is null`,
    )
      .bind(
        id,
        uid,
        input.wordId ?? null,
        input.word,
        input.reading,
        input.body,
        input.visibility,
        now,
        now,
      )
      .run();
    if (result.meta.changes === 0) draftNotFound();
    return this.get(uid, id);
  }

  async get(uid: string, id: string) {
    const row = await this.#findOwned(uid, id, false);
    if (row === null) draftNotFound();
    return toDraft(row);
  }

  async list(uid: string, limit: number, cursorValue?: string) {
    const cursor = cursorValue === undefined ? null : decodeDraftCursor(cursorValue);
    const cursorClause =
      cursor === null ? "" : "and (updated_at < ? or (updated_at = ? and id < ?))";
    const statement = this.env.DB.prepare(
      `select id, user_id, word_id, word, reading, body, visibility,
              finalized_definition_id, created_at, updated_at
       from definition_drafts
       where user_id = ? and finalized_definition_id is null ${cursorClause}
       order by updated_at desc, id desc
       limit ?`,
    );
    const rows = (
      await (
        cursor === null
          ? statement.bind(uid, limit + 1)
          : statement.bind(uid, cursor.updatedAt, cursor.updatedAt, cursor.id, limit + 1)
      ).all<DraftRow>()
    ).results;
    const hasNextPage = rows.length > limit;
    const pageRows = rows.slice(0, limit);
    const last = pageRows.at(-1);
    return {
      items: pageRows.map(toDraft),
      nextCursor:
        hasNextPage && last !== undefined
          ? encodeOpaqueCursor({
              id: last.id,
              kind: "definition_drafts",
              updatedAt: last.updated_at,
              version: 1,
            } satisfies DraftCursor)
          : null,
    };
  }

  async delete(uid: string, id: string): Promise<void> {
    await this.env.DB.prepare("delete from definition_drafts where id = ? and user_id = ?")
      .bind(id, uid)
      .run();
  }

  async #resolveWord(
    uid: string,
    row: DraftRow,
    confirmReadingMismatch: boolean,
  ): Promise<WordRow> {
    if (row.word_id !== null) {
      const fixedWord = await this.env.DB.prepare(
        "select id, word, reading from words where id = ?",
      )
        .bind(row.word_id)
        .first<WordRow>();
      if (fixedWord === null) throw new ApiError(404, "word_not_found", "Word not found");
      return fixedWord;
    }

    const word = normalizeText(row.word);
    const reading = normalizeText(row.reading);
    let existing = await this.env.DB.prepare("select id, word, reading from words where word = ?")
      .bind(word)
      .first<WordRow>();
    if (existing !== null) {
      if (existing.reading !== reading && !confirmReadingMismatch) {
        throw new WordReadingMismatchError(existing);
      }
      return existing;
    }

    const wordId = uuidv7();
    const now = Date.now();
    try {
      await this.env.DB.prepare(
        `insert into words (id, word, reading, reading_sub_group, created_by, created_at, updated_at)
         values (?, ?, ?, ?, ?, ?, ?)`,
      )
        .bind(wordId, word, reading, readingSubGroup(reading), uid, now, now)
        .run();
      return { id: wordId, reading, word };
    } catch (error) {
      existing = await this.env.DB.prepare("select id, word, reading from words where word = ?")
        .bind(word)
        .first<WordRow>();
      if (existing === null) throw error;
      if (existing.reading !== reading && !confirmReadingMismatch) {
        throw new WordReadingMismatchError(existing);
      }
      return existing;
    }
  }

  async finalize(uid: string, id: string, confirmReadingMismatch: boolean) {
    const row = await this.#findOwned(uid, id, true);
    if (row === null) draftNotFound();
    if (row.finalized_definition_id !== null) {
      return new DefinitionService(this.env).get(uid, row.finalized_definition_id);
    }
    if (row.word.trim() === "" || row.reading.trim() === "" || row.body.trim() === "") {
      throw new ApiError(400, "draft_incomplete", "Definition draft is incomplete");
    }
    if (!readingPattern.test(normalizeText(row.reading))) {
      throw new ApiError(400, "draft_invalid", "Definition draft contains invalid input");
    }

    const word = await this.#resolveWord(uid, row, confirmReadingMismatch);
    const now = Date.now();
    await this.env.DB.batch([
      this.env.DB.prepare(
        `insert or ignore into definitions
         (id, word_id, author_id, body, status, finalized_at, is_edited, created_at, updated_at)
         values (?, ?, ?, ?, ?, ?, 0, ?, ?)`,
      ).bind(id, word.id, uid, row.body, row.visibility, now, now, now),
      this.env.DB.prepare(
        `update definition_drafts
         set word_id = ?, finalized_definition_id = ?, finalized_at = ?, updated_at = ?
         where id = ? and user_id = ? and finalized_definition_id is null`,
      ).bind(word.id, id, now, now, id, uid),
    ]);
    return new DefinitionService(this.env).get(uid, id);
  }
}
