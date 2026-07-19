import { ApiError } from "../errors";
import { decodeOpaqueCursor, encodeOpaqueCursor } from "../lib/cursor";
import { normalizeText } from "../lib/normalize";
import { uuidv7 } from "../lib/uuidv7";
import { readingSubGroup } from "./reading-sub-group";

const editWindowMilliseconds = 60 * 60 * 1000;

type WordBindings = {
  DB: D1Database;
};

type WordRow = {
  id: string;
  word: string;
  reading: string;
  reading_sub_group: string;
  created_by: string | null;
  created_at: number;
};

type WordDetailRow = WordRow & {
  public_definition_count: number;
  is_saved_by_me: number;
  has_other_user_definition: number;
  has_other_user_save: number;
};

type WordListRow = {
  id: string;
  word: string;
  reading: string;
  reading_sub_group: string;
  public_definition_count: number;
};

type WordListCursor = {
  id: string;
  kind: "words";
  reading: string;
  version: 1;
};

export type CreateWordInput = {
  reading: string;
  word: string;
};

export type UpdateWordInput = {
  reading?: string | undefined;
  word?: string | undefined;
};

export type ListWordsInput = {
  cursor?: string | undefined;
  filter: "all" | "defined" | "undefined";
  limit: number;
  q?: string | undefined;
  subGroup?: string | undefined;
};

/** 登録時に同一表記が存在した場合の 409。既存の言葉を添えて返す。 */
export class WordConflictError extends ApiError {
  constructor(readonly existingWord: { id: string; word: string; reading: string }) {
    super(409, "word_already_exists", "Word already exists");
  }
}

function decodeWordListCursor(value: string): WordListCursor {
  const parsed = decodeOpaqueCursor(value);
  if (
    parsed["version"] !== 1 ||
    parsed["kind"] !== "words" ||
    typeof parsed["reading"] !== "string" ||
    typeof parsed["id"] !== "string" ||
    parsed["id"].length === 0
  ) {
    throw new ApiError(400, "invalid_cursor", "Invalid cursor");
  }
  return parsed as unknown as WordListCursor;
}

/** zod は空白のみの入力を通すため、正規化後の空文字はここで拒否する。 */
function requireNonEmpty(value: string, field: string): string {
  if (value === "") {
    throw new ApiError(400, "invalid_request", `${field} must not be empty`);
  }
  return value;
}

function escapeLikePattern(value: string): string {
  return value.replaceAll("\\", "\\\\").replaceAll("%", "\\%").replaceAll("_", "\\_");
}

function toWordResponse(row: WordDetailRow, uid: string, now: number) {
  return {
    id: row.id,
    isEditableByMe:
      row.created_by === uid &&
      now - row.created_at < editWindowMilliseconds &&
      row.has_other_user_definition === 0 &&
      row.has_other_user_save === 0,
    isSavedByMe: row.is_saved_by_me !== 0,
    publicDefinitionCount: row.public_definition_count,
    reading: row.reading,
    readingSubGroup: row.reading_sub_group,
    word: row.word,
  };
}

/**
 * D1 上の言葉の登録・一覧・取得・期限付き修正・保存を扱う。
 *
 * @doc doc/specs/workers-api-server.md#言葉
 */
export class WordService {
  constructor(private readonly env: WordBindings) {}

