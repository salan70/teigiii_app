import { applyD1Migrations, env } from "cloudflare:test";
import { beforeEach, describe, expect, test } from "vitest";

import { createApp } from "../src/app";
import { AvatarService } from "../src/users/user-service";

const authHeaders = {
  Authorization: "Bearer valid-id-token",
  "X-Firebase-AppCheck": "valid-app-check",
};

function testApp(uid: string) {
  return createApp({
    logRequest: () => {},
    verifyAppCheck: async () => ({ appId: "test-app-id" }),
    verifyFirebaseIdToken: async () => ({ uid }),
  });
}

async function request(uid: string, path: string, init?: RequestInit) {
  const headers = new Headers(authHeaders);
  for (const [key, value] of new Headers(init?.headers)) headers.set(key, value);
  return testApp(uid).request(path, { ...init, headers }, env);
}

async function createUser(uid: string, name = uid) {
  return request(uid, "/v1/users", {
    body: JSON.stringify({
      appVersion: "2.0.0",
      bio: `${name} bio`,
      name,
      osVersion: "iOS 19",
    }),
    headers: { "Content-Type": "application/json" },
    method: "POST",
  });
}

function databaseFailingAvatarKeyUpdate(match: string): D1Database {
  return {
    prepare(query: string) {
      if (!query.includes(match)) return env.DB.prepare(query);
      return {
        bind: () => ({
          run: async () => {
            throw new Error("simulated D1 update failure");
          },
        }),
      } as unknown as D1PreparedStatement;
    },
  } as unknown as D1Database;
}

beforeEach(async () => {
  await applyD1Migrations(env.DB, env.TEST_MIGRATIONS);
  await env.DB.batch([
    env.DB.prepare("delete from users"),
    env.DB.prepare("delete from words"),
    env.DB.prepare("delete from app_config"),
  ]);
  const objects = await env.AVATARS.list();
  if (objects.objects.length > 0) {
    await env.AVATARS.delete(objects.objects.map((object) => object.key));
  }
});

