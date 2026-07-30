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
  status: "public" | "private";
  isEdited: boolean;
  likesCount: number;
  isLikedByMe: boolean;
  finalizedAt: string;
  editableUntil: string;
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
  status: "public" | "private",
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
  test("word + reading で言葉を解決／内部作成し、明示登録は残さない", async () => {
    await createUser("alice");
    await createUser("bob");

    const response = await requestJson("alice", "/v1/definitions", "POST", {
      body: "非公開の定義",
      reading: "ないぶ",
      status: "private",
      word: "内部作成語",
    });
    expect(response.status).toBe(201);
    const body = await response.json<DefinitionResponse>();
    expect(body.word).toMatchObject({ reading: "ないぶ", word: "内部作成語" });

    const wordRow = await env.DB.prepare(
      "select first_registered_at, first_registered_by from words where id = ?",
    )
      .bind(body.word.id)
      .first<{ first_registered_at: number | null; first_registered_by: string | null }>();
    expect(wordRow).toEqual({ first_registered_at: null, first_registered_by: null });

    const registrations = await env.DB.prepare(
      "select count(*) as c from word_registrations where word_id = ?",
    )
      .bind(body.word.id)
      .first<{ c: number }>();
    expect(registrations).toEqual({ c: 0 });

    expect((await request("bob", `/v1/words/${body.word.id}`)).status).toBe(404);
  });

  test("公開定義なら内部作成した言葉も公開経路に出る", async () => {
    await createUser("alice");
    await createUser("bob");

    const response = await requestJson("alice", "/v1/definitions", "POST", {
      body: "公開の定義",
      reading: "こうかい",
      status: "public",
      word: "公開内部語",
    });
    expect(response.status).toBe(201);
    const body = await response.json<DefinitionResponse>();

    expect((await request("bob", `/v1/words/${body.word.id}`)).status).toBe(200);
    const list = await request("bob", "/v1/words");
    const listBody = await list.json<{ items: Array<{ id: string }> }>();
    expect(listBody.items.map((item) => item.id)).toContain(body.word.id);
  });

  test("(表記, よみ) が一致する既存言葉には既存の言葉を使う", async () => {
    await createUser("alice");
    const existing = await createWord("alice", "既存語", "きそんご");

    const response = await requestJson("alice", "/v1/definitions", "POST", {
      body: "定義",
      reading: " きそんご ",
      status: "public",
      word: " 既存語 ",
    });
    expect(response.status).toBe(201);
    const body = await response.json<DefinitionResponse>();
    expect(body.word).toMatchObject({ id: existing.id, reading: "きそんご", word: "既存語" });
  });

  test("表記が同じでよみが異なる場合は別の言葉を内部作成する", async () => {
    await createUser("alice");
    const existing = await createWord("alice", "金星", "きんせい");

    const response = await requestJson("alice", "/v1/definitions", "POST", {
      body: "定義",
      reading: "きんぼし",
      status: "public",
      word: "金星",
    });
    expect(response.status).toBe(201);
    const body = await response.json<DefinitionResponse>();
    expect(body.word).toMatchObject({ reading: "きんぼし", word: "金星" });
    expect(body.word.id).not.toBe(existing.id);
  });

  test("private も finalizedAt と editableUntil を持つ", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");

    const definition = await createDefinition("alice", word.id, "private");

    expect(definition).toMatchObject({
      body: "定義本文",
      isEdited: false,
      isLikedByMe: false,
      likesCount: 0,
      status: "private",
      word: { id: word.id, word: "ことば" },
    });
    expect(definition.finalizedAt).not.toBeNull();
    expect(definition.editableUntil).not.toBeNull();
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
      status: "public",
      wordId: "missing-word",
    });

    expect(response.status).toBe(404);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "word_not_found" },
    });
  });

  test("status: draft は 400 ZodError で拒否される", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");

    const response = await requestJson("alice", "/v1/definitions", "POST", {
      body: "本文",
      status: "draft",
      wordId: word.id,
    });

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      success: false,
      error: { name: "ZodError" },
    });
  });
});

