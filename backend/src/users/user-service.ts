import { ApiError } from "../errors";

const maxPublicIdAttempts = 10;
const maxAvatarBytes = 10 * 1024 * 1024;

type UserBindings = {
  AVATARS: R2Bucket;
  AVATAR_BASE_URL: string;
  DB: D1Database;
};

type UserRow = {
  avatar_key: string | null;
  bio: string;
  created_at: number;
  id: string;
  name: string;
  public_id: string;
};

type PublicUserRow = UserRow & {
  follower_count: number;
  following_count: number;
  is_followed_by_me: number;
  is_muted_by_me: number;
  public_definition_count: number;
};

type UserListRow = UserRow & {
  is_followed_by_me: number;
  is_muted_by_me: number;
  relation_created_at: number;
};

type UserListKind = "followers" | "following";

type UserListCursor = {
  createdAt: number;
  kind: UserListKind;
  userId: string;
  version: 1;
};

export type CreateUserInput = {
  appVersion: string;
  bio: string;
  name: string;
  osVersion: string;
};

export type UpdateUserInput = {
  appVersion?: string | undefined;
  bio?: string | undefined;
  name?: string | undefined;
  osVersion?: string | undefined;
};

export type UserServiceOptions = {
  generatePublicId?: () => string;
  now?: () => number;
};

function defaultGeneratePublicId(): string {
  const maximumUnbiasedValue = 4_000_000_000;
  const values = new Uint32Array(1);
  do {
    crypto.getRandomValues(values);
  } while ((values[0] ?? maximumUnbiasedValue) >= maximumUnbiasedValue);
  return String((values[0] ?? 0) % 1_000_000_000).padStart(9, "0");
}

function avatarUrl(baseUrl: string, key: string | null): string | null {
  if (key === null) return null;
  return `${baseUrl.replace(/\/+$/, "")}/${key}`;
}

function toMeResponse(row: UserRow, baseUrl: string) {
  return {
    avatarUrl: avatarUrl(baseUrl, row.avatar_key),
    bio: row.bio,
    createdAt: new Date(row.created_at).toISOString(),
    id: row.id,
    name: row.name,
    publicId: row.public_id,
  };
}

function toListItem(row: UserListRow, baseUrl: string) {
  return {
    avatarUrl: avatarUrl(baseUrl, row.avatar_key),
    id: row.id,
    isFollowedByMe: row.is_followed_by_me !== 0,
    isMutedByMe: row.is_muted_by_me !== 0,
    name: row.name,
    publicId: row.public_id,
  };
}

function encodeCursor(cursor: UserListCursor): string {
  const bytes = new TextEncoder().encode(JSON.stringify(cursor));
  return btoa(String.fromCharCode(...bytes))
    .replaceAll("+", "-")
    .replaceAll("/", "_")
    .replace(/=+$/, "");
}

function decodeCursor(value: string, expectedKind: UserListKind): UserListCursor {
  try {
    const base64 = value.replaceAll("-", "+").replaceAll("_", "/");
    const padded = base64.padEnd(Math.ceil(base64.length / 4) * 4, "=");
    const binary = atob(padded);
    const bytes = Uint8Array.from(binary, (character) => character.charCodeAt(0));
    const parsed: unknown = JSON.parse(new TextDecoder().decode(bytes));
    if (
      typeof parsed !== "object" ||
      parsed === null ||
      !("version" in parsed) ||
      parsed.version !== 1 ||
      !("kind" in parsed) ||
      parsed.kind !== expectedKind ||
      !("createdAt" in parsed) ||
      typeof parsed.createdAt !== "number" ||
      !Number.isSafeInteger(parsed.createdAt) ||
      !("userId" in parsed) ||
      typeof parsed.userId !== "string" ||
      parsed.userId.length === 0
    ) {
      throw new Error("invalid cursor payload");
    }
    return parsed as UserListCursor;
  } catch {
    throw new ApiError(400, "invalid_cursor", "Invalid cursor");
  }
}

