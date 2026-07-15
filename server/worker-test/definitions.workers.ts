import { applyD1Migrations, env } from "cloudflare:test";
import { beforeEach, describe, expect, test } from "vitest";

import { createApp } from "../src/app";

const authHeaders = {
  Authorization: "Bearer valid-id-token",
  "X-Firebase-AppCheck": "valid-app-check",
};

const editWindowMilliseconds = 60 * 60 * 1000;

type DefinitionResponse = {
  id: string;
  word: { id: string; word: string; reading: string };
  author: { id: string; publicId: string; name: string; avatarUrl: string | null };
  body: string;
  status: "draft" | "public" | "private";
  isEdited: boolean;
  likesCount: number;
  isLikedByMe: boolean;
  finalizedAt: string | null;
  editableUntil: string | null;
  createdAt: string;
  updatedAt: string;
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

async function requestJson(uid: string, path: string, method: string, body: unknown) {
  return request(uid, path, {
    body: JSON.stringify(body),
    headers: { "Content-Type": "application/json" },
    method,
  });
}

async function createUser(uid: string) {
  const response = await requestJson(uid, "/v1/users", "POST", {
    appVersion: "2.0.0",
    bio: "",
    name: uid,
    osVersion: "iOS 19",
  });
  expect(response.status).toBe(201);
}

async function createWord(uid: string, word: string, reading: string) {
  const response = await requestJson(uid, "/v1/words", "POST", { reading, word });
  expect(response.status).toBe(201);
  return response.json<{ id: string }>();
}

async function createDefinition(
  uid: string,
  wordId: string,
  status: "draft" | "public" | "private",
  body = "定義本文",
) {
  const response = await requestJson(uid, "/v1/definitions", "POST", { body, status, wordId });
  expect(response.status).toBe(201);
  return response.json<DefinitionResponse>();
}

async function ageFinalizedAt(definitionId: string, milliseconds: number) {
  await env.DB.prepare("update definitions set finalized_at = finalized_at - ? where id = ?")
    .bind(milliseconds, definitionId)
    .run();
}

beforeEach(async () => {
  await applyD1Migrations(env.DB, env.TEST_MIGRATIONS);
  await env.DB.batch([
    env.DB.prepare("delete from users"),
    env.DB.prepare("delete from words"),
    env.DB.prepare("delete from app_config"),
  ]);
});

describe("POST /v1/definitions", () => {
  test("draft は finalizedAt / editableUntil なしで作成される", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");

    const definition = await createDefinition("alice", word.id, "draft");

    expect(definition).toMatchObject({
      body: "定義本文",
      editableUntil: null,
      finalizedAt: null,
      isEdited: false,
      isLikedByMe: false,
      likesCount: 0,
      status: "draft",
      word: { id: word.id, word: "ことば" },
    });
    expect(definition.author).toMatchObject({ id: "alice", name: "alice" });
  });

  test("public は finalizedAt と 1 時間後の editableUntil を持つ", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");

    const definition = await createDefinition("alice", word.id, "public");

    expect(definition.finalizedAt).not.toBeNull();
    expect(definition.editableUntil).not.toBeNull();
    expect(Date.parse(definition.editableUntil!) - Date.parse(definition.finalizedAt!)).toBe(
      editWindowMilliseconds,
    );
  });

  test("存在しない言葉への定義は 404 word_not_found", async () => {
    await createUser("alice");

    const response = await requestJson("alice", "/v1/definitions", "POST", {
      body: "本文",
      status: "draft",
      wordId: "missing-word",
    });

    expect(response.status).toBe(404);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "word_not_found" },
    });
  });
});