describe("user routes", () => {
  test("publicId の UNIQUE 衝突時は新しい 9 桁 ID で再試行する", async () => {
    const now = Date.now();
    await env.DB.prepare(
      "insert into users (id, public_id, name, bio, last_os_version, last_app_version, created_at, updated_at) values (?, ?, ?, ?, ?, ?, ?, ?)",
    )
      .bind("existing", "123456789", "Existing", "", "iOS 19", "2.0.0", now, now)
      .run();
    const candidates = ["123456789", "987654321"];
    const app = createApp({
      generatePublicId: () => candidates.shift()!,
      logRequest: () => {},
      verifyAppCheck: async () => ({ appId: "test-app-id" }),
      verifyFirebaseIdToken: async () => ({ uid: "alice" }),
    } as Parameters<typeof createApp>[0]);

    const response = await app.request(
      "/v1/users",
      {
        body: JSON.stringify({
          appVersion: "2.0.0",
          bio: "",
          name: "Alice",
          osVersion: "iOS 19",
        }),
        headers: { ...authHeaders, "Content-Type": "application/json" },
        method: "POST",
      },
      env,
    );

    expect(response.status).toBe(201);
    await expect(response.json()).resolves.toMatchObject({ publicId: "987654321" });
  });

  test("認証 UID でユーザーを登録し、自分の情報を取得・更新できる", async () => {
    const created = await createUser("alice", "Alice");

    expect(created.status).toBe(201);
    const createdBody = await created.json<{
      id: string;
      publicId: string;
      name: string;
      bio: string;
      avatarUrl: string | null;
      createdAt: string;
    }>();
    expect(createdBody).toMatchObject({
      avatarUrl: null,
      bio: "Alice bio",
      id: "alice",
      name: "Alice",
    });
    expect(createdBody.publicId).toMatch(/^\d{9}$/);
    expect(new Date(createdBody.createdAt).toISOString()).toBe(createdBody.createdAt);

    const duplicate = await createUser("alice", "Duplicate");
    expect(duplicate.status).toBe(409);
    await expect(duplicate.json()).resolves.toEqual({
      error: { code: "user_already_exists", message: "User already exists" },
    });

    const updated = await request("alice", "/v1/users/me", {
      body: JSON.stringify({ bio: "updated", name: "Alicia" }),
      headers: { "Content-Type": "application/json" },
      method: "PATCH",
    });
    expect(updated.status).toBe(200);
    await expect(updated.json()).resolves.toMatchObject({
      bio: "updated",
      id: "alice",
      name: "Alicia",
    });

    const me = await request("alice", "/v1/users/me");
    expect(me.status).toBe(200);
    await expect(me.json()).resolves.toMatchObject({
      bio: "updated",
      id: "alice",
      name: "Alicia",
    });
  });

  test("公開プロフィールは件数と閲覧者のフォロー・ミュート状態を返す", async () => {
    await createUser("alice", "Alice");
    await createUser("bob", "Bob");
    await createUser("carol", "Carol");
    const now = Date.now();
    await env.DB.batch([
      env.DB.prepare(
        "insert into follows (follower_id, following_id, created_at) values (?, ?, ?)",
      ).bind("alice", "bob", now),
      env.DB.prepare(
        "insert into follows (follower_id, following_id, created_at) values (?, ?, ?)",
      ).bind("carol", "bob", now),
      env.DB.prepare(
        "insert into user_mutes (muter_id, muted_user_id, created_at) values (?, ?, ?)",
      ).bind("alice", "bob", now),
      env.DB.prepare(
        "insert into words (id, word, reading, reading_sub_group, created_by, created_at, updated_at) values (?, ?, ?, ?, ?, ?, ?)",
      ).bind("word-1", "自由", "じゆう", "さ", "bob", now, now),
      env.DB.prepare(
        "insert into definitions (id, word_id, author_id, body, status, finalized_at, created_at, updated_at) values (?, ?, ?, ?, ?, ?, ?, ?)",
      ).bind("definition-1", "word-1", "bob", "body", "public", now, now, now),
      env.DB.prepare(
        "insert into definitions (id, word_id, author_id, body, status, finalized_at, created_at, updated_at) values (?, ?, ?, ?, ?, ?, ?, ?)",
      ).bind("definition-2", "word-1", "bob", "private", "private", now, now, now),
    ]);

    const response = await request("alice", "/v1/users/bob");

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toMatchObject({
      followerCount: 2,
      followingCount: 0,
      id: "bob",
      isFollowedByMe: true,
      isMutedByMe: true,
      publicDefinitionCount: 1,
    });
  });

  test("アカウントを論理削除すると本人・公開プロフィール・所有定義が不可視になる", async () => {
    await createUser("alice", "Alice");
    const now = Date.now();
    await env.DB.batch([
      env.DB.prepare(
        "insert into words (id, word, reading, reading_sub_group, created_by, created_at, updated_at) values (?, ?, ?, ?, ?, ?, ?)",
      ).bind("word-1", "自由", "じゆう", "さ", "alice", now, now),
      env.DB.prepare(
        "insert into definitions (id, word_id, author_id, body, status, finalized_at, created_at, updated_at) values (?, ?, ?, ?, ?, ?, ?, ?)",
      ).bind("definition-1", "word-1", "alice", "body", "public", now, now, now),
    ]);

    const deleted = await request("alice", "/v1/users/me", { method: "DELETE" });
    expect(deleted.status).toBe(204);
    expect(await deleted.text()).toBe("");

    const user = await env.DB.prepare("select deleted_at from users where id = ?")
      .bind("alice")
      .first<{ deleted_at: number | null }>();
    const definition = await env.DB.prepare("select deleted_at from definitions where id = ?")
      .bind("definition-1")
      .first<{ deleted_at: number | null }>();
    expect(user?.deleted_at).not.toBeNull();
    expect(definition?.deleted_at).toBe(user?.deleted_at);

    expect((await request("alice", "/v1/users/me")).status).toBe(404);
    expect((await request("viewer", "/v1/users/alice")).status).toBe(404);
  });
});