async function findActiveUser(db: D1Database, id: string): Promise<UserRow | null> {
  return db
    .prepare(
      `select id, public_id, name, bio, avatar_key, created_at
       from users
       where id = ? and deleted_at is null`,
    )
    .bind(id)
    .first<UserRow>();
}

async function requireActiveUser(db: D1Database, id: string): Promise<UserRow> {
  const user = await findActiveUser(db, id);
  if (user === null) throw new ApiError(404, "user_not_found", "User not found");
  return user;
}

/**
 * D1 上のユーザー CRUD、フォロー、ミュート、関連一覧を扱う。
 *
 * @doc doc/specs/workers-api-server.md#ユーザー
 */
export class UserService {
  readonly #generatePublicId: () => string;
  readonly #now: () => number;

  constructor(
    private readonly env: UserBindings,
    { generatePublicId = defaultGeneratePublicId, now = Date.now }: UserServiceOptions = {},
  ) {
    this.#generatePublicId = generatePublicId;
    this.#now = now;
  }

  async create(uid: string, input: CreateUserInput) {
    const existing = await this.env.DB.prepare("select id from users where id = ?")
      .bind(uid)
      .first();
    if (existing !== null) {
      throw new ApiError(409, "user_already_exists", "User already exists");
    }

    for (let attempt = 0; attempt < maxPublicIdAttempts; attempt += 1) {
      const publicId = this.#generatePublicId();
      if (!/^\d{9}$/.test(publicId)) {
        throw new Error("generatePublicId must return exactly 9 digits");
      }
      const now = this.#now();
      try {
        await this.env.DB.prepare(
          `insert into users
             (id, public_id, name, bio, last_os_version, last_app_version, created_at, updated_at)
           values (?, ?, ?, ?, ?, ?, ?, ?)`,
        )
          .bind(uid, publicId, input.name, input.bio, input.osVersion, input.appVersion, now, now)
          .run();
        return toMeResponse(
          {
            avatar_key: null,
            bio: input.bio,
            created_at: now,
            id: uid,
            name: input.name,
            public_id: publicId,
          },
          this.env.AVATAR_BASE_URL,
        );
      } catch (error) {
        const concurrentlyCreated = await this.env.DB.prepare("select id from users where id = ?")
          .bind(uid)
          .first();
        if (concurrentlyCreated !== null) {
          throw new ApiError(409, "user_already_exists", "User already exists");
        }
        const publicIdCollision = await this.env.DB.prepare(
          "select id from users where public_id = ?",
        )
          .bind(publicId)
          .first();
        if (publicIdCollision === null) throw error;
      }
    }

    throw new ApiError(500, "public_id_generation_failed", "Internal Server Error");
  }

  async getMe(uid: string) {
    return toMeResponse(await requireActiveUser(this.env.DB, uid), this.env.AVATAR_BASE_URL);
  }

  async update(uid: string, input: UpdateUserInput) {
    const result = await this.env.DB.prepare(
      `update users
       set name = coalesce(?, name),
           bio = coalesce(?, bio),
           last_os_version = coalesce(?, last_os_version),
           last_app_version = coalesce(?, last_app_version),
           updated_at = ?
       where id = ? and deleted_at is null`,
    )
      .bind(
        input.name ?? null,
        input.bio ?? null,
        input.osVersion ?? null,
        input.appVersion ?? null,
        this.#now(),
        uid,
      )
      .run();
    if (result.meta.changes === 0) {
      throw new ApiError(404, "user_not_found", "User not found");
    }
    return this.getMe(uid);
  }

  async delete(uid: string): Promise<void> {
    await requireActiveUser(this.env.DB, uid);
    const now = this.#now();
    await this.env.DB.batch([
      this.env.DB.prepare("update users set deleted_at = ?, updated_at = ? where id = ?").bind(
        now,
        now,
        uid,
      ),
      this.env.DB.prepare(
        "update definitions set deleted_at = ?, updated_at = ? where author_id = ? and deleted_at is null",
      ).bind(now, now, uid),
    ]);
  }