  async #findByWord(word: string): Promise<WordRow | null> {
    return this.env.DB.prepare(
      "select id, word, reading, reading_sub_group, created_by, created_at from words where word = ?",
    )
      .bind(word)
      .first<WordRow>();
  }

  async #requireDetail(uid: string, id: string): Promise<WordDetailRow> {
    const row = await this.env.DB.prepare(
      `select
         w.id,
         w.word,
         w.reading,
         w.reading_sub_group,
         w.created_by,
         w.created_at,
         (select count(*) from definitions d
          where d.word_id = w.id and d.status = 'public' and d.deleted_at is null)
           as public_definition_count,
         exists(select 1 from saved_words s
          where s.word_id = w.id and s.user_id = ?) as is_saved_by_me,
         exists(select 1 from definitions d
          where d.word_id = w.id and d.author_id <> ? and d.deleted_at is null)
           as has_other_user_definition,
         exists(select 1 from saved_words s
          where s.word_id = w.id and s.user_id <> ?) as has_other_user_save
       from words w
       where w.id = ?`,
    )
      .bind(uid, uid, uid, id)
      .first<WordDetailRow>();
    if (row === null) throw new ApiError(404, "word_not_found", "Word not found");
    return row;
  }

  async #requireActiveUser(uid: string): Promise<void> {
    const user = await this.env.DB.prepare(
      "select id from users where id = ? and deleted_at is null",
    )
      .bind(uid)
      .first();
    if (user === null) throw new ApiError(404, "user_not_found", "User not found");
  }

  async #throwIfWordTaken(word: string): Promise<void> {
    const existing = await this.#findByWord(word);
    if (existing !== null) {
      throw new WordConflictError({
        id: existing.id,
        reading: existing.reading,
        word: existing.word,
      });
    }
  }

  async create(uid: string, input: CreateWordInput) {
    await this.#requireActiveUser(uid);
    const word = requireNonEmpty(normalizeText(input.word), "word");
    const reading = requireNonEmpty(normalizeText(input.reading), "reading");
    await this.#throwIfWordTaken(word);

    const id = uuidv7();
    const now = Date.now();
    try {
      await this.env.DB.prepare(
        `insert into words (id, word, reading, reading_sub_group, created_by, created_at, updated_at)
         values (?, ?, ?, ?, ?, ?, ?)`,
      )
        .bind(id, word, reading, readingSubGroup(reading), uid, now, now)
        .run();
    } catch (error) {
      // UNIQUE 競合（同時登録）だけを 409 に変換し、それ以外は再送出する
      await this.#throwIfWordTaken(word);
      throw error;
    }
    return this.get(uid, id);
  }

  async get(uid: string, id: string) {
    return toWordResponse(await this.#requireDetail(uid, id), uid, Date.now());
  }

  async update(uid: string, id: string, input: UpdateWordInput) {
    await this.#requireActiveUser(uid);
    const detail = await this.#requireDetail(uid, id);
    if (!toWordResponse(detail, uid, Date.now()).isEditableByMe) {
      throw new ApiError(403, "word_not_editable", "Word not editable");
    }

    const word =
      input.word === undefined ? detail.word : requireNonEmpty(normalizeText(input.word), "word");
    const reading =
      input.reading === undefined
        ? detail.reading
        : requireNonEmpty(normalizeText(input.reading), "reading");
    if (word !== detail.word) await this.#throwIfWordTaken(word);

    const now = Date.now();
    let result: D1Response;
    try {
      // 編集可否チェックと更新の間に他ユーザーの操作が入る TOCTOU を防ぐため、
      // 可否条件を WHERE に埋め込んだ単一文で原子的に更新する
      result = await this.env.DB.prepare(
        `update words
         set word = ?, reading = ?, reading_sub_group = ?, updated_at = ?
         where id = ?
           and created_by = ?
           and created_at > ?
           and not exists(select 1 from definitions d
            where d.word_id = words.id and d.author_id <> ? and d.deleted_at is null)
           and not exists(select 1 from saved_words s
            where s.word_id = words.id and s.user_id <> ?)`,
      )
        .bind(
          word,
          reading,
          readingSubGroup(reading),
          now,
          id,
          uid,
          now - editWindowMilliseconds,
          uid,
          uid,
        )
        .run();
    } catch (error) {
      // UNIQUE 競合（同時登録）だけを 409 に変換し、それ以外は再送出する
      if (word !== detail.word) await this.#throwIfWordTaken(word);
      throw error;
    }
    if (result.meta.changes === 0) {
      throw new ApiError(403, "word_not_editable", "Word not editable");
    }
    return this.get(uid, id);
  }

  async list(uid: string, input: ListWordsInput) {
    const cursor = input.cursor === undefined ? null : decodeWordListCursor(input.cursor);
    const conditions: string[] = [];
    const parameters: unknown[] = [];

    if (input.subGroup !== undefined) {
      conditions.push("w.reading_sub_group = ?");
      parameters.push(input.subGroup);
    }
    if (input.q !== undefined && input.q !== "") {
      const pattern = `%${escapeLikePattern(input.q)}%`;
      conditions.push("(w.word like ? escape '\\' or w.reading like ? escape '\\')");
      parameters.push(pattern, pattern);
    }
    if (input.filter === "defined") {
      conditions.push(
        `exists(select 1 from definitions d
          join users author on author.id = d.author_id and author.deleted_at is null
          where d.word_id = w.id and d.status = 'public' and d.deleted_at is null
            and not exists(select 1 from user_mutes m
              where m.muter_id = ? and m.muted_user_id = d.author_id))`,
      );
      parameters.push(uid);
    }
    if (input.filter === "undefined") {
      conditions.push(
        `not exists(select 1 from definitions d
          join users author on author.id = d.author_id and author.deleted_at is null
          where d.word_id = w.id and d.status = 'public' and d.deleted_at is null
            and not exists(select 1 from user_mutes m
              where m.muter_id = ? and m.muted_user_id = d.author_id))`,
      );
      parameters.push(uid);
    }
    if (cursor !== null) {
      conditions.push("(w.reading > ? or (w.reading = ? and w.id > ?))");
      parameters.push(cursor.reading, cursor.reading, cursor.id);
    }

    const whereClause = conditions.length === 0 ? "" : `where ${conditions.join(" and ")}`;
    const rows = (
      await this.env.DB.prepare(
        `select
           w.id,
           w.word,
           w.reading,
           w.reading_sub_group,
           (select count(*) from definitions d
            join users author on author.id = d.author_id and author.deleted_at is null
            where d.word_id = w.id and d.status = 'public' and d.deleted_at is null
              and not exists(select 1 from user_mutes m
                where m.muter_id = ? and m.muted_user_id = d.author_id))
             as public_definition_count
         from words w
         ${whereClause}
         order by w.reading asc, w.id asc
         limit ?`,
      )
        .bind(uid, ...parameters, input.limit + 1)
        .all<WordListRow>()
    ).results;

    const hasNextPage = rows.length > input.limit;
    const pageRows = rows.slice(0, input.limit);
    const last = pageRows.at(-1);
    return {
      items: pageRows.map((row) => ({
        id: row.id,
        publicDefinitionCount: row.public_definition_count,
        reading: row.reading,
        readingSubGroup: row.reading_sub_group,
        word: row.word,
      })),
      nextCursor:
        hasNextPage && last !== undefined
          ? encodeOpaqueCursor({
              id: last.id,
              kind: "words",
              reading: last.reading,
              version: 1,
            } satisfies WordListCursor)
          : null,
    };
  }

  async save(uid: string, wordId: string): Promise<void> {
    await this.#requireActiveUser(uid);
    const word = await this.env.DB.prepare("select id from words where id = ?")
      .bind(wordId)
      .first();
    if (word === null) throw new ApiError(404, "word_not_found", "Word not found");
    await this.env.DB.prepare(
      "insert or ignore into saved_words (user_id, word_id, created_at) values (?, ?, ?)",
    )
      .bind(uid, wordId, Date.now())
      .run();
  }

  async unsave(uid: string, wordId: string): Promise<void> {
    await this.env.DB.prepare("delete from saved_words where user_id = ? and word_id = ?")
      .bind(uid, wordId)
      .run();
  }
}
