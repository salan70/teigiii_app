import { ApiError } from "../errors";
import { decodeOpaqueCursor, encodeOpaqueCursor } from "../lib/cursor";
import { uuidv7 } from "../lib/uuidv7";

const editWindowMilliseconds = 60 * 60 * 1000;
// 楽観ロックの再試行上限。自分の定義への並行更新だけが対象のため衝突は稀
const maxUpdateAttempts = 3;

type DefinitionBindings = {
  AVATAR_BASE_URL: string;
  DB: D1Database;
};

type DefinitionStatus = "public" | "private";

type DefinitionRow = {
  id: string;
  word_id: string;
  author_id: string;
  body: string;
  status: DefinitionStatus;
  finalized_at: number;
  is_edited: number;
  created_at: number;
  updated_at: number;
};

type DefinitionDetailRow = DefinitionRow & {
  word: string;
  reading: string;
  author_public_id: string;
  author_name: string;
  author_avatar_key: string | null;
  likes_count: number;
  is_liked_by_me: number;
};

type LikedUserRow = {
  id: string;
  public_id: string;
  name: string;
  avatar_key: string | null;
  liked_at: number;
  is_followed_by_me: number;
  is_muted_by_me: number;
};

type LikedUsersCursor = {
  createdAt: number;
  kind: "definition_likes";
  userId: string;
  version: 1;
};

export type CreateDefinitionInput = {
  body: string;
  status: DefinitionStatus;
  wordId: string;
};

export type UpdateDefinitionInput = {
  body?: string | undefined;
  status?: DefinitionStatus | undefined;
};

function avatarUrl(baseUrl: string, key: string | null): string | null {
  if (key === null) return null;
  return `${baseUrl.replace(/\/+$/, "")}/${key}`;
}

function decodeLikedUsersCursor(value: string): LikedUsersCursor {
  const parsed = decodeOpaqueCursor(value);
  if (
    parsed["version"] !== 1 ||
    parsed["kind"] !== "definition_likes" ||
    typeof parsed["createdAt"] !== "number" ||
    !Number.isSafeInteger(parsed["createdAt"]) ||
    typeof parsed["userId"] !== "string" ||
    parsed["userId"].length === 0
  ) {
    throw new ApiError(400, "invalid_cursor", "Invalid cursor");
  }
  return parsed as unknown as LikedUsersCursor;
}

function definitionNotFound(): never {
  throw new ApiError(404, "definition_not_found", "Definition not found");
}

/**
 * D1 上の定義の作成・取得・状態遷移・期限付き本文編集・論理削除・いいねを扱う。
 *
 * @doc doc/specs/workers-api-server.md#定義
 */
export class DefinitionService {
  constructor(private readonly env: DefinitionBindings) {}