describe("GET /v1/definitions/{id}", () => {
  test("本人は draft / private を取得でき、他者の public も取得できる", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const draft = await createDefinition("alice", word.id, "draft");
    const publicDefinition = await createDefinition("alice", word.id, "public");

    const ownDraft = await request("alice", `/v1/definitions/${draft.id}`);
    const othersPublic = await request("bob", `/v1/definitions/${publicDefinition.id}`);

    expect(ownDraft.status).toBe(200);
    expect(othersPublic.status).toBe(200);
  });

  test("他者の draft / private は 404 で存在を秘匿する", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const draft = await createDefinition("alice", word.id, "draft");
    const privateDefinition = await createDefinition("alice", word.id, "private");

    const draftResponse = await request("bob", `/v1/definitions/${draft.id}`);
    const privateResponse = await request("bob", `/v1/definitions/${privateDefinition.id}`);

    expect(draftResponse.status).toBe(404);
    expect(privateResponse.status).toBe(404);
    await expect(draftResponse.json()).resolves.toMatchObject({
      error: { code: "definition_not_found" },
    });
  });

  test("削除済みの定義は本人にも 404", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");
    await request("alice", `/v1/definitions/${definition.id}`, { method: "DELETE" });

    const response = await request("alice", `/v1/definitions/${definition.id}`);

    expect(response.status).toBe(404);
  });
});

describe("PATCH /v1/definitions/{id}", () => {
  test("draft から public へ確定すると finalizedAt が設定され isEdited は立たない", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const draft = await createDefinition("alice", word.id, "draft");

    const response = await requestJson("alice", `/v1/definitions/${draft.id}`, "PATCH", {
      body: "推敲した本文",
      status: "public",
    });

    expect(response.status).toBe(200);
    const body = await response.json<DefinitionResponse>();
    expect(body).toMatchObject({ body: "推敲した本文", isEdited: false, status: "public" });
    expect(body.finalizedAt).not.toBeNull();
  });

  test("下書き中は言葉を変更できる", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const anotherWord = await createWord("alice", "いみ", "いみ");
    const draft = await createDefinition("alice", word.id, "draft");

    const response = await requestJson("alice", `/v1/definitions/${draft.id}`, "PATCH", {
      wordId: anotherWord.id,
    });

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toMatchObject({
      word: { id: anotherWord.id, word: "いみ" },
    });
  });

  test("確定後の言葉変更は 400 invalid_transition", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const anotherWord = await createWord("alice", "いみ", "いみ");
    const definition = await createDefinition("alice", word.id, "public");

    const response = await requestJson("alice", `/v1/definitions/${definition.id}`, "PATCH", {
      wordId: anotherWord.id,
    });

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "invalid_transition" },
    });
  });

  test("public と private は相互に切り替えられ finalizedAt は変わらない", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");

    const toPrivate = await requestJson("alice", `/v1/definitions/${definition.id}`, "PATCH", {
      status: "private",
    });
    const toPublic = await requestJson("alice", `/v1/definitions/${definition.id}`, "PATCH", {
      status: "public",
    });

    const privateBody = await toPrivate.json<DefinitionResponse>();
    const publicBody = await toPublic.json<DefinitionResponse>();
    expect(privateBody.status).toBe("private");
    expect(privateBody.finalizedAt).toBe(definition.finalizedAt);
    expect(publicBody.status).toBe("public");
    expect(publicBody.finalizedAt).toBe(definition.finalizedAt);
  });

  test("確定後に draft へ戻すのは 400 invalid_transition", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");

    const response = await requestJson("alice", `/v1/definitions/${definition.id}`, "PATCH", {
      status: "draft",
    });

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "invalid_transition" },
    });
  });

  test("確定後 1 時間以内の本文編集は isEdited を立てる", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");

    const response = await requestJson("alice", `/v1/definitions/${definition.id}`, "PATCH", {
      body: "編集後の本文",
    });

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toMatchObject({
      body: "編集後の本文",
      isEdited: true,
    });
  });

  test("確定後 1 時間を超えた本文編集は 403 edit_window_expired", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");
    await ageFinalizedAt(definition.id, editWindowMilliseconds + 1000);

    const response = await requestJson("alice", `/v1/definitions/${definition.id}`, "PATCH", {
      body: "遅すぎる編集",
    });

    expect(response.status).toBe(403);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "edit_window_expired" },
    });
  });

  test("確定後 1 時間を超えても公開範囲は切り替えられる", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");
    await ageFinalizedAt(definition.id, editWindowMilliseconds + 1000);

    const response = await requestJson("alice", `/v1/definitions/${definition.id}`, "PATCH", {
      status: "private",
    });

    expect(response.status).toBe(200);
  });

  test("並行する確定処理と競合しても draft へ巻き戻らない", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const draft = await createDefinition("alice", word.id, "draft");
    // 本文編集 PATCH の読み取りと UPDATE の間に、別リクエストによる確定（draft→public）を割り込ませる
    let intercepted = false;
    const racingDatabase = {
      prepare(query: string) {
        const statement = env.DB.prepare(query);
        if (!query.trimStart().startsWith("update definitions") || intercepted) return statement;
        intercepted = true;
        return {
          bind: (...values: unknown[]) => {
            const bound = statement.bind(...values);
            return {
              run: async () => {
                const now = Date.now();
                await env.DB.prepare(
                  "update definitions set status = 'public', finalized_at = ?, updated_at = ? where id = ?",
                )
                  .bind(now, now + 1, draft.id)
                  .run();
                return bound.run();
              },
            };
          },
        } as unknown as D1PreparedStatement;
      },
    } as unknown as D1Database;

    const response = await testApp("alice").request(
      `/v1/definitions/${draft.id}`,
      {
        body: JSON.stringify({ body: "競合する本文編集" }),
        headers: { ...authHeaders, "Content-Type": "application/json" },
        method: "PATCH",
      },
      { ...env, DB: racingDatabase },
    );

    expect(response.status).toBe(200);
    const body = await response.json<DefinitionResponse>();
    expect(body.status).toBe("public");
    expect(body.finalizedAt).not.toBeNull();
    const row = await env.DB.prepare("select status, finalized_at from definitions where id = ?")
      .bind(draft.id)
      .first<{ status: string; finalized_at: number | null }>();
    expect(row!.status).toBe("public");
    expect(row!.finalized_at).not.toBeNull();
  });

  test("他者の public 定義の編集は 403 forbidden", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");

    const response = await requestJson("bob", `/v1/definitions/${definition.id}`, "PATCH", {
      body: "改ざん",
    });

    expect(response.status).toBe(403);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "forbidden" },
    });
  });

  test("他者の private 定義の編集は 404 で存在を秘匿する", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "private");

    const response = await requestJson("bob", `/v1/definitions/${definition.id}`, "PATCH", {
      body: "改ざん",
    });

    expect(response.status).toBe(404);
  });
});

