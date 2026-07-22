import { applyD1Migrations, env } from "cloudflare:test";
import { beforeEach, describe, expect, test } from "vitest";

import { createApp } from "../src/app";

const authHeaders = {
  Authorization: "Bearer valid-id-token",
  "X-Firebase-AppCheck": "valid-app-check",
};

const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/;

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
  return response.json<{ id: string; word: string; reading: string }>();
}

async function insertWordRow(options: {
  id: string;
  word: string;
  reading: string;
  readingSubGroup: string;
  createdBy: string;
  createdAt: number;
  firstRegisteredAt?: number | null;
  firstRegisteredBy?: string | null;
}) {
  const firstRegisteredAt =
    options.firstRegisteredAt === undefined ? options.createdAt : options.firstRegisteredAt;
  const firstRegisteredBy =
    options.firstRegisteredBy === undefined ? options.createdBy : options.firstRegisteredBy;
  await env.DB.prepare(
    `insert into words (
       id, word, reading, reading_sub_group, created_by,
       first_registered_at, first_registered_by, created_at, updated_at
     ) values (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
  )
    .bind(
      options.id,
      options.word,
      options.reading,
      options.readingSubGroup,
      options.createdBy,
      firstRegisteredAt,
      firstRegisteredBy,
      options.createdAt,
      options.createdAt,
    )
    .run();
  if (firstRegisteredBy !== null) {
    await env.DB.prepare(
      `insert into word_registrations (id, word_id, user_id, created_at) values (?, ?, ?, ?)`,
    )
      .bind(
        `reg-${options.id}`,
        options.id,
        firstRegisteredBy,
        firstRegisteredAt ?? options.createdAt,
      )
      .run();
  }
}

async function insertPublicDefinitionRow(id: string, wordId: string, authorId: string) {
  const now = Date.now();
  await env.DB.prepare(
    `insert into definitions (id, word_id, author_id, body, status, finalized_at, is_edited, created_at, updated_at)
     values (?, ?, ?, ?, 'public', ?, 0, ?, ?)`,
  )
    .bind(id, wordId, authorId, `${id} body`, now, now, now)
    .run();
}

beforeEach(async () => {
  await applyD1Migrations(env.DB, env.TEST_MIGRATIONS);
  // users の削除で definitions / saved_words / likes は CASCADE、words.created_by は SET NULL になる
  await env.DB.batch([
    env.DB.prepare("delete from users"),
    env.DB.prepare("delete from words"),
    env.DB.prepare("delete from app_config"),
  ]);
});

describe("POST /v1/words", () => {
  test("表記とよみを正規化して保存し、UUIDv7 の ID と読みグループを返す", async () => {
    await createUser("alice");
    const decomposedGa = `か${String.fromCharCode(0x3099)}`;

    const response = await requestJson("alice", "/v1/words", "POST", {
      reading: " ガラス ",
      word: ` ${decomposedGa}らす `,
    });

    expect(response.status).toBe(201);
    const body = await response.json<{
      id: string;
      word: string;
      reading: string;
      readingSubGroup: string;
      publicDefinitionCount: number;
      isSavedByMe: boolean;
      isEditableByMe: boolean;
    }>();
    expect(body).toMatchObject({
      isEditableByMe: true,
      isSavedByMe: false,
      publicDefinitionCount: 0,
      reading: "ガラス",
      readingSubGroup: "か",
      word: "がらす",
    });
    expect(body.id).toMatch(uuidPattern);
  });

  test("正規化後に空になる表記・よみは 400 invalid_request", async () => {
    await createUser("alice");

    const response = await requestJson("alice", "/v1/words", "POST", {
      reading: " ",
      word: " ",
    });

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "invalid_request" },
    });
  });

  test("未登録ユーザーの言葉登録は 404 user_not_found", async () => {
    const response = await requestJson("unregistered", "/v1/words", "POST", {
      reading: "ことば",
      word: "ことば",
    });

    expect(response.status).toBe(404);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "user_not_found" },
    });
  });

  test("論理削除済みユーザーは言葉を登録できない", async () => {
    await createUser("alice");
    await request("alice", "/v1/users/me", { method: "DELETE" });

    const response = await requestJson("alice", "/v1/words", "POST", {
      reading: "ことば",
      word: "ことば",
    });

    expect(response.status).toBe(404);
  });

  test("正規化後に同一表記が存在する場合は 200 で明示登録し既存の言葉を返す", async () => {
    await createUser("alice");
    const first = await createWord("alice", "りんご", "りんご");

    const response = await requestJson("alice", "/v1/words", "POST", {
      reading: "べつのよみ",
      word: "  りんご ",
    });

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toMatchObject({
      id: first.id,
      reading: "りんご",
      word: "りんご",
    });
  });

  test("隠れた既存言葉を初めて明示登録すると 200 で公開昇格する", async () => {
    await createUser("alice");
    await createUser("bob");
    await insertWordRow({
      createdAt: Date.now() - 1000,
      createdBy: "alice",
      firstRegisteredAt: null,
      firstRegisteredBy: null,
      id: "hidden-word",
      reading: "かくれ",
      readingSubGroup: "か",
      word: "隠れ語",
    });
    await env.DB.prepare(
      `insert into definitions (id, word_id, author_id, body, status, finalized_at, is_edited, created_at, updated_at)
       values ('private-def', 'hidden-word', 'alice', 'secret', 'private', ?, 0, ?, ?)`,
    )
      .bind(Date.now(), Date.now(), Date.now())
      .run();

    expect((await request("bob", "/v1/words/hidden-word")).status).toBe(404);

    const response = await requestJson("bob", "/v1/words", "POST", {
      reading: "べつのよみ",
      word: "隠れ語",
    });
    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toMatchObject({
      id: "hidden-word",
      reading: "かくれ",
      word: "隠れ語",
    });
    expect((await request("bob", "/v1/words/hidden-word")).status).toBe(200);
    expect((await request("alice", "/v1/words/hidden-word")).status).toBe(200);
  });

  test("別ユーザーの再登録は登録関係だけ追加し最初の明示登録日時を更新しない", async () => {
    await createUser("alice");
    await createUser("bob");
    const first = await createWord("alice", "共有語", "きょうゆうご");
    const before = await env.DB.prepare(
      "select first_registered_at, first_registered_by from words where id = ?",
    )
      .bind(first.id)
      .first<{ first_registered_at: number; first_registered_by: string }>();

    const response = await requestJson("bob", "/v1/words", "POST", {
      reading: "きょうゆうご",
      word: "共有語",
    });
    expect(response.status).toBe(200);

    const after = await env.DB.prepare(
      "select first_registered_at, first_registered_by from words where id = ?",
    )
      .bind(first.id)
      .first<{ first_registered_at: number; first_registered_by: string }>();
    expect(after).toEqual(before);

    const registrations = await env.DB.prepare(
      "select user_id from word_registrations where word_id = ? order by user_id",
    )
      .bind(first.id)
      .all<{ user_id: string }>();
    expect(registrations.results.map((row) => row.user_id)).toEqual(["alice", "bob"]);
  });

  test("昇格登録した言葉は元の作成者にも公開登録者にも編集権がない", async () => {
    await createUser("alice");
    await createUser("bob");
    await insertWordRow({
      createdAt: Date.now(),
      createdBy: "alice",
      firstRegisteredAt: null,
      firstRegisteredBy: null,
      id: "upgrade-word",
      reading: "しょうかく",
      readingSubGroup: "し",
      word: "昇格語",
    });

    await requestJson("bob", "/v1/words", "POST", { reading: "しょうかく", word: "昇格語" });

    await expect(
      request("alice", "/v1/words/upgrade-word").then((r) => r.json()),
    ).resolves.toMatchObject({
      isEditableByMe: false,
    });
    await expect(
      request("bob", "/v1/words/upgrade-word").then((r) => r.json()),
    ).resolves.toMatchObject({
      isEditableByMe: false,
    });
  });
});

describe("word visibility", () => {
  test("非公開定義しかない言葉はみんなの辞書・検索・直接取得に出ない", async () => {
    await createUser("alice");
    await createUser("bob");
    await insertWordRow({
      createdAt: Date.now(),
      createdBy: "alice",
      firstRegisteredAt: null,
      firstRegisteredBy: null,
      id: "private-only",
      reading: "ひこうかい",
      readingSubGroup: "ひ",
      word: "非公開語",
    });
    await env.DB.prepare(
      `insert into definitions (id, word_id, author_id, body, status, finalized_at, is_edited, created_at, updated_at)
       values ('priv', 'private-only', 'alice', 'secret', 'private', ?, 0, ?, ?)`,
    )
      .bind(Date.now(), Date.now(), Date.now())
      .run();

    const list = await request("bob", "/v1/words");
    const listBody = await list.json<{ items: Array<{ id: string }> }>();
    expect(listBody.items.map((item) => item.id)).not.toContain("private-only");

    const search = await request("bob", `/v1/search/words?q=${encodeURIComponent("非公開")}`);
    const searchBody = await search.json<{ items: Array<{ id: string }> }>();
    expect(searchBody.items.map((item) => item.id)).not.toContain("private-only");

    expect((await request("bob", "/v1/words/private-only")).status).toBe(404);
    // 本人は自分の非公開定義があるため詳細を取得できる
    expect((await request("alice", "/v1/words/private-only")).status).toBe(200);
  });

  test("言葉単体登録された定義 0 件の言葉はみんなの辞書と検索に出る", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "単独登録", "たんどくとうろく");

    const list = await request("bob", "/v1/words");
    const listBody = await list.json<{
      items: Array<{ id: string; publicDefinitionCount: number }>;
    }>();
    expect(listBody.items).toContainEqual(
      expect.objectContaining({ id: word.id, publicDefinitionCount: 0 }),
    );

    const search = await request("bob", `/v1/search/words?q=${encodeURIComponent("単独")}`);
    const searchBody = await search.json<{ items: Array<{ id: string }> }>();
    expect(searchBody.items.map((item) => item.id)).toContain(word.id);
  });

  test("公開定義の非公開化で他の公開根拠がなければ言葉も非表示になる", async () => {
    await createUser("alice");
    await createUser("bob");
    await insertWordRow({
      createdAt: Date.now(),
      createdBy: "alice",
      firstRegisteredAt: null,
      firstRegisteredBy: null,
      id: "temp-public",
      reading: "いちじ",
      readingSubGroup: "い",
      word: "一時公開",
    });
    await insertPublicDefinitionRow("pub-def", "temp-public", "alice");

    expect((await request("bob", "/v1/words/temp-public")).status).toBe(200);

    await env.DB.prepare("update definitions set status = 'private' where id = 'pub-def'").run();

    expect((await request("bob", "/v1/words/temp-public")).status).toBe(404);
    const list = await request("bob", "/v1/words");
    const listBody = await list.json<{ items: Array<{ id: string }> }>();
    expect(listBody.items.map((item) => item.id)).not.toContain("temp-public");
  });

  test("保存した言葉が非公開になると一覧と直接取得から隠れ、saved_words は残る", async () => {
    await createUser("alice");
    await createUser("bob");
    await insertWordRow({
      createdAt: Date.now(),
      createdBy: "alice",
      firstRegisteredAt: null,
      firstRegisteredBy: null,
      id: "saved-hidden",
      reading: "ほぞん",
      readingSubGroup: "ほ",
      word: "保存隠れ",
    });
    await insertPublicDefinitionRow("saved-pub", "saved-hidden", "alice");
    await request("bob", "/v1/words/saved-hidden/save", { method: "PUT" });

    await env.DB.prepare("update definitions set status = 'private' where id = 'saved-pub'").run();

    const saved = await request("bob", "/v1/me/saved-words");
    const savedBody = await saved.json<{ items: Array<{ word: { id: string } }> }>();
    expect(savedBody.items.map((item) => item.word.id)).not.toContain("saved-hidden");
    expect((await request("bob", "/v1/words/saved-hidden")).status).toBe(404);

    const row = await env.DB.prepare(
      "select 1 as ok from saved_words where user_id = 'bob' and word_id = 'saved-hidden'",
    ).first();
    expect(row).toEqual({ ok: 1 });
  });
});

describe("GET /v1/words/{id}", () => {
  test("存在しない言葉は 404 word_not_found", async () => {
    await createUser("alice");

    const response = await request("alice", "/v1/words/missing-id");

    expect(response.status).toBe(404);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "word_not_found" },
    });
  });

  test("登録直後は登録者だけが編集可能と判定される", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");

    const forCreator = await request("alice", `/v1/words/${word.id}`);
    const forOther = await request("bob", `/v1/words/${word.id}`);

    await expect(forCreator.json()).resolves.toMatchObject({ isEditableByMe: true });
    await expect(forOther.json()).resolves.toMatchObject({ isEditableByMe: false });
  });
});

describe("PATCH /v1/words/{id}", () => {
  test("登録者は 1 時間以内なら表記とよみを修正でき、読みグループを再計算する", async () => {
    await createUser("alice");
    const word = await createWord("alice", "あんず", "あんず");

    const response = await requestJson("alice", `/v1/words/${word.id}`, "PATCH", {
      reading: "ガム",
      word: "がむ",
    });

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toMatchObject({
      id: word.id,
      reading: "ガム",
      readingSubGroup: "か",
      word: "がむ",
    });
  });

  test("登録者以外の修正は 403 word_not_editable", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");

    const response = await requestJson("bob", `/v1/words/${word.id}`, "PATCH", { word: "改変" });

    expect(response.status).toBe(403);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "word_not_editable" },
    });
  });

  test("登録から 1 時間を超えた修正は 403 word_not_editable", async () => {
    await createUser("alice");
    await insertWordRow({
      createdAt: Date.now() - 60 * 60 * 1000 - 1000,
      createdBy: "alice",
      id: "word-old",
      reading: "ふるい",
      readingSubGroup: "ふ",
      word: "ふるい",
    });

    const response = await requestJson("alice", "/v1/words/word-old", "PATCH", { word: "新しい" });

    expect(response.status).toBe(403);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "word_not_editable" },
    });
  });

  test("他ユーザーの定義がある言葉の修正は 403 word_not_editable", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    await insertPublicDefinitionRow("definition-1", word.id, "bob");

    const response = await requestJson("alice", `/v1/words/${word.id}`, "PATCH", { word: "改" });

    expect(response.status).toBe(403);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "word_not_editable" },
    });
  });

  test("他ユーザーの保存がある言葉の修正は 403 word_not_editable", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    await request("bob", `/v1/words/${word.id}/save`, { method: "PUT" });

    const response = await requestJson("alice", `/v1/words/${word.id}`, "PATCH", { word: "改" });

    expect(response.status).toBe(403);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "word_not_editable" },
    });
  });

  test("自分自身の定義や保存では編集可能なまま", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    await insertPublicDefinitionRow("definition-own", word.id, "alice");
    await request("alice", `/v1/words/${word.id}/save`, { method: "PUT" });

    const response = await requestJson("alice", `/v1/words/${word.id}`, "PATCH", { word: "言葉" });

    expect(response.status).toBe(200);
  });

  test("修正後の表記が既存の言葉と重複する場合は 409 で既存の言葉を返す", async () => {
    await createUser("alice");
    const existing = await createWord("alice", "りんご", "りんご");
    const word = await createWord("alice", "みかん", "みかん");

    const response = await requestJson("alice", `/v1/words/${word.id}`, "PATCH", {
      word: " りんご ",
    });

    expect(response.status).toBe(409);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "word_already_exists" },
      existingWord: { id: existing.id },
    });
  });

  test("正規化後に空になる修正は 400 invalid_request", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");

    const response = await requestJson("alice", `/v1/words/${word.id}`, "PATCH", { word: "  " });

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "invalid_request" },
    });
  });

  test("編集可否チェック後に他ユーザーの保存が入った場合も 403 word_not_editable", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "ことば", "ことば");
    // 編集可否チェックと UPDATE の間に bob の保存を割り込ませ、TOCTOU を再現する
    let intercepted = false;
    const racingDatabase = {
      prepare(query: string) {
        const statement = env.DB.prepare(query);
        if (!query.trimStart().startsWith("update words") || intercepted) return statement;
        intercepted = true;
        return {
          bind: (...values: unknown[]) => {
            const bound = statement.bind(...values);
            return {
              run: async () => {
                await env.DB.prepare(
                  "insert into saved_words (user_id, word_id, created_at) values (?, ?, ?)",
                )
                  .bind("bob", word.id, Date.now())
                  .run();
                return bound.run();
              },
            };
          },
        } as unknown as D1PreparedStatement;
      },
    } as unknown as D1Database;

    const response = await testApp("alice").request(
      `/v1/words/${word.id}`,
      {
        body: JSON.stringify({ word: "改変" }),
        headers: { ...authHeaders, "Content-Type": "application/json" },
        method: "PATCH",
      },
      { ...env, DB: racingDatabase },
    );

    expect(response.status).toBe(403);
    const row = await env.DB.prepare("select word from words where id = ?").bind(word.id).first();
    expect(row).toMatchObject({ word: "ことば" });
  });

  test("論理削除済みユーザーは自分が登録した言葉も修正できない", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");
    await request("alice", "/v1/users/me", { method: "DELETE" });

    const response = await requestJson("alice", `/v1/words/${word.id}`, "PATCH", { word: "改" });

    expect(response.status).toBe(404);
  });

  test("存在しない言葉の修正は 404 word_not_found", async () => {
    await createUser("alice");

    const response = await requestJson("alice", "/v1/words/missing-id", "PATCH", { word: "x" });

    expect(response.status).toBe(404);
  });
});

describe("GET /v1/words", () => {
  test("よみ順に並び、keyset pagination で続きを取得できる", async () => {
    await createUser("alice");
    await createWord("alice", "うめ", "うめ");
    await createWord("alice", "あんこ", "あんこ");
    await createWord("alice", "いちご", "いちご");

    const firstPage = await request("alice", "/v1/words?limit=2");
    expect(firstPage.status).toBe(200);
    const firstBody = await firstPage.json<{
      items: Array<{ word: string }>;
      nextCursor: string | null;
    }>();
    expect(firstBody.items.map((item) => item.word)).toEqual(["あんこ", "いちご"]);
    expect(firstBody.nextCursor).not.toBeNull();

    const secondPage = await request(
      "alice",
      `/v1/words?limit=2&cursor=${encodeURIComponent(firstBody.nextCursor!)}`,
    );
    const secondBody = await secondPage.json<{
      items: Array<{ word: string }>;
      nextCursor: string | null;
    }>();
    expect(secondBody.items.map((item) => item.word)).toEqual(["うめ"]);
    expect(secondBody.nextCursor).toBeNull();
  });

  test("subGroup で行を絞り込める", async () => {
    await createUser("alice");
    await createWord("alice", "あんこ", "あんこ");
    await createWord("alice", "がっこう", "ガッコウ");

    const response = await request("alice", `/v1/words?subGroup=${encodeURIComponent("か")}`);

    const body = await response.json<{ items: Array<{ word: string }> }>();
    expect(body.items.map((item) => item.word)).toEqual(["がっこう"]);
  });

  test("filter で定義の有無を絞り込める", async () => {
    await createUser("alice");
    const defined = await createWord("alice", "ていぎずみ", "ていぎずみ");
    await createWord("alice", "みていぎ", "みていぎ");
    await insertPublicDefinitionRow("definition-1", defined.id, "alice");

    const definedOnly = await request("alice", "/v1/words?filter=defined");
    const undefinedOnly = await request("alice", "/v1/words?filter=undefined");

    const definedBody = await definedOnly.json<{
      items: Array<{ word: string; publicDefinitionCount: number }>;
    }>();
    expect(definedBody.items.map((item) => item.word)).toEqual(["ていぎずみ"]);
    expect(definedBody.items[0]!.publicDefinitionCount).toBe(1);
    const undefinedBody = await undefinedOnly.json<{ items: Array<{ word: string }> }>();
    expect(undefinedBody.items.map((item) => item.word)).toEqual(["みていぎ"]);
  });

  test("公開定義数と filter は閲覧者がミュートした作者を除外する", async () => {
    await createUser("alice");
    await createUser("bob");
    const word = await createWord("alice", "朝", "あさ");
    await insertPublicDefinitionRow("definition-1", word.id, "bob");
    await env.DB.prepare("insert into user_mutes values ('alice', 'bob', 1)").run();

    const all = await request("alice", "/v1/words");
    const definedOnly = await request("alice", "/v1/words?filter=defined");
    const undefinedOnly = await request("alice", "/v1/words?filter=undefined");
    const allBody = await all.json<{
      items: Array<{ word: string; publicDefinitionCount: number }>;
    }>();
    const definedBody = await definedOnly.json<{ items: Array<{ word: string }> }>();
    const undefinedBody = await undefinedOnly.json<{ items: Array<{ word: string }> }>();

    expect(allBody.items).toMatchObject([{ word: "朝", publicDefinitionCount: 0 }]);
    expect(definedBody.items).toEqual([]);
    expect(undefinedBody.items.map((item) => item.word)).toEqual(["朝"]);
  });

  test("公開定義数と filter は論理削除済み作者を除外する", async () => {
    await createUser("alice");
    await createUser("deleted-author");
    const word = await createWord("alice", "朝", "あさ");
    await insertPublicDefinitionRow("definition-1", word.id, "deleted-author");
    await env.DB.prepare("update users set deleted_at = 1 where id = 'deleted-author'").run();

    const all = await request("alice", "/v1/words");
    const definedOnly = await request("alice", "/v1/words?filter=defined");
    const undefinedOnly = await request("alice", "/v1/words?filter=undefined");
    const allBody = await all.json<{
      items: Array<{ word: string; publicDefinitionCount: number }>;
    }>();
    const definedBody = await definedOnly.json<{ items: Array<{ word: string }> }>();
    const undefinedBody = await undefinedOnly.json<{ items: Array<{ word: string }> }>();

    expect(allBody.items).toMatchObject([{ word: "朝", publicDefinitionCount: 0 }]);
    expect(definedBody.items).toEqual([]);
    expect(undefinedBody.items.map((item) => item.word)).toEqual(["朝"]);
  });

  test("q で表記・よみを部分一致検索できる", async () => {
    await createUser("alice");
    await createWord("alice", "青りんご", "あおりんご");
    await createWord("alice", "みかん", "みかん");

    const byWord = await request("alice", `/v1/words?q=${encodeURIComponent("りんご")}`);
    const byReading = await request("alice", `/v1/words?q=${encodeURIComponent("あお")}`);

    const byWordBody = await byWord.json<{ items: Array<{ word: string }> }>();
    expect(byWordBody.items.map((item) => item.word)).toEqual(["青りんご"]);
    const byReadingBody = await byReading.json<{ items: Array<{ word: string }> }>();
    expect(byReadingBody.items.map((item) => item.word)).toEqual(["青りんご"]);
  });

  test("LIKE のワイルドカードをエスケープして検索する", async () => {
    await createUser("alice");
    await createWord("alice", "100%", "ひゃくぱーせんと");
    await createWord("alice", "満点", "まんてん");

    const response = await request("alice", `/v1/words?q=${encodeURIComponent("%")}`);

    const body = await response.json<{ items: Array<{ word: string }> }>();
    expect(body.items.map((item) => item.word)).toEqual(["100%"]);
  });

  test("不正な cursor は 400 invalid_cursor", async () => {
    await createUser("alice");

    const response = await request("alice", "/v1/words?cursor=broken");

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "invalid_cursor" },
    });
  });
});

describe("PUT / DELETE /v1/words/{id}/save", () => {
  test("保存と解除は冪等で、isSavedByMe に反映される", async () => {
    await createUser("alice");
    const word = await createWord("alice", "ことば", "ことば");

    const save1 = await request("alice", `/v1/words/${word.id}/save`, { method: "PUT" });
    const save2 = await request("alice", `/v1/words/${word.id}/save`, { method: "PUT" });
    expect(save1.status).toBe(204);
    expect(save2.status).toBe(204);
    const afterSave = await request("alice", `/v1/words/${word.id}`);
    await expect(afterSave.json()).resolves.toMatchObject({ isSavedByMe: true });

    const unsave1 = await request("alice", `/v1/words/${word.id}/save`, { method: "DELETE" });
    const unsave2 = await request("alice", `/v1/words/${word.id}/save`, { method: "DELETE" });
    expect(unsave1.status).toBe(204);
    expect(unsave2.status).toBe(204);
    const afterUnsave = await request("alice", `/v1/words/${word.id}`);
    await expect(afterUnsave.json()).resolves.toMatchObject({ isSavedByMe: false });
  });

  test("存在しない言葉の保存は 404 word_not_found", async () => {
    await createUser("alice");

    const response = await request("alice", "/v1/words/missing-id/save", { method: "PUT" });

    expect(response.status).toBe(404);
  });
});