describe("follow and mute routes", () => {
  beforeEach(async () => {
    await createUser("alice", "Alice");
    await createUser("bob", "Bob");
    await createUser("carol", "Carol");
  });

  test("フォローとミュートは自己指定を拒否し、追加・解除を冪等に行う", async () => {
    expect((await request("alice", "/v1/users/alice/follow", { method: "PUT" })).status).toBe(400);
    expect((await request("alice", "/v1/users/alice/mute", { method: "PUT" })).status).toBe(400);

    for (const suffix of ["follow", "mute"]) {
      expect((await request("alice", `/v1/users/bob/${suffix}`, { method: "PUT" })).status).toBe(
        204,
      );
      expect((await request("alice", `/v1/users/bob/${suffix}`, { method: "PUT" })).status).toBe(
        204,
      );
      expect((await request("alice", `/v1/users/bob/${suffix}`, { method: "DELETE" })).status).toBe(
        204,
      );
      expect((await request("alice", `/v1/users/bob/${suffix}`, { method: "DELETE" })).status).toBe(
        204,
      );
    }

    expect((await request("alice", "/v1/users/missing/follow", { method: "PUT" })).status).toBe(
      404,
    );
    expect((await request("alice", "/v1/users/missing/mute", { method: "PUT" })).status).toBe(404);

    expect((await request("alice", "/v1/users/alice/follow", { method: "DELETE" })).status).toBe(
      400,
    );
    expect((await request("alice", "/v1/users/alice/mute", { method: "DELETE" })).status).toBe(400);
    expect((await request("alice", "/v1/users/missing/follow", { method: "DELETE" })).status).toBe(
      404,
    );
    expect((await request("alice", "/v1/users/missing/mute", { method: "DELETE" })).status).toBe(
      404,
    );
  });

  test("フォロワー・フォロー中一覧を安定した cursor でページングする", async () => {
    const now = Date.now();
    await env.DB.batch([
      env.DB.prepare(
        "insert into follows (follower_id, following_id, created_at) values (?, ?, ?)",
      ).bind("alice", "bob", now + 2),
      env.DB.prepare(
        "insert into follows (follower_id, following_id, created_at) values (?, ?, ?)",
      ).bind("carol", "bob", now + 1),
      env.DB.prepare(
        "insert into follows (follower_id, following_id, created_at) values (?, ?, ?)",
      ).bind("bob", "alice", now),
    ]);

    const first = await request("carol", "/v1/users/bob/followers?limit=1");
    expect(first.status).toBe(200);
    const firstBody = await first.json<{
      items: { id: string; isFollowedByMe: boolean; isMutedByMe: boolean }[];
      nextCursor: string | null;
    }>();
    expect(firstBody.items.map((item) => item.id)).toEqual(["alice"]);
    expect(firstBody.nextCursor).not.toBeNull();

    const second = await request(
      "carol",
      `/v1/users/bob/followers?limit=1&cursor=${encodeURIComponent(firstBody.nextCursor!)}`,
    );
    const secondBody = await second.json<typeof firstBody>();
    expect(secondBody.items.map((item) => item.id)).toEqual(["carol"]);
    expect(secondBody.nextCursor).toBeNull();

    const following = await request("carol", "/v1/users/alice/following");
    const followingBody = await following.json<typeof firstBody>();
    expect(followingBody.items.map((item) => item.id)).toEqual(["bob"]);

    const invalidCursor = await request("carol", "/v1/users/bob/followers?cursor=invalid");
    expect(invalidCursor.status).toBe(400);
  });

  test("Firebase UID が非 ASCII でも cursor を往復できる", async () => {
    await createUser("ありす", "ありす");
    const now = Date.now();
    await env.DB.batch([
      env.DB.prepare(
        "insert into follows (follower_id, following_id, created_at) values (?, ?, ?)",
      ).bind("ありす", "bob", now + 1),
      env.DB.prepare(
        "insert into follows (follower_id, following_id, created_at) values (?, ?, ?)",
      ).bind("alice", "bob", now),
    ]);

    const first = await request("carol", "/v1/users/bob/followers?limit=1");
    expect(first.status).toBe(200);
    const firstBody = await first.json<{ items: { id: string }[]; nextCursor: string | null }>();
    expect(firstBody.items.map((item) => item.id)).toEqual(["ありす"]);

    const second = await request(
      "carol",
      `/v1/users/bob/followers?limit=1&cursor=${encodeURIComponent(firstBody.nextCursor!)}`,
    );
    expect(second.status).toBe(200);
    const secondBody = await second.json<typeof firstBody>();
    expect(secondBody.items.map((item) => item.id)).toEqual(["alice"]);
  });
});