  async getPublic(viewerUid: string, userId: string) {
    const row = await this.env.DB.prepare(
      `select
         u.id,
         u.public_id,
         u.name,
         u.bio,
         u.avatar_key,
         u.created_at,
         (select count(*) from definitions d
          where d.author_id = u.id and d.status = 'public' and d.deleted_at is null)
           as public_definition_count,
         (select count(*) from follows f
          join users followed on followed.id = f.following_id and followed.deleted_at is null
          where f.follower_id = u.id) as following_count,
         (select count(*) from follows f
          join users follower on follower.id = f.follower_id and follower.deleted_at is null
          where f.following_id = u.id) as follower_count,
         exists(select 1 from follows f
          where f.follower_id = ? and f.following_id = u.id) as is_followed_by_me,
         exists(select 1 from user_mutes m
          where m.muter_id = ? and m.muted_user_id = u.id) as is_muted_by_me
       from users u
       where u.id = ? and u.deleted_at is null`,
    )
      .bind(viewerUid, viewerUid, userId)
      .first<PublicUserRow>();
    if (row === null) throw new ApiError(404, "user_not_found", "User not found");

    return {
      ...toMeResponse(row, this.env.AVATAR_BASE_URL),
      followerCount: row.follower_count,
      followingCount: row.following_count,
      isFollowedByMe: row.is_followed_by_me !== 0,
      isMutedByMe: row.is_muted_by_me !== 0,
      publicDefinitionCount: row.public_definition_count,
    };
  }