describe("DELETE /v1/definitions/{id}", () => {
  test("本人は削除でき、以後 404 になる", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");

    const deleteResponse = await request("alice", `/v1/definitions/${definition.id}`, {
      method: "DELETE",
    });

    expect(deleteResponse.status).toBe(204);
    const getResponse = await request("alice", `/v1/definitions/${definition.id}`);
    expect(getResponse.status).toBe(404);
  });

  test("他者の public 定義の削除は 403 forbidden", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");

    const response = await request("bob", `/v1/definitions/${definition.id}`, {
      method: "DELETE",
    });

    expect(response.status).toBe(403);
  });

  test("他者の draft 定義の削除は 404 で存在を秘匿する", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "draft");

    const response = await request("bob", `/v1/definitions/${definition.id}`, {
      method: "DELETE",
    });

    expect(response.status).toBe(404);
  });
});

describe("PUT / DELETE /v1/definitions/{id}/like", () => {
  test("他者の public 定義へのいいねは冪等で、件数と isLikedByMe に反映される", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");

    const like1 = await request("bob", `/v1/definitions/${definition.id}/like`, { method: "PUT" });
    const like2 = await request("bob", `/v1/definitions/${definition.id}/like`, { method: "PUT" });
    expect(like1.status).toBe(204);
    expect(like2.status).toBe(204);
    const liked = await request("bob", `/v1/definitions/${definition.id}`);
    await expect(liked.json()).resolves.toMatchObject({ isLikedByMe: true, likesCount: 1 });

    const unlike1 = await request("bob", `/v1/definitions/${definition.id}/like`, {
      method: "DELETE",
    });
    const unlike2 = await request("bob", `/v1/definitions/${definition.id}/like`, {
      method: "DELETE",
    });
    expect(unlike1.status).toBe(204);
    expect(unlike2.status).toBe(204);
    const unliked = await request("bob", `/v1/definitions/${definition.id}`);
    await expect(unliked.json()).resolves.toMatchObject({ isLikedByMe: false, likesCount: 0 });
  });

  test("可視性チェック後に削除された定義にはいいね行を残さない", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");
    // 可視性チェックと INSERT の間に定義の論理削除を割り込ませ、TOCTOU を再現する
    let intercepted = false;
    const racingDatabase = {
      prepare(query: string) {
        const statement = env.DB.prepare(query);
        if (!query.trimStart().startsWith("insert or ignore into likes") || intercepted) {
          return statement;
        }
        intercepted = true;
        return {
          bind: (...values: unknown[]) => {
            const bound = statement.bind(...values);
            return {
              run: async () => {
                const now = Date.now();
                await env.DB.prepare(
                  "update definitions set deleted_at = ?, updated_at = ? where id = ?",
                )
                  .bind(now, now, definition.id)
                  .run();
                return bound.run();
              },
            };
          },
        } as unknown as D1PreparedStatement;
      },
    } as unknown as D1Database;

    await testApp("bob").request(
      `/v1/definitions/${definition.id}/like`,
      { headers: authHeaders, method: "PUT" },
      { ...env, DB: racingDatabase },
    );

    const row = await env.DB.prepare("select count(*) as count from likes where definition_id = ?")
      .bind(definition.id)
      .first<{ count: number }>();
    expect(row!.count).toBe(0);
  });

  test("自分の draft にもいいねできる", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const draft = await createDefinition("alice", word.id, "draft");

    const response = await request("alice", `/v1/definitions/${draft.id}/like`, { method: "PUT" });

    expect(response.status).toBe(204);
  });

  test("他者の draft / private へのいいねは 404 で存在を秘匿する", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const draft = await createDefinition("alice", word.id, "draft");
    const privateDefinition = await createDefinition("alice", word.id, "private");

    const draftLike = await request("bob", `/v1/definitions/${draft.id}/like`, { method: "PUT" });
    const privateLike = await request("bob", `/v1/definitions/${privateDefinition.id}/like`, {
      method: "PUT",
    });

    expect(draftLike.status).toBe(404);
    expect(privateLike.status).toBe(404);
  });
});