describe("avatar routes", () => {
  beforeEach(async () => {
    await createUser("alice", "Alice");
  });

  test("JPEG を検証して固定キーへ保存し、認証付き Worker URL を返す", async () => {
    const jpeg = new Uint8Array([0xff, 0xd8, 0xff, 0xe0, 0x00, 0x10]);

    const response = await request("alice", "/v1/users/me/avatar", {
      body: jpeg,
      headers: { "Content-Type": "image/jpeg" },
      method: "PUT",
    });

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({
      avatarUrl: "http://localhost:8787/v1/avatars/alice",
    });
    const object = await env.AVATARS.get("avatars/alice");
    expect(object).not.toBeNull();
    expect(object?.httpMetadata?.contentType).toBe("image/jpeg");
    expect(Array.from(new Uint8Array(await object!.arrayBuffer()))).toEqual(Array.from(jpeg));

    const me = await request("alice", "/v1/users/me");
    await expect(me.json()).resolves.toMatchObject({
      avatarUrl: "http://localhost:8787/v1/avatars/alice",
    });
  });

  test("認証済みユーザーへ非公開 R2 のアバターを配信する", async () => {
    const jpeg = new Uint8Array([0xff, 0xd8, 0xff, 0xe0, 0x00, 0x10]);
    await request("alice", "/v1/users/me/avatar", {
      body: jpeg,
      headers: { "Content-Type": "image/jpeg" },
      method: "PUT",
    });

    const response = await request("alice", "/v1/avatars/alice");

    expect(response.status).toBe(200);
    expect(response.headers.get("Content-Type")).toBe("image/jpeg");
    expect(response.headers.get("Cache-Control")).toBe("private, max-age=300");
    expect(Array.from(new Uint8Array(await response.arrayBuffer()))).toEqual(Array.from(jpeg));

    const urlOnlyResponse = await testApp("alice").request("/v1/avatars/alice", {}, env);
    expect(urlOnlyResponse.status).toBe(401);
  });

  test("対象ユーザーまたはアバターがなければ一律 avatar_not_found を返す", async () => {
    const missingUser = await request("alice", "/v1/avatars/missing");
    expect(missingUser.status).toBe(404);
    await expect(missingUser.json()).resolves.toEqual({
      error: { code: "avatar_not_found", message: "Avatar not found" },
    });

    const missingAvatar = await request("alice", "/v1/avatars/alice");
    expect(missingAvatar.status).toBe(404);
    await expect(missingAvatar.json()).resolves.toEqual({
      error: { code: "avatar_not_found", message: "Avatar not found" },
    });
  });

  test("Content-Type・シグネチャ不一致と 10 MiB 超過を拒否する", async () => {
    const png = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
    const mismatch = await request("alice", "/v1/users/me/avatar", {
      body: png,
      headers: { "Content-Type": "image/jpeg" },
      method: "PUT",
    });
    expect(mismatch.status).toBe(415);

    const unsupported = await request("alice", "/v1/users/me/avatar", {
      body: png,
      headers: { "Content-Type": "application/octet-stream" },
      method: "PUT",
    });
    expect(unsupported.status).toBe(415);

    const tooLarge = new Uint8Array(10 * 1024 * 1024 + 1);
    tooLarge.set(png);
    const oversized = await request("alice", "/v1/users/me/avatar", {
      body: tooLarge,
      headers: { "Content-Type": "image/png" },
      method: "PUT",
    });
    expect(oversized.status).toBe(413);
  });

  test("Content-Length がなくても上限超過時点で body stream を中断する", async () => {
    let pullCount = 0;
    let cancelled = false;
    const body = new ReadableStream<Uint8Array>(
      {
        cancel: () => {
          cancelled = true;
        },
        pull(controller) {
          pullCount += 1;
          if (pullCount === 1) {
            const first = new Uint8Array(6 * 1024 * 1024);
            first.set([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
            controller.enqueue(first);
            return;
          }
          if (pullCount === 2) {
            controller.enqueue(new Uint8Array(5 * 1024 * 1024));
            return;
          }
          throw new Error("stream was read after exceeding the limit");
        },
      },
      { highWaterMark: 0 },
    );
    const service = new AvatarService(env);

    await expect(
      service.upload(
        "alice",
        new Request("https://example.com/v1/users/me/avatar", {
          body,
          headers: { "Content-Type": "image/png" },
          method: "PUT",
        }),
      ),
    ).rejects.toMatchObject({ code: "image_too_large", status: 413 });
    expect(pullCount).toBe(2);
    expect(cancelled).toBe(true);
  });

  test("D1 更新失敗時も既存アバターと avatar_key の整合性を維持する", async () => {
    const oldPng = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x01]);
    const newPng = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x02]);
    await request("alice", "/v1/users/me/avatar", {
      body: oldPng,
      headers: { "Content-Type": "image/png" },
      method: "PUT",
    });

    const uploadService = new AvatarService({
      ...env,
      DB: databaseFailingAvatarKeyUpdate("set avatar_key = ?"),
    });
    await expect(
      uploadService.upload(
        "alice",
        new Request("https://example.com/v1/users/me/avatar", {
          body: newPng,
          headers: { "Content-Type": "image/png" },
          method: "PUT",
        }),
      ),
    ).rejects.toThrow("simulated D1 update failure");
    const restored = await env.AVATARS.get("avatars/alice");
    expect(Array.from(new Uint8Array(await restored!.arrayBuffer()))).toEqual(Array.from(oldPng));

    const deleteService = new AvatarService({
      ...env,
      DB: databaseFailingAvatarKeyUpdate("set avatar_key = null"),
    });
    await expect(deleteService.delete("alice")).rejects.toThrow("simulated D1 update failure");
    expect(await env.AVATARS.get("avatars/alice")).not.toBeNull();
    const user = await env.DB.prepare("select avatar_key from users where id = ?")
      .bind("alice")
      .first<{ avatar_key: string | null }>();
    expect(user?.avatar_key).toBe("avatars/alice");
  });

  test("R2 削除失敗時は avatar_key を復元する", async () => {
    const png = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
    await request("alice", "/v1/users/me/avatar", {
      body: png,
      headers: { "Content-Type": "image/png" },
      method: "PUT",
    });
    const service = new AvatarService({
      ...env,
      AVATARS: {
        delete: async () => {
          throw new Error("simulated R2 delete failure");
        },
        head: (key: string) => env.AVATARS.head(key),
      } as unknown as R2Bucket,
    });

    await expect(service.delete("alice")).rejects.toThrow("simulated R2 delete failure");
    const user = await env.DB.prepare("select avatar_key from users where id = ?")
      .bind("alice")
      .first<{ avatar_key: string | null }>();
    expect(user?.avatar_key).toBe("avatars/alice");
    expect(await env.AVATARS.get("avatars/alice")).not.toBeNull();
  });

  test("R2 削除が反映済みならエラー応答でも avatar_key を復元しない", async () => {
    const png = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
    await request("alice", "/v1/users/me/avatar", {
      body: png,
      headers: { "Content-Type": "image/png" },
      method: "PUT",
    });
    const service = new AvatarService({
      ...env,
      AVATARS: {
        delete: async (key: string) => {
          await env.AVATARS.delete(key);
          throw new Error("simulated ambiguous R2 delete failure");
        },
        head: (key: string) => env.AVATARS.head(key),
      } as unknown as R2Bucket,
    });

    await expect(service.delete("alice")).rejects.toThrow("simulated ambiguous R2 delete failure");
    const user = await env.DB.prepare("select avatar_key from users where id = ?")
      .bind("alice")
      .first<{ avatar_key: string | null }>();
    expect(user?.avatar_key).toBeNull();
    expect(await env.AVATARS.get("avatars/alice")).toBeNull();
  });

  test("アバター削除は R2 object がなくても成功する", async () => {
    const png = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
    await request("alice", "/v1/users/me/avatar", {
      body: png,
      headers: { "Content-Type": "image/png" },
      method: "PUT",
    });

    expect((await request("alice", "/v1/users/me/avatar", { method: "DELETE" })).status).toBe(204);
    expect(await env.AVATARS.get("avatars/alice")).toBeNull();
    expect((await request("alice", "/v1/users/me/avatar", { method: "DELETE" })).status).toBe(204);
  });
});