  async #requireActiveUser(uid: string): Promise<void> {
    const user = await this.env.DB.prepare(
      "select id from users where id = ? and deleted_at is null",
    )
      .bind(uid)
      .first();
    if (user === null) throw new ApiError(404, "user_not_found", "User not found");
  }

  async #requireWordExists(wordId: string): Promise<void> {
    const word = await this.env.DB.prepare("select id from words where id = ?")
      .bind(wordId)
      .first();
    if (word === null) throw new ApiError(404, "word_not_found", "Word not found");
  }

  /** 削除済み・作者が論理削除済みの定義は存在しないものとして扱う。可視性判定は呼び出し側で行う。 */
  async #findRow(id: string): Promise<DefinitionRow | null> {
    return this.env.DB.prepare(
      `select d.id, d.word_id, d.author_id, d.body, d.status, d.finalized_at, d.is_edited,
              d.created_at, d.updated_at
       from definitions d
       join users u on u.id = d.author_id and u.deleted_at is null
       where d.id = ? and d.deleted_at is null`,
    )
      .bind(id)
      .first<DefinitionRow>();
  }

  /** 本人の全状態 + 他者の public だけを可視とする。それ以外は 404 で存在を秘匿する。 */
  async #requireVisibleRow(uid: string, id: string): Promise<DefinitionRow> {
    const row = await this.#findRow(id);
    if (row === null || (row.author_id !== uid && row.status !== "public")) definitionNotFound();
    return row;
  }

  async #getDetail(uid: string, id: string) {
    const row = await this.env.DB.prepare(
      `select
         d.id, d.word_id, d.author_id, d.body, d.status, d.finalized_at, d.is_edited,
         d.created_at, d.updated_at,
         w.word, w.reading,
         u.public_id as author_public_id,
         u.name as author_name,
         u.avatar_key as author_avatar_key,
         (select count(*) from likes l
          join users lu on lu.id = l.user_id and lu.deleted_at is null
          where l.definition_id = d.id) as likes_count,
         exists(select 1 from likes l
          where l.definition_id = d.id and l.user_id = ?) as is_liked_by_me
       from definitions d
       join words w on w.id = d.word_id
       join users u on u.id = d.author_id and u.deleted_at is null
       where d.id = ? and d.deleted_at is null`,
    )
      .bind(uid, id)
      .first<DefinitionDetailRow>();
    if (row === null || (row.author_id !== uid && row.status !== "public")) definitionNotFound();

    const editableUntil = row.finalized_at + editWindowMilliseconds;
    return {
      author: {
        avatarUrl: avatarUrl(this.env.AVATAR_BASE_URL, row.author_avatar_key),
        id: row.author_id,
        name: row.author_name,
        publicId: row.author_public_id,
      },
      body: row.body,
      createdAt: new Date(row.created_at).toISOString(),
      editableUntil: new Date(editableUntil).toISOString(),
      finalizedAt: new Date(row.finalized_at).toISOString(),
      id: row.id,
      isEdited: row.is_edited !== 0,
      isLikedByMe: row.is_liked_by_me !== 0,
      likesCount: row.likes_count,
      status: row.status,
      updatedAt: new Date(row.updated_at).toISOString(),
      word: { id: row.word_id, reading: row.reading, word: row.word },
    };
  }

  async create(uid: string, input: CreateDefinitionInput) {
    await this.#requireActiveUser(uid);
    await this.#requireWordExists(input.wordId);

    const id = uuidv7();
    const now = Date.now();
    await this.env.DB.prepare(
      `insert into definitions (id, word_id, author_id, body, status, finalized_at, is_edited, created_at, updated_at)
       values (?, ?, ?, ?, ?, ?, 0, ?, ?)`,
    )
      .bind(id, input.wordId, uid, input.body, input.status, now, now, now)
      .run();
    return this.#getDetail(uid, id);
  }

  async get(uid: string, id: string) {
    return this.#getDetail(uid, id);
  }

  async update(uid: string, id: string, input: UpdateDefinitionInput) {
    // 本文と公開範囲の並行更新で片方を失わないよう、観測した status / updated_at を条件にした
    // 楽観ロックで更新し、外れたら最新状態から再評価する。
    for (let attempt = 0; attempt < maxUpdateAttempts; attempt += 1) {
      const row = await this.#findRow(id);
      if (row === null || (row.author_id !== uid && row.status !== "public")) definitionNotFound();
      if (row.author_id !== uid) throw new ApiError(403, "forbidden", "Forbidden");

      const now = Date.now();
      const nextStatus = input.status ?? row.status;

      const bodyChanged = input.body !== undefined && input.body !== row.body;
      if (bodyChanged && now - row.finalized_at >= editWindowMilliseconds) {
        throw new ApiError(403, "edit_window_expired", "Edit window expired");
      }

      const isEdited = row.is_edited !== 0 || bodyChanged;

      const result = await this.env.DB.prepare(
        `update definitions
         set word_id = ?, body = ?, status = ?, finalized_at = ?, is_edited = ?, updated_at = ?
         where id = ? and status = ? and updated_at = ?`,
      )
        .bind(
          row.word_id,
          input.body ?? row.body,
          nextStatus,
          row.finalized_at,
          isEdited ? 1 : 0,
          now,
          id,
          row.status,
          row.updated_at,
        )
        .run();
      if (result.meta.changes > 0) return this.#getDetail(uid, id);
    }
    throw new ApiError(500, "definition_update_conflict", "Internal Server Error");
  }

  async delete(uid: string, id: string): Promise<void> {
    const row = await this.#findRow(id);
    if (row === null || (row.author_id !== uid && row.status !== "public")) definitionNotFound();
    if (row.author_id !== uid) throw new ApiError(403, "forbidden", "Forbidden");

    const now = Date.now();
    await this.env.DB.prepare("update definitions set deleted_at = ?, updated_at = ? where id = ?")
      .bind(now, now, id)
      .run();
  }

  async like(uid: string, id: string): Promise<void> {
    await this.#requireActiveUser(uid);
    await this.#requireVisibleRow(uid, id);
    // 可視性チェックと INSERT の間に削除・非公開化が入る TOCTOU を防ぐため、
    // 可視条件を述語に含めた単一文で挿入する
    await this.env.DB.prepare(
      `insert or ignore into likes (user_id, definition_id, created_at)
       select ?, d.id, ?
       from definitions d
       join users u on u.id = d.author_id and u.deleted_at is null
       where d.id = ? and d.deleted_at is null and (d.author_id = ? or d.status = 'public')`,
    )
      .bind(uid, Date.now(), id, uid)
      .run();
  }

  async unlike(uid: string, id: string): Promise<void> {
    await this.env.DB.prepare("delete from likes where user_id = ? and definition_id = ?")
      .bind(uid, id)
      .run();
  }

  async listLikedUsers(uid: string, id: string, limit: number, cursorValue?: string) {
    await this.#requireVisibleRow(uid, id);
    const cursor = cursorValue === undefined ? null : decodeLikedUsersCursor(cursorValue);
    const cursorClause =
      cursor === null ? "" : "and (l.created_at < ? or (l.created_at = ? and l.user_id < ?))";
    const statement = this.env.DB.prepare(
      `select
         u.id,
         u.public_id,
         u.name,
         u.avatar_key,
         l.created_at as liked_at,
         exists(select 1 from follows mine
          where mine.follower_id = ? and mine.following_id = u.id) as is_followed_by_me,
         exists(select 1 from user_mutes mine
          where mine.muter_id = ? and mine.muted_user_id = u.id) as is_muted_by_me
       from likes l
       join users u on u.id = l.user_id and u.deleted_at is null
       where l.definition_id = ? ${cursorClause}
       order by l.created_at desc, l.user_id desc
       limit ?`,
    );
    const bound =
      cursor === null
        ? statement.bind(uid, uid, id, limit + 1)
        : statement.bind(
            uid,
            uid,
            id,
            cursor.createdAt,
            cursor.createdAt,
            cursor.userId,
            limit + 1,
          );
    const rows = (await bound.all<LikedUserRow>()).results;

    const hasNextPage = rows.length > limit;
    const pageRows = rows.slice(0, limit);
    const last = pageRows.at(-1);
    return {
      items: pageRows.map((row) => ({
        avatarUrl: avatarUrl(this.env.AVATAR_BASE_URL, row.avatar_key),
        id: row.id,
        isFollowedByMe: row.is_followed_by_me !== 0,
        isMutedByMe: row.is_muted_by_me !== 0,
        name: row.name,
        publicId: row.public_id,
      })),
      nextCursor:
        hasNextPage && last !== undefined
          ? encodeOpaqueCursor({
              createdAt: last.liked_at,
              kind: "definition_likes",
              userId: last.id,
              version: 1,
            } satisfies LikedUsersCursor)
          : null,
    };
  }
}