  async follow(uid: string, targetId: string): Promise<void> {
    if (uid === targetId) throw new ApiError(400, "cannot_follow_self", "Cannot follow self");
    await Promise.all([
      requireActiveUser(this.env.DB, uid),
      requireActiveUser(this.env.DB, targetId),
    ]);
    await this.env.DB.prepare(
      "insert or ignore into follows (follower_id, following_id, created_at) values (?, ?, ?)",
    )
      .bind(uid, targetId, this.#now())
      .run();
  }

  async unfollow(uid: string, targetId: string): Promise<void> {
    if (uid === targetId) throw new ApiError(400, "cannot_follow_self", "Cannot follow self");
    await Promise.all([
      requireActiveUser(this.env.DB, uid),
      requireActiveUser(this.env.DB, targetId),
    ]);
    await this.env.DB.prepare("delete from follows where follower_id = ? and following_id = ?")
      .bind(uid, targetId)
      .run();
  }

  async mute(uid: string, targetId: string): Promise<void> {
    if (uid === targetId) throw new ApiError(400, "cannot_mute_self", "Cannot mute self");
    await Promise.all([
      requireActiveUser(this.env.DB, uid),
      requireActiveUser(this.env.DB, targetId),
    ]);
    await this.env.DB.prepare(
      "insert or ignore into user_mutes (muter_id, muted_user_id, created_at) values (?, ?, ?)",
    )
      .bind(uid, targetId, this.#now())
      .run();
  }

  async unmute(uid: string, targetId: string): Promise<void> {
    if (uid === targetId) throw new ApiError(400, "cannot_mute_self", "Cannot mute self");
    await Promise.all([
      requireActiveUser(this.env.DB, uid),
      requireActiveUser(this.env.DB, targetId),
    ]);
    await this.env.DB.prepare("delete from user_mutes where muter_id = ? and muted_user_id = ?")
      .bind(uid, targetId)
      .run();
  }

  async listRelatedUsers(
    viewerUid: string,
    targetId: string,
    kind: UserListKind,
    limit: number,
    cursorValue?: string,
  ) {
    await requireActiveUser(this.env.DB, targetId);
    const cursor = cursorValue === undefined ? null : decodeCursor(cursorValue, kind);
    const relationUserColumn = kind === "followers" ? "f.follower_id" : "f.following_id";
    const targetColumn = kind === "followers" ? "f.following_id" : "f.follower_id";
    const cursorClause =
      cursor === null
        ? ""
        : `and (f.created_at < ? or (f.created_at = ? and ${relationUserColumn} < ?))`;
    const statement = this.env.DB.prepare(
      `select
         u.id,
         u.public_id,
         u.name,
         u.bio,
         u.avatar_key,
         u.created_at,
         f.created_at as relation_created_at,
         exists(select 1 from follows mine
          where mine.follower_id = ? and mine.following_id = u.id) as is_followed_by_me,
         exists(select 1 from user_mutes mine
          where mine.muter_id = ? and mine.muted_user_id = u.id) as is_muted_by_me
       from follows f
       join users u on u.id = ${relationUserColumn} and u.deleted_at is null
       where ${targetColumn} = ? ${cursorClause}
       order by f.created_at desc, ${relationUserColumn} desc
       limit ?`,
    );
    const bound =
      cursor === null
        ? statement.bind(viewerUid, viewerUid, targetId, limit + 1)
        : statement.bind(
            viewerUid,
            viewerUid,
            targetId,
            cursor.createdAt,
            cursor.createdAt,
            cursor.userId,
            limit + 1,
          );
    const rows = (await bound.all<UserListRow>()).results;
    const hasNextPage = rows.length > limit;
    const pageRows = rows.slice(0, limit);
    const last = pageRows.at(-1);
    return {
      items: pageRows.map((row) => toListItem(row, this.env.AVATAR_BASE_URL)),
      nextCursor:
        hasNextPage && last !== undefined
          ? encodeCursor({
              createdAt: last.relation_created_at,
              kind,
              userId: last.id,
              version: 1,
            })
          : null,
    };
  }
}

function hasJpegSignature(bytes: Uint8Array): boolean {
  return bytes.length >= 3 && bytes[0] === 0xff && bytes[1] === 0xd8 && bytes[2] === 0xff;
}

function hasPngSignature(bytes: Uint8Array): boolean {
  const signature = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];
  return signature.every((value, index) => bytes[index] === value);
}

async function readBodyWithLimit(
  body: ReadableStream<Uint8Array> | null,
  maximumBytes: number,
): Promise<Uint8Array> {
  if (body === null) return new Uint8Array();

  const reader = body.getReader();
  const chunks: Uint8Array[] = [];
  let totalBytes = 0;
  while (true) {
    const result = await reader.read();
    if (result.done) break;
    totalBytes += result.value.byteLength;
    if (totalBytes > maximumBytes) {
      await reader.cancel("image_too_large");
      throw new ApiError(413, "image_too_large", "Image too large");
    }
    chunks.push(result.value);
  }

  const combined = new Uint8Array(totalBytes);
  let offset = 0;
  for (const chunk of chunks) {
    combined.set(chunk, offset);
    offset += chunk.byteLength;
  }
  return combined;
}

/**
 * R2 アバターの形式・容量検証、固定キー保存、削除、認証付き Worker URL 解決を扱う。
 *
 * @doc doc/specs/workers-api-server.md#アバター
 */
export class AvatarService {
  constructor(private readonly env: UserBindings) {}

  async get(viewerUid: string, targetUid: string): Promise<R2ObjectBody> {
    await requireActiveUser(this.env.DB, viewerUid);
    const target = await findActiveUser(this.env.DB, targetUid);
    if (target?.avatar_key == null) {
      throw new ApiError(404, "avatar_not_found", "Avatar not found");
    }
    const object = await this.env.AVATARS.get(target.avatar_key);
    if (object === null) {
      throw new ApiError(404, "avatar_not_found", "Avatar not found");
    }
    return object;
  }

