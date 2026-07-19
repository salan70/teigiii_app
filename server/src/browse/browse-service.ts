import { ApiError } from "../errors";
import { decodeOpaqueCursor, encodeOpaqueCursor } from "../lib/cursor";

const editWindowMilliseconds = 60 * 60 * 1000;

type BrowseBindings = {
  AVATAR_BASE_URL: string;
  DB: D1Database;
};

type DefinitionStatus = "draft" | "public" | "private";

type DefinitionListRow = {
  id: string;
  word_id: string;
  word: string;
  reading: string;
  author_id: string;
  author_public_id: string;
  author_name: string;
  author_avatar_key: string | null;
  body: string;
  status: DefinitionStatus;
  finalized_at: number | null;
  is_edited: number;
  created_at: number;
  updated_at: number;
  likes_count: number;
  is_liked_by_me: number;
  sort_at: number;
};

type WordListRow = {
  id: string;
  word: string;
  reading: string;
  reading_sub_group: string;
  public_definition_count: number;
};

type UserListRow = {
  id: string;
  public_id: string;
  name: string;
  avatar_key: string | null;
  is_followed_by_me: number;
  is_muted_by_me: number;
  relation_created_at: number;
};

type DescendingCursor = {
  id: string;
  kind: string;
  sortAt: number;
  version: 1;
};

type ReadingCursor = {
  id: string;
  kind: string;
  reading: string;
  version: 1;
};

type ReactionCursor = DescendingCursor & { likesCount: number };
type DiscoverCursor = DescendingCursor & { type: string };

function avatarUrl(baseUrl: string, key: string | null): string | null {
  if (key === null) return null;
  return `${baseUrl.replace(/\/+$/, "")}/${key}`;
}

function escapeLikePattern(value: string): string {
  return value.replaceAll("\\", "\\\\").replaceAll("%", "\\%").replaceAll("_", "\\_");
}

function decodeCursor(value: string, kind: string): Record<string, unknown> {
  const parsed = decodeOpaqueCursor(value);
  if (parsed["version"] !== 1 || parsed["kind"] !== kind) {
    throw new ApiError(400, "invalid_cursor", "Invalid cursor");
  }
  return parsed;
}

function decodeDescendingCursor(value: string, kind: string): DescendingCursor {
  const parsed = decodeCursor(value, kind);
  if (
    typeof parsed["sortAt"] !== "number" ||
    !Number.isSafeInteger(parsed["sortAt"]) ||
    typeof parsed["id"] !== "string" ||
    parsed["id"].length === 0
  ) {
    throw new ApiError(400, "invalid_cursor", "Invalid cursor");
  }
  return parsed as unknown as DescendingCursor;
}

function decodeReadingCursor(value: string, kind: string): ReadingCursor {
  const parsed = decodeCursor(value, kind);
  if (
    typeof parsed["reading"] !== "string" ||
    typeof parsed["id"] !== "string" ||
    parsed["id"].length === 0
  ) {
    throw new ApiError(400, "invalid_cursor", "Invalid cursor");
  }
  return parsed as unknown as ReadingCursor;
}

function activeLikesCount(definitionId = "d.id"): string {
  return `(select count(*) from likes counted
    join users liker on liker.id = counted.user_id and liker.deleted_at is null
    where counted.definition_id = ${definitionId})`;
}

function definitionColumns(): string {
  return `d.id, d.word_id, w.word, w.reading,
    d.author_id, u.public_id as author_public_id, u.name as author_name,
    u.avatar_key as author_avatar_key, d.body, d.status, d.finalized_at,
    d.is_edited, d.created_at, d.updated_at,
    ${activeLikesCount()} as likes_count,
    exists(select 1 from likes mine
     where mine.definition_id = d.id and mine.user_id = ?) as is_liked_by_me,
    coalesce(d.finalized_at, d.updated_at) as sort_at`;
}

