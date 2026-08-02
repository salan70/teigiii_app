import { ApiError } from "../errors";
import { decodeOpaqueCursor, encodeOpaqueCursor } from "../lib/cursor";
import { normalizeText } from "../lib/normalize";
import { uuidv7 } from "../lib/uuidv7";
import {
  readingScriptClass,
  readingScriptClassCursorClause,
  readingScriptClassFromSubGroup,
  readingScriptClassOrderBy,
} from "./reading-script-class";
import { readingSubGroup } from "./reading-sub-group";
import { accessibleWordSql, publiclyVisibleWordSql } from "./word-visibility";

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
  first_registered_at: number | null;
  first_registered_by: string | null;
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
  scriptClass?: number;
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

/**
 * 明示登録の結果種別。
 *
 * - `created`: 言葉を新規作成した
 * - `promoted`: 既存の言葉に対し、最初の明示登録をこのリクエストが行った
 * - `alreadyPublic`: 既存の言葉で、この登録の前から明示登録されていた
 */
export type WordRegistrationResult = "alreadyPublic" | "created" | "promoted";

export type WordSummaryResponse = {
  id: string;
  reading: string;
  word: string;
};

export type WordResponse = {
  id: string;
  isEditableByMe: boolean;
  isSavedByMe: boolean;
  publicDefinitionCount: number;
  reading: string;
  readingSubGroup: string;
  word: string;
};

/** 修正時に同一の (表記, よみ) が存在した場合の 409。既存の言葉を添えて返す。 */
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
  const cursor = parsed as unknown as WordListCursor;
  const scriptClass =
    typeof parsed["scriptClass"] === "number" && Number.isInteger(parsed["scriptClass"])
      ? (parsed["scriptClass"] as number)
      : readingScriptClass(cursor.reading);
  return { ...cursor, scriptClass };
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