  async upload(uid: string, request: Request): Promise<string> {
    await requireActiveUser(this.env.DB, uid);
    const contentType = request.headers.get("Content-Type")?.split(";", 1)[0]?.trim().toLowerCase();
    if (contentType !== "image/jpeg" && contentType !== "image/png") {
      throw new ApiError(415, "unsupported_image_type", "Unsupported image type");
    }
    const contentLength = Number(request.headers.get("Content-Length"));
    if (Number.isFinite(contentLength) && contentLength > maxAvatarBytes) {
      throw new ApiError(413, "image_too_large", "Image too large");
    }
    const bytes = await readBodyWithLimit(request.body, maxAvatarBytes);
    const signatureMatches =
      contentType === "image/jpeg" ? hasJpegSignature(bytes) : hasPngSignature(bytes);
    if (!signatureMatches) {
      throw new ApiError(415, "unsupported_image_type", "Unsupported image type");
    }

    const key = `avatars/${encodeURIComponent(uid)}`;
    const previousObject = await this.env.AVATARS.get(key);
    const previousBody = previousObject === null ? null : await previousObject.arrayBuffer();
    await this.env.AVATARS.put(key, bytes, { httpMetadata: { contentType } });
    try {
      const result = await this.env.DB.prepare(
        "update users set avatar_key = ?, updated_at = ? where id = ? and deleted_at is null",
      )
        .bind(key, Date.now(), uid)
        .run();
      if (result.meta.changes === 0) {
        throw new ApiError(404, "user_not_found", "User not found");
      }
    } catch (error) {
      try {
        if (previousObject === null || previousBody === null) {
          await this.env.AVATARS.delete(key);
        } else {
          await this.env.AVATARS.put(key, previousBody, {
            ...(previousObject.customMetadata
              ? { customMetadata: previousObject.customMetadata }
              : {}),
            ...(previousObject.httpMetadata ? { httpMetadata: previousObject.httpMetadata } : {}),
          });
        }
      } catch (compensationError) {
        console.error(
          JSON.stringify({
            compensationErrorName:
              compensationError instanceof Error ? compensationError.name : "UnknownError",
            errorName: error instanceof Error ? error.name : "UnknownError",
            event: "avatar_upload_compensation_failed",
          }),
        );
        throw error;
      }
      throw error;
    }
    return avatarUrl(this.env.AVATAR_BASE_URL, key)!;
  }

  async delete(uid: string): Promise<void> {
    const user = await requireActiveUser(this.env.DB, uid);
    const key = user.avatar_key ?? `avatars/${encodeURIComponent(uid)}`;
    const result = await this.env.DB.prepare(
      "update users set avatar_key = null, updated_at = ? where id = ? and deleted_at is null",
    )
      .bind(Date.now(), uid)
      .run();
    if (result.meta.changes === 0) {
      throw new ApiError(404, "user_not_found", "User not found");
    }

    try {
      await this.env.AVATARS.delete(key);
    } catch (error) {
      let objectStillExists = false;
      try {
        objectStillExists = (await this.env.AVATARS.head(key)) !== null;
      } catch (stateCheckError) {
        console.error(
          JSON.stringify({
            errorName: error instanceof Error ? error.name : "UnknownError",
            event: "avatar_deletion_state_check_failed",
            stateCheckErrorName:
              stateCheckError instanceof Error ? stateCheckError.name : "UnknownError",
          }),
        );
      }

      if (objectStillExists && user.avatar_key !== null) {
        try {
          const compensation = await this.env.DB.prepare(
            "update users set avatar_key = ?, updated_at = ? where id = ? and deleted_at is null",
          )
            .bind(user.avatar_key, Date.now(), uid)
            .run();
          if (compensation.meta.changes === 0) {
            throw new ApiError(404, "user_not_found", "User not found");
          }
        } catch (compensationError) {
          console.error(
            JSON.stringify({
              compensationErrorName:
                compensationError instanceof Error ? compensationError.name : "UnknownError",
              errorName: error instanceof Error ? error.name : "UnknownError",
              event: "avatar_deletion_compensation_failed",
            }),
          );
          throw error;
        }
      }
      throw error;
    }
  }
}