function toDefinition(row: DefinitionListRow, baseUrl: string) {
  const editableUntil =
    row.finalized_at === null ? null : row.finalized_at + editWindowMilliseconds;
  return {
    author: {
      avatarUrl: avatarUrl(baseUrl, row.author_avatar_key),
      id: row.author_id,
      name: row.author_name,
      publicId: row.author_public_id,
    },
    body: row.body,
    createdAt: new Date(row.created_at).toISOString(),
    editableUntil: editableUntil === null ? null : new Date(editableUntil).toISOString(),
    finalizedAt: row.finalized_at === null ? null : new Date(row.finalized_at).toISOString(),
    id: row.id,
    isEdited: row.is_edited !== 0,
    isLikedByMe: row.is_liked_by_me !== 0,
    likesCount: row.likes_count,
    status: row.status,
    updatedAt: new Date(row.updated_at).toISOString(),
    word: { id: row.word_id, reading: row.reading, word: row.word },
  };
}

function wordItem(row: WordListRow) {
  return {
    id: row.id,
    publicDefinitionCount: row.public_definition_count,
    reading: row.reading,
    readingSubGroup: row.reading_sub_group,
    word: row.word,
  };
}

function userItem(row: UserListRow, baseUrl: string) {
  return {
    avatarUrl: avatarUrl(baseUrl, row.avatar_key),
    id: row.id,
    isFollowedByMe: row.is_followed_by_me !== 0,
    isMutedByMe: row.is_muted_by_me !== 0,
    name: row.name,
    publicId: row.public_id,
  };
}

function page<T, R>(rows: R[], limit: number, map: (row: R) => T, cursor: (row: R) => string) {
  const hasNextPage = rows.length > limit;
  const pageRows = rows.slice(0, limit);
  const last = pageRows.at(-1);
  return {
    items: pageRows.map(map),
    nextCursor: hasNextPage && last !== undefined ? cursor(last) : null,
  };
}

async function requireUser(db: D1Database, id: string): Promise<void> {
  const row = await db
    .prepare("select id from users where id = ? and deleted_at is null")
    .bind(id)
    .first();
  if (row === null) throw new ApiError(404, "user_not_found", "User not found");
}

async function requireWord(db: D1Database, id: string): Promise<void> {
  const row = await db.prepare("select id from words where id = ?").bind(id).first();
  if (row === null) throw new ApiError(404, "word_not_found", "Word not found");
}

/**
 * 一覧・辞書・タイムライン・検索の合成 DTO と keyset pagination を扱う。
 *
 * @doc doc/specs/workers-api-server.md#辞書と一覧
 * @doc doc/specs/workers-api-server.md#タイムラインと検索
 */
export class BrowseService {
  constructor(private readonly env: BrowseBindings) {}