function toWordResponse(row: WordDetailRow, uid: string, now: number): WordResponse {
  // 昇格登録では created_by と first_registered_by が一致しないため、どちらにも編集権を与えない。
  const isOriginalExplicitRegistrant =
    row.created_by === uid && (row.first_registered_by === null || row.first_registered_by === uid);
  return {
    id: row.id,
    isEditableByMe:
      isOriginalExplicitRegistrant &&
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
 * D1 上の言葉の明示登録・一覧・取得・期限付き修正・保存を扱う。
 *
 * @doc doc/specs/workers-api-server.md#言葉
 */
export class WordService {
  constructor(private readonly env: WordBindings) {}

  /** 言葉の同一性は (表記, よみ) の完全一致。同表記異読は別の言葉として扱う。 */
  async #findByWordAndReading(word: string, reading: string): Promise<WordRow | null> {
    return this.env.DB.prepare(
      `select id, word, reading, reading_sub_group, created_by,
              first_registered_at, first_registered_by, created_at
       from words where word = ? and reading = ?`,
    )
      .bind(word, reading)
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
         w.first_registered_at,
         w.first_registered_by,
         w.created_at,
         (select count(*) from definitions d
          join users author on author.id = d.author_id and author.deleted_at is null
          where d.word_id = w.id and d.status = 'public' and d.deleted_at is null
            and not exists(select 1 from user_mutes m
              where m.muter_id = ? and m.muted_user_id = d.author_id))
           as public_definition_count,
         exists(select 1 from saved_words s
          where s.word_id = w.id and s.user_id = ?) as is_saved_by_me,
         exists(select 1 from definitions d
          where d.word_id = w.id and d.author_id <> ? and d.deleted_at is null)
           as has_other_user_definition,
         exists(select 1 from saved_words s
          where s.word_id = w.id and s.user_id <> ?) as has_other_user_save
       from words w
       where w.id = ?
         and ${accessibleWordSql("?")}`,
    )
      .bind(uid, uid, uid, uid, id, uid, uid, uid)
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

  async #requirePubliclyVisibleWord(uid: string, wordId: string): Promise<void> {
    const row = await this.env.DB.prepare(
      `select w.id from words w
       where w.id = ? and ${publiclyVisibleWordSql("?")}`,
    )
      .bind(wordId, uid, uid)
      .first();
    if (row === null) throw new ApiError(404, "word_not_found", "Word not found");
  }

  async #throwIfWordTaken(word: string, reading: string): Promise<void> {
    const existing = await this.#findByWordAndReading(word, reading);
    if (existing !== null) {
      throw new WordConflictError({
        id: existing.id,
        reading: existing.reading,
        word: existing.word,
      });
    }
  }

  /**
   * 明示登録を記録し、最初の明示登録を**このリクエストが**行ったかどうかを返す。
   *
   * 判定を UPDATE の結果から取るため、事前に状態を読む必要がない。
   * 同時に 2 リクエストが来ても first_registered_at を設定できるのは片方だけであり、
   * 「公開経路に出す変化を起こしたのはどちらか」が原子的に決まる。
   */
  async #ensureRegistration(uid: string, wordId: string, now: number): Promise<boolean> {
    const updated = await this.env.DB.prepare(
      `update words
       set first_registered_at = ?, first_registered_by = ?, updated_at = ?
       where id = ? and first_registered_at is null`,
    )
      .bind(now, uid, now, wordId)
      .run();
    const isFirstRegistration = updated.meta.changes > 0;

    try {
      await this.env.DB.prepare(
        `insert into word_registrations (id, word_id, user_id, created_at)
         select ?, ?, ?, ?
         where not exists(
           select 1 from word_registrations
           where word_id = ? and user_id = ?
         )`,
      )
        .bind(uuidv7(), wordId, uid, now, wordId, uid)
        .run();
    } catch (error) {
      // where not exists と INSERT の間に同時リクエストが入ると部分 UNIQUE に落ちうる。
      // 既に同一ユーザーの登録があるなら冪等成功として扱う。
      const existing = await this.env.DB.prepare(
        `select 1 as ok from word_registrations where word_id = ? and user_id = ?`,
      )
        .bind(wordId, uid)
        .first();
      if (existing !== null) return isFirstRegistration;
      throw error;
    }
    return isFirstRegistration;
  }

  /**
   * 既存の言葉への明示登録。
   *
   * 最初の明示登録をこのリクエストが行ったなら promoted、既に誰かが明示登録済みなら
   * alreadyPublic。公開定義だけで見えていた言葉（first_registered_at が null）への
   * 登録は言葉登録 activity を新たに生むため、promoted に分類する。
   */
  async #registerExisting(
    uid: string,
    wordId: string,
    now: number,
  ): Promise<{ result: WordRegistrationResult; word: WordResponse }> {
    const isFirstRegistration = await this.#ensureRegistration(uid, wordId, now);
    return {
      result: isFirstRegistration ? "promoted" : "alreadyPublic",
      word: await this.get(uid, wordId),
    };
  }

  /**
   * 言葉単体の明示登録。
   * 新規作成は 201（result=created）、既存への登録・昇格は 200
   * （result=promoted / alreadyPublic）。
   */
  async create(
    uid: string,
    input: CreateWordInput,
  ): Promise<{ result: WordRegistrationResult; word: WordResponse }> {
    await this.#requireActiveUser(uid);
    const word = requireNonEmpty(normalizeText(input.word), "word");
    const reading = requireNonEmpty(normalizeText(input.reading), "reading");
    const now = Date.now();

    const existing = await this.#findByWordAndReading(word, reading);
    if (existing !== null) {
      return this.#registerExisting(uid, existing.id, now);
    }

    const id = uuidv7();
    try {
      await this.env.DB.batch([
        this.env.DB.prepare(
          `insert into words (
             id, word, reading, reading_sub_group, created_by,
             first_registered_at, first_registered_by, created_at, updated_at
           ) values (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        ).bind(id, word, reading, readingSubGroup(reading), uid, now, uid, now, now),
        this.env.DB.prepare(
          `insert into word_registrations (id, word_id, user_id, created_at)
           values (?, ?, ?, ?)`,
        ).bind(uuidv7(), id, uid, now),
      ]);
    } catch (error) {
      // UNIQUE 競合（同時登録）は既存行への明示登録へフォールバックする
      const raced = await this.#findByWordAndReading(word, reading);
      if (raced === null) throw error;
      return this.#registerExisting(uid, raced.id, now);
    }
    return { result: "created", word: await this.get(uid, id) };
  }

  /**
   * 登録前の既存語チェック。
   *
   * (表記, よみ) の完全一致で、閲覧者にとって公開されており、かつ**明示登録済み**の
   * 言葉だけを返す。非公開の言葉は存在そのものを秘匿するため null を返す。
   *
   * 公開定義だけで見えている言葉（first_registered_at が null）は返さない。
   * その言葉への登録は言葉登録 activity を新たに生む観測可能な操作であり、
   * 「登録済み」として登録を止めるのは誤り。
   */
  async lookupPublic(uid: string, input: CreateWordInput): Promise<WordSummaryResponse | null> {
    const word = requireNonEmpty(normalizeText(input.word), "word");
    const reading = requireNonEmpty(normalizeText(input.reading), "reading");
    const row = await this.env.DB.prepare(
      `select w.id, w.word, w.reading
       from words w
       where w.word = ? and w.reading = ?
         and w.first_registered_at is not null
         and ${publiclyVisibleWordSql("?")}`,
    )
      .bind(word, reading, uid, uid)
      .first<{ id: string; reading: string; word: string }>();
    return row === null ? null : { id: row.id, reading: row.reading, word: row.word };
  }

  /**
   * 定義作成時の言葉解決（検索のみ）。明示登録は行わない。
   * (表記, よみ) が一致する既存言葉があればその ID を返す。
   * 表記だけ一致してよみが異なる言葉は別の言葉として扱い、ここでは解決しない。
   */
  async findIdByNormalizedWord(word: string, reading: string): Promise<string | null> {
    const existing = await this.#findByWordAndReading(word, reading);
    return existing?.id ?? null;
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
    if (word !== detail.word || reading !== detail.reading)
      await this.#throwIfWordTaken(word, reading);

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
           and (first_registered_by is null or first_registered_by = ?)
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
          uid,
          now - editWindowMilliseconds,
          uid,
          uid,
        )
        .run();
    } catch (error) {
      // UNIQUE 競合（同時登録）だけを 409 に変換し、それ以外は再送出する
      if (word !== detail.word || reading !== detail.reading)
        await this.#throwIfWordTaken(word, reading);
      throw error;
    }
    if (result.meta.changes === 0) {
      throw new ApiError(403, "word_not_editable", "Word not editable");
    }
    return this.get(uid, id);
  }

  async list(uid: string, input: ListWordsInput) {
    const cursor = input.cursor === undefined ? null : decodeWordListCursor(input.cursor);
    const conditions: string[] = [publiclyVisibleWordSql("?")];
    const parameters: unknown[] = [uid, uid];

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
      conditions.push(readingScriptClassCursorClause());
      const scriptClass = cursor.scriptClass ?? readingScriptClass(cursor.reading);
      parameters.push(
        scriptClass,
        scriptClass,
        cursor.reading,
        scriptClass,
        cursor.reading,
        cursor.id,
      );
    }

    const whereClause = `where ${conditions.join(" and ")}`;
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
         order by ${readingScriptClassOrderBy()}
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
              scriptClass: readingScriptClassFromSubGroup(last.reading_sub_group),
              version: 1,
            } satisfies WordListCursor)
          : null,
    };
  }

  async save(uid: string, wordId: string): Promise<void> {
    await this.#requireActiveUser(uid);
    await this.#requirePubliclyVisibleWord(uid, wordId);
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