describe("GET /v1/me/definitions", () => {
  test("status: draft は 400 ZodError で拒否される", async () => {
    await createUser("alice");

    const response = await request("alice", "/v1/me/definitions?status=draft");

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      success: false,
      error: { name: "ZodError" },
    });
  });
});

describe("GET /v1/definitions/{id}", () => {
  test("本人は private を取得でき、他者の public も取得できる", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const privateDefinition = await createDefinition("alice", word.id, "private");
    const publicDefinition = await createDefinition("alice", word.id, "public");

    const ownPrivate = await request("alice", `/v1/definitions/${privateDefinition.id}`);
    const othersPublic = await request("bob", `/v1/definitions/${publicDefinition.id}`);

    expect(ownPrivate.status).toBe(200);
    expect(othersPublic.status).toBe(200);
  });

  test("他者の private は 404 で存在を秘匿する", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const privateDefinition = await createDefinition("alice", word.id, "private");

    const privateResponse = await request("bob", `/v1/definitions/${privateDefinition.id}`);

    expect(privateResponse.status).toBe(404);
    await expect(privateResponse.json()).resolves.toMatchObject({
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
  test("wordId を送っても無視され言葉は変わらない", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const anotherWord = await createWord("alice", "いみ", "いみ");
    const definition = await createDefinition("alice", word.id, "public");

    const response = await requestJson("alice", `/v1/definitions/${definition.id}`, "PATCH", {
      wordId: anotherWord.id,
    });

    expect(response.status).toBe(200);
    const body = await response.json<DefinitionResponse>();
    expect(body.word.id).toBe(word.id);
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

  test("未知の status は 400 ZodError で拒否される", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");

    const response = await requestJson("alice", `/v1/definitions/${definition.id}`, "PATCH", {
      status: "draft",
    });

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      success: false,
      error: { name: "ZodError" },
    });
  });

  test("作成後 1 時間以内の本文編集は isEdited を立てる", async () => {
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

  test("作成後 1 時間を超えた本文編集は 403 edit_window_expired", async () => {
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

  test("作成後 1 時間を超えても公開範囲は切り替えられる", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");
    await ageFinalizedAt(definition.id, editWindowMilliseconds + 1000);

    const response = await requestJson("alice", `/v1/definitions/${definition.id}`, "PATCH", {
      status: "private",
    });

    expect(response.status).toBe(200);
  });

  test("並行する公開範囲変更と競合しても楽観ロックで再評価する", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "public");
    // 本文編集 PATCH の読み取りと UPDATE の間に、別リクエストによる private 化を割り込ませる
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
                  "update definitions set status = 'private', updated_at = ? where id = ?",
                )
                  .bind(now + 1, definition.id)
                  .run();
                return bound.run();
              },
            };
          },
        } as unknown as D1PreparedStatement;
      },
    } as unknown as D1Database;

    const response = await testApp("alice").request(
      `/v1/definitions/${definition.id}`,
      {
        body: JSON.stringify({ body: "競合する本文編集" }),
        headers: { ...authHeaders, "Content-Type": "application/json" },
        method: "PATCH",
      },
      { ...env, DB: racingDatabase },
    );

    expect(response.status).toBe(200);
    const body = await response.json<DefinitionResponse>();
    expect(body.body).toBe("競合する本文編集");
    expect(body.status).toBe("private");
    const row = await env.DB.prepare("select status, body from definitions where id = ?")
      .bind(definition.id)
      .first<{ status: string; body: string }>();
    expect(row).toEqual({ status: "private", body: "競合する本文編集" });
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

  test("他者の private 定義の削除は 404 で存在を秘匿する", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const definition = await createDefinition("alice", word.id, "private");

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

  test("自分の private にもいいねできる", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    const privateDefinition = await createDefinition("alice", word.id, "private");

    const response = await request("alice", `/v1/definitions/${privateDefinition.id}/like`, {
      method: "PUT",
    });

    expect(response.status).toBe(204);
  });

  test("他者の private へのいいねは 404 で存在を秘匿する", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    const privateDefinition = await createDefinition("alice", word.id, "private");

    const privateLike = await request("bob", `/v1/definitions/${privateDefinition.id}/like`, {
      method: "PUT",
    });

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