describe("GET /v1/definitions/{id}/likes", () => {
  test("いいね日時の降順で keyset pagination できる", async () => {
    await createUser("alice");
    await createUser("bob");
    await createUser("carol");
    await createUser("dave");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");
    for (const [index, uid] of ["bob", "carol", "dave"].entries()) {
      await request(uid, `/v1/definitions/${definition.id}/like`, { method: "PUT" });
      // created_at をずらして並び順を確定させる
      await env.DB.prepare(
        "update likes set created_at = ? where user_id = ? and definition_id = ?",
      )
        .bind(1000 * (index + 1), uid, definition.id)
        .run();
    }

    const firstPage = await request("alice", `/v1/definitions/${definition.id}/likes?limit=2`);
    expect(firstPage.status).toBe(200);
    const firstBody = await firstPage.json<{
      items: Array<{ id: string }>;
      nextCursor: string | null;
    }>();
    expect(firstBody.items.map((item) => item.id)).toEqual(["dave", "carol"]);
    expect(firstBody.nextCursor).not.toBeNull();

    const secondPage = await request(
      "alice",
      `/v1/definitions/${definition.id}/likes?limit=2&cursor=${encodeURIComponent(firstBody.nextCursor!)}`,
    );
    const secondBody = await secondPage.json<{
      items: Array<{ id: string; isFollowedByMe: boolean; isMutedByMe: boolean }>;
      nextCursor: string | null;
    }>();
    expect(secondBody.items.map((item) => item.id)).toEqual(["bob"]);
    expect(secondBody.items[0]).toMatchObject({ isFollowedByMe: false, isMutedByMe: false });
    expect(secondBody.nextCursor).toBeNull();
  });

  test("他者の private 定義のいいね一覧は 404 で存在を秘匿する", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const privateDefinition = await createDefinition("alice", word.id, "private");

    const response = await request("bob", `/v1/definitions/${privateDefinition.id}/likes`);

    expect(response.status).toBe(404);
  });
});