  async listUserDictionary(userId: string, limit: number, cursorValue?: string) {
    await requireUser(this.env.DB, userId);
    const cursor =
      cursorValue === undefined ? null : decodeReadingCursor(cursorValue, "user_dictionary");
    const cursorClause =
      cursor === null ? "" : "and (w.reading > ? or (w.reading = ? and w.id > ?))";
    const statement = this.env.DB.prepare(
      `select w.id, w.word, w.reading, count(*) as public_count
       from definitions d
       join words w on w.id = d.word_id
       join users u on u.id = d.author_id and u.deleted_at is null
       where d.author_id = ? and d.status = 'public' and d.deleted_at is null ${cursorClause}
       group by w.id, w.word, w.reading
       order by w.reading asc, w.id asc
       limit ?`,
    );
    type Row = { id: string; word: string; reading: string; public_count: number };
    const rows = (
      await (
        cursor === null
          ? statement.bind(userId, limit + 1)
          : statement.bind(userId, cursor.reading, cursor.reading, cursor.id, limit + 1)
      ).all<Row>()
    ).results;
    return page(
      rows,
      limit,
      (row) => ({
        publicCount: row.public_count,
        word: { id: row.id, reading: row.reading, word: row.word },
      }),
      (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "user_dictionary",
          reading: row.reading,
          version: 1,
        } satisfies ReadingCursor),
    );
  }

  async listUserDefinitions(
    viewerUid: string,
    userId: string,
    input: {
      cursor?: string | undefined;
      limit: number;
      sort: "newest" | "reading";
      subGroup?: string | undefined;
      wordId?: string | undefined;
    },
  ) {
    await requireUser(this.env.DB, userId);
    const own = viewerUid === userId;
    const conditions = [
      "d.author_id = ?",
      "d.deleted_at is null",
      own ? "d.status in ('public', 'private')" : "d.status = 'public'",
    ];
    const parameters: unknown[] = [viewerUid, userId];
    if (input.wordId !== undefined) {
      conditions.push("d.word_id = ?");
      parameters.push(input.wordId);
    }
    if (input.subGroup !== undefined) {
      conditions.push("w.reading_sub_group = ?");
      parameters.push(input.subGroup);
    }

    let orderBy: string;
    let cursorFactory: (row: DefinitionListRow) => string;
    if (input.sort === "reading") {
      const cursor =
        input.cursor === undefined
          ? null
          : decodeReadingCursor(input.cursor, "user_definitions_reading");
      if (cursor !== null) {
        conditions.push("(w.reading > ? or (w.reading = ? and d.id > ?))");
        parameters.push(cursor.reading, cursor.reading, cursor.id);
      }
      orderBy = "w.reading asc, d.id asc";
      cursorFactory = (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "user_definitions_reading",
          reading: row.reading,
          version: 1,
        } satisfies ReadingCursor);
    } else {
      const cursor =
        input.cursor === undefined
          ? null
          : decodeDescendingCursor(input.cursor, "user_definitions_newest");
      if (cursor !== null) {
        conditions.push(
          "(coalesce(d.finalized_at, d.updated_at) < ? or (coalesce(d.finalized_at, d.updated_at) = ? and d.id < ?))",
        );
        parameters.push(cursor.sortAt, cursor.sortAt, cursor.id);
      }
      orderBy = "sort_at desc, d.id desc";
      cursorFactory = (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "user_definitions_newest",
          sortAt: row.sort_at,
          version: 1,
        } satisfies DescendingCursor);
    }
    const rows = (
      await this.env.DB.prepare(
        `select ${definitionColumns()}
         from definitions d
         join words w on w.id = d.word_id
         join users u on u.id = d.author_id and u.deleted_at is null
         where ${conditions.join(" and ")}
         order by ${orderBy}
         limit ?`,
      )
        .bind(...parameters, input.limit + 1)
        .all<DefinitionListRow>()
    ).results;
    return page(
      rows,
      input.limit,
      (row) => toDefinition(row, this.env.AVATAR_BASE_URL),
      cursorFactory,
    );
  }

  async listLikedDefinitions(
    viewerUid: string,
    userId: string,
    limit: number,
    cursorValue?: string,
  ) {
    await requireUser(this.env.DB, userId);
    const cursor =
      cursorValue === undefined ? null : decodeDescendingCursor(cursorValue, "liked_definitions");
    const cursorClause =
      cursor === null ? "" : "and (liked.created_at < ? or (liked.created_at = ? and d.id < ?))";
    const parameters: unknown[] = [viewerUid, userId, viewerUid, viewerUid];
    if (cursor !== null) parameters.push(cursor.sortAt, cursor.sortAt, cursor.id);
    const rows = (
      await this.env.DB.prepare(
        `select ${definitionColumns().replace(
          "coalesce(d.finalized_at, d.updated_at) as sort_at",
          "liked.created_at as sort_at",
        )}
         from likes liked
         join definitions d on d.id = liked.definition_id and d.deleted_at is null
         join words w on w.id = d.word_id
         join users u on u.id = d.author_id and u.deleted_at is null
         where liked.user_id = ? and (d.status = 'public' or d.author_id = ?)
           and not exists(select 1 from user_mutes m
             where m.muter_id = ? and m.muted_user_id = d.author_id)
           ${cursorClause}
         order by liked.created_at desc, d.id desc
         limit ?`,
      )
        .bind(...parameters, limit + 1)
        .all<DefinitionListRow>()
    ).results;
    return page(
      rows,
      limit,
      (row) => toDefinition(row, this.env.AVATAR_BASE_URL),
      (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "liked_definitions",
          sortAt: row.sort_at,
          version: 1,
        } satisfies DescendingCursor),
    );
  }

  async getMyOverview(uid: string) {
    const counts = await this.env.DB.prepare(
      `select
         count(distinct d.word_id) as defined_word_count,
         sum(case when d.status = 'draft' then 1 else 0 end) as draft_count,
         (select count(*) from saved_words s where s.user_id = ?) as saved_word_count
       from definitions d
       where d.author_id = ? and d.deleted_at is null`,
    )
      .bind(uid, uid)
      .first<{ defined_word_count: number; draft_count: number; saved_word_count: number }>();
    const rows = (
      await this.env.DB.prepare(
        `select ${definitionColumns()}
         from definitions d
         join words w on w.id = d.word_id
         join users u on u.id = d.author_id and u.deleted_at is null
         where d.author_id = ? and d.deleted_at is null
         order by d.updated_at desc, d.id desc
         limit 5`,
      )
        .bind(uid, uid)
        .all<DefinitionListRow>()
    ).results;
    return {
      definedWordCount: counts?.defined_word_count ?? 0,
      draftCount: counts?.draft_count ?? 0,
      recentDefinitions: rows.map((row) => toDefinition(row, this.env.AVATAR_BASE_URL)),
      savedWordCount: counts?.saved_word_count ?? 0,
    };
  }

  async listDefinedWords(uid: string, limit: number, cursorValue?: string) {
    const cursor =
      cursorValue === undefined ? null : decodeReadingCursor(cursorValue, "defined_words");
    const cursorClause =
      cursor === null ? "" : "and (w.reading > ? or (w.reading = ? and w.id > ?))";
    const statement = this.env.DB.prepare(
      `select w.id, w.word, w.reading,
         sum(case when d.status = 'public' then 1 else 0 end) as public_count,
         sum(case when d.status = 'private' then 1 else 0 end) as private_count,
         sum(case when d.status = 'draft' then 1 else 0 end) as draft_count
       from definitions d join words w on w.id = d.word_id
       where d.author_id = ? and d.deleted_at is null ${cursorClause}
       group by w.id, w.word, w.reading
       order by w.reading asc, w.id asc limit ?`,
    );
    type Row = {
      id: string;
      word: string;
      reading: string;
      public_count: number;
      private_count: number;
      draft_count: number;
    };
    const rows = (
      await (
        cursor === null
          ? statement.bind(uid, limit + 1)
          : statement.bind(uid, cursor.reading, cursor.reading, cursor.id, limit + 1)
      ).all<Row>()
    ).results;
    return page(
      rows,
      limit,
      (row) => ({
        draftCount: row.draft_count,
        privateCount: row.private_count,
        publicCount: row.public_count,
        word: { id: row.id, reading: row.reading, word: row.word },
      }),
      (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "defined_words",
          reading: row.reading,
          version: 1,
        } satisfies ReadingCursor),
    );
  }

  async listMyDefinitions(
    uid: string,
    limit: number,
    status?: DefinitionStatus,
    cursorValue?: string,
  ) {
    const cursor =
      cursorValue === undefined ? null : decodeDescendingCursor(cursorValue, "my_definitions");
    const conditions = ["d.author_id = ?", "d.deleted_at is null"];
    const parameters: unknown[] = [uid, uid];
    if (status !== undefined) {
      conditions.push("d.status = ?");
      parameters.push(status);
    }
    if (cursor !== null) {
      conditions.push("(d.updated_at < ? or (d.updated_at = ? and d.id < ?))");
      parameters.push(cursor.sortAt, cursor.sortAt, cursor.id);
    }
    const rows = (
      await this.env.DB.prepare(
        `select ${definitionColumns().replace(
          "coalesce(d.finalized_at, d.updated_at) as sort_at",
          "d.updated_at as sort_at",
        )}
         from definitions d join words w on w.id = d.word_id
         join users u on u.id = d.author_id and u.deleted_at is null
         where ${conditions.join(" and ")}
         order by d.updated_at desc, d.id desc limit ?`,
      )
        .bind(...parameters, limit + 1)
        .all<DefinitionListRow>()
    ).results;
    return page(
      rows,
      limit,
      (row) => toDefinition(row, this.env.AVATAR_BASE_URL),
      (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "my_definitions",
          sortAt: row.sort_at,
          version: 1,
        } satisfies DescendingCursor),
    );
  }

  async listSavedWords(uid: string, limit: number, cursorValue?: string) {
    const cursor =
      cursorValue === undefined ? null : decodeDescendingCursor(cursorValue, "saved_words");
    const cursorClause =
      cursor === null ? "" : "and (s.created_at < ? or (s.created_at = ? and w.id < ?))";
    const parameters: unknown[] = [uid];
    if (cursor !== null) parameters.push(cursor.sortAt, cursor.sortAt, cursor.id);
    type Row = {
      id: string;
      word: string;
      reading: string;
      is_defined_by_me: number;
      saved_at: number;
    };
    const rows = (
      await this.env.DB.prepare(
        `select w.id, w.word, w.reading, s.created_at as saved_at,
           exists(select 1 from definitions d
            where d.word_id = w.id and d.author_id = ? and d.deleted_at is null) as is_defined_by_me
         from saved_words s join words w on w.id = s.word_id
         where s.user_id = ? ${cursorClause}
         order by s.created_at desc, w.id desc limit ?`,
      )
        .bind(uid, ...parameters, limit + 1)
        .all<Row>()
    ).results;
    return page(
      rows,
      limit,
      (row) => ({
        isDefinedByMe: row.is_defined_by_me !== 0,
        word: { id: row.id, reading: row.reading, word: row.word },
      }),
      (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "saved_words",
          sortAt: row.saved_at,
          version: 1,
        } satisfies DescendingCursor),
    );
  }

  async listMutes(uid: string, limit: number, cursorValue?: string) {
    const cursor = cursorValue === undefined ? null : decodeDescendingCursor(cursorValue, "mutes");
    const cursorClause =
      cursor === null ? "" : "and (m.created_at < ? or (m.created_at = ? and u.id < ?))";
    const parameters: unknown[] = [uid, uid, uid];
    if (cursor !== null) parameters.push(cursor.sortAt, cursor.sortAt, cursor.id);
    const rows = (
      await this.env.DB.prepare(
        `select u.id, u.public_id, u.name, u.avatar_key, m.created_at as relation_created_at,
           exists(select 1 from follows mine
            where mine.follower_id = ? and mine.following_id = u.id) as is_followed_by_me,
           exists(select 1 from user_mutes mine
            where mine.muter_id = ? and mine.muted_user_id = u.id) as is_muted_by_me
         from user_mutes m join users u on u.id = m.muted_user_id and u.deleted_at is null
         where m.muter_id = ? ${cursorClause}
         order by m.created_at desc, u.id desc limit ?`,
      )
        .bind(...parameters, limit + 1)
        .all<UserListRow>()
    ).results;
    return page(
      rows,
      limit,
      (row) => userItem(row, this.env.AVATAR_BASE_URL),
      (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "mutes",
          sortAt: row.relation_created_at,
          version: 1,
        } satisfies DescendingCursor),
    );
  }

  async listWordDefinitions(
    uid: string,
    wordId: string,
    input: {
      cursor?: string | undefined;
      limit: number;
      scope: "mine" | "others" | "all";
      sort: "newest" | "reactions";
    },
  ) {
    await requireWord(this.env.DB, wordId);
    const visibility =
      input.scope === "mine"
        ? "d.author_id = ?"
        : input.scope === "others"
          ? "d.author_id <> ? and d.status = 'public'"
          : "(d.author_id = ? or d.status = 'public')";
    const conditions = [
      "d.word_id = ?",
      "d.deleted_at is null",
      visibility,
      `not exists(select 1 from user_mutes m
        where m.muter_id = ? and m.muted_user_id = d.author_id)`,
    ];
    const parameters: unknown[] = [uid, wordId, uid, uid];
    let orderBy: string;
    let cursorFactory: (row: DefinitionListRow) => string;
    if (input.sort === "reactions") {
      const parsed =
        input.cursor === undefined
          ? null
          : decodeCursor(input.cursor, "word_definitions_reactions");
      let cursor: ReactionCursor | null = null;
      if (parsed !== null) {
        if (
          typeof parsed["likesCount"] !== "number" ||
          !Number.isSafeInteger(parsed["likesCount"]) ||
          typeof parsed["sortAt"] !== "number" ||
          !Number.isSafeInteger(parsed["sortAt"]) ||
          typeof parsed["id"] !== "string" ||
          parsed["id"].length === 0
        ) {
          throw new ApiError(400, "invalid_cursor", "Invalid cursor");
        }
        cursor = parsed as unknown as ReactionCursor;
      }
      if (cursor !== null) {
        const likesCount = activeLikesCount();
        conditions.push(
          `(${likesCount} < ?
           or (${likesCount} = ?
             and (coalesce(d.finalized_at, d.updated_at) < ?
               or (coalesce(d.finalized_at, d.updated_at) = ? and d.id < ?))))`,
        );
        parameters.push(
          cursor.likesCount,
          cursor.likesCount,
          cursor.sortAt,
          cursor.sortAt,
          cursor.id,
        );
      }
      orderBy = "likes_count desc, sort_at desc, d.id desc";
      cursorFactory = (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "word_definitions_reactions",
          likesCount: row.likes_count,
          sortAt: row.sort_at,
          version: 1,
        } satisfies ReactionCursor);
    } else {
      const cursor =
        input.cursor === undefined
          ? null
          : decodeDescendingCursor(input.cursor, "word_definitions_newest");
      if (cursor !== null) {
        conditions.push(
          "(coalesce(d.finalized_at, d.updated_at) < ? or (coalesce(d.finalized_at, d.updated_at) = ? and d.id < ?))",
        );
        parameters.push(cursor.sortAt, cursor.sortAt, cursor.id);
      }
      orderBy = "sort_at desc, d.id desc";
      cursorFactory = (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "word_definitions_newest",
          sortAt: row.sort_at,
          version: 1,
        } satisfies DescendingCursor);
    }
    const rows = (
      await this.env.DB.prepare(
        `select ${definitionColumns()}
         from definitions d join words w on w.id = d.word_id
         join users u on u.id = d.author_id and u.deleted_at is null
         where ${conditions.join(" and ")}
         order by ${orderBy} limit ?`,
      )
        .bind(...parameters, input.limit + 1)
        .all<DefinitionListRow>()
    ).results;
    return page(
      rows,
      input.limit,
      (row) => toDefinition(row, this.env.AVATAR_BASE_URL),
      cursorFactory,
    );
  }

  async listDiscover(uid: string, limit: number, cursorValue?: string) {
    const parsed =
      cursorValue === undefined ? null : decodeCursor(cursorValue, "timeline_discover");
    let cursor: DiscoverCursor | null = null;
    if (parsed !== null) {
      if (
        typeof parsed["sortAt"] !== "number" ||
        !Number.isSafeInteger(parsed["sortAt"]) ||
        (parsed["type"] !== "definition" && parsed["type"] !== "wordRegistered") ||
        typeof parsed["id"] !== "string" ||
        parsed["id"].length === 0
      ) {
        throw new ApiError(400, "invalid_cursor", "Invalid cursor");
      }
      cursor = parsed as unknown as DiscoverCursor;
    }
    const cursorClause =
      cursor === null
        ? ""
        : `where (a.occurred_at < ?
           or (a.occurred_at = ? and (a.type < ? or (a.type = ? and a.item_id < ?))))`;
    const parameters: unknown[] = [uid, uid];
    if (cursor !== null) {
      parameters.push(cursor.sortAt, cursor.sortAt, cursor.type, cursor.type, cursor.id);
    }
    type DiscoverRow = DefinitionListRow & {
      type: "definition" | "wordRegistered";
      item_id: string;
      occurred_at: number;
      activity_word_id: string;
      activity_word: string;
      activity_reading: string;
    };
    const rows = (
      await this.env.DB.prepare(
        `with activities as (
           select 'definition' as type, d.id as item_id, d.finalized_at as occurred_at
           from definitions d join users author on author.id = d.author_id and author.deleted_at is null
           where d.status = 'public' and d.deleted_at is null
             and not exists(select 1 from user_mutes m
              where m.muter_id = ? and m.muted_user_id = d.author_id)
           union all
           select 'wordRegistered', source.id, source.created_at
           from words source
           where source.created_by is null or not exists(select 1 from user_mutes m
             where m.muter_id = ? and m.muted_user_id = source.created_by)
         )
         select a.type, a.item_id, a.occurred_at,
           d.id, d.word_id, w.word, w.reading,
           d.author_id, u.public_id as author_public_id, u.name as author_name,
           u.avatar_key as author_avatar_key, d.body, d.status, d.finalized_at,
           d.is_edited, d.created_at, d.updated_at,
           ${activeLikesCount()} as likes_count,
           exists(select 1 from likes mine where mine.definition_id = d.id and mine.user_id = ?) as is_liked_by_me,
           a.occurred_at as sort_at,
           w.id as activity_word_id, w.word as activity_word, w.reading as activity_reading
         from activities a
         left join definitions d on a.type = 'definition' and d.id = a.item_id
         join words w on w.id = case when a.type = 'definition' then d.word_id else a.item_id end
         left join users u on u.id = d.author_id and u.deleted_at is null
         ${cursorClause}
         order by a.occurred_at desc, a.type desc, a.item_id desc limit ?`,
      )
        .bind(uid, ...parameters, limit + 1)
        .all<DiscoverRow>()
    ).results;
    return page(
      rows,
      limit,
      (row) =>
        row.type === "definition"
          ? {
              definition: toDefinition(row, this.env.AVATAR_BASE_URL),
              occurredAt: new Date(row.occurred_at).toISOString(),
              type: "definition" as const,
            }
          : {
              occurredAt: new Date(row.occurred_at).toISOString(),
              type: "wordRegistered" as const,
              word: {
                id: row.activity_word_id,
                reading: row.activity_reading,
                word: row.activity_word,
              },
            },
      (row) =>
        encodeOpaqueCursor({
          id: row.item_id,
          kind: "timeline_discover",
          sortAt: row.occurred_at,
          type: row.type,
          version: 1,
        } satisfies DiscoverCursor),
    );
  }

  async listFollowing(uid: string, limit: number, cursorValue?: string) {
    const cursor =
      cursorValue === undefined ? null : decodeDescendingCursor(cursorValue, "timeline_following");
    const cursorClause =
      cursor === null ? "" : "and (d.finalized_at < ? or (d.finalized_at = ? and d.id < ?))";
    const parameters: unknown[] = [uid, uid, uid];
    if (cursor !== null) parameters.push(cursor.sortAt, cursor.sortAt, cursor.id);
    const rows = (
      await this.env.DB.prepare(
        `select ${definitionColumns().replace(
          "coalesce(d.finalized_at, d.updated_at) as sort_at",
          "d.finalized_at as sort_at",
        )}
         from definitions d join words w on w.id = d.word_id
         join users u on u.id = d.author_id and u.deleted_at is null
         where d.status = 'public' and d.deleted_at is null
           and exists(select 1 from follows f where f.follower_id = ? and f.following_id = d.author_id)
           and not exists(select 1 from user_mutes m where m.muter_id = ? and m.muted_user_id = d.author_id)
           ${cursorClause}
         order by d.finalized_at desc, d.id desc limit ?`,
      )
        .bind(...parameters, limit + 1)
        .all<DefinitionListRow>()
    ).results;
    return page(
      rows,
      limit,
      (row) => toDefinition(row, this.env.AVATAR_BASE_URL),
      (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "timeline_following",
          sortAt: row.sort_at,
          version: 1,
        } satisfies DescendingCursor),
    );
  }

  async searchWords(uid: string, query: string, limit: number, cursorValue?: string) {
    const cursor =
      cursorValue === undefined ? null : decodeReadingCursor(cursorValue, "search_words");
    const cursorClause =
      cursor === null ? "" : "and (w.reading > ? or (w.reading = ? and w.id > ?))";
    const pattern = `%${escapeLikePattern(query)}%`;
    const parameters: unknown[] = [uid, pattern, pattern, uid];
    if (cursor !== null) parameters.push(cursor.reading, cursor.reading, cursor.id);
    const rows = (
      await this.env.DB.prepare(
        `select w.id, w.word, w.reading, w.reading_sub_group,
           (select count(*) from definitions d
            join users author on author.id = d.author_id and author.deleted_at is null
            where d.word_id = w.id and d.status = 'public' and d.deleted_at is null
              and not exists(select 1 from user_mutes m
                where m.muter_id = ? and m.muted_user_id = d.author_id))
             as public_definition_count
         from words w
         where (w.word like ? escape '\\' or w.reading like ? escape '\\')
           and (w.created_by is null or not exists(select 1 from user_mutes m
             where m.muter_id = ? and m.muted_user_id = w.created_by))
           ${cursorClause}
         order by w.reading asc, w.id asc limit ?`,
      )
        .bind(...parameters, limit + 1)
        .all<WordListRow>()
    ).results;
    return page(rows, limit, wordItem, (row) =>
      encodeOpaqueCursor({
        id: row.id,
        kind: "search_words",
        reading: row.reading,
        version: 1,
      } satisfies ReadingCursor),
    );
  }

  async searchUsers(uid: string, query: string, limit: number, cursorValue?: string) {
    const cursor =
      cursorValue === undefined ? null : decodeReadingCursor(cursorValue, "search_users");
    const cursorClause =
      cursor === null ? "" : "and (u.public_id > ? or (u.public_id = ? and u.id > ?))";
    const pattern = `%${escapeLikePattern(query)}%`;
    const parameters: unknown[] = [uid, uid, pattern, pattern, uid];
    if (cursor !== null) parameters.push(cursor.reading, cursor.reading, cursor.id);
    const rows = (
      await this.env.DB.prepare(
        `select u.id, u.public_id, u.name, u.avatar_key, 0 as relation_created_at,
           exists(select 1 from follows mine
            where mine.follower_id = ? and mine.following_id = u.id) as is_followed_by_me,
           exists(select 1 from user_mutes mine
            where mine.muter_id = ? and mine.muted_user_id = u.id) as is_muted_by_me
         from users u
         where u.deleted_at is null
           and (u.name like ? escape '\\' or u.public_id like ? escape '\\')
           and not exists(select 1 from user_mutes muted
            where muted.muter_id = ? and muted.muted_user_id = u.id)
           ${cursorClause}
         order by u.public_id asc, u.id asc limit ?`,
      )
        .bind(...parameters, limit + 1)
        .all<UserListRow>()
    ).results;
    return page(
      rows,
      limit,
      (row) => userItem(row, this.env.AVATAR_BASE_URL),
      (row) =>
        encodeOpaqueCursor({
          id: row.id,
          kind: "search_users",
          reading: row.public_id,
          version: 1,
        } satisfies ReadingCursor),
    );
  }
}
