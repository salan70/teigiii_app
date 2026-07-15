import { applyD1Migrations, env } from "cloudflare:test";
import { beforeEach, describe, expect, test } from "vitest";

import { createApp } from "../src/app";

const authHeaders = {
  Authorization: "Bearer valid-id-token",
  "X-Firebase-AppCheck": "valid-app-check",
};

type Page<T> = { items: T[]; nextCursor: string | null };

function testApp(uid: string) {
  return createApp({
    logRequest: () => {},
    verifyAppCheck: async () => ({ appId: "test-app-id" }),
    verifyFirebaseIdToken: async () => ({ uid }),
  });
}

async function request(uid: string, path: string) {
  return testApp(uid).request(path, { headers: authHeaders }, env);
}

async function insertUser(id: string, name = id, publicId = `${id}-public`) {
  await env.DB.prepare(
    `insert into users
       (id, public_id, name, bio, last_os_version, last_app_version, created_at, updated_at)
     values (?, ?, ?, '', 'iOS 19', '2.0.0', 1, 1)`,
  )
    .bind(id, publicId, name)
    .run();
}

async function insertWord(
  id: string,
  word: string,
  reading: string,
  createdBy: string,
  createdAt: number,
) {
  await env.DB.prepare(
    `insert into words
       (id, word, reading, reading_sub_group, created_by, created_at, updated_at)
     values (?, ?, ?, 'あ', ?, ?, ?)`,
  )
    .bind(id, word, reading, createdBy, createdAt, createdAt)
    .run();
}

async function insertDefinition(
  id: string,
  wordId: string,
  authorId: string,
  status: "draft" | "public" | "private",
  timestamp: number,
) {
  await env.DB.prepare(
    `insert into definitions
       (id, word_id, author_id, body, status, finalized_at, is_edited, created_at, updated_at)
     values (?, ?, ?, ?, ?, ?, 0, ?, ?)`,
  )
    .bind(
      id,
      wordId,
      authorId,
      `${id} body`,
      status,
      status === "draft" ? null : timestamp,
      timestamp,
      timestamp,
    )
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

describe("dictionary and definition lists", () => {
  test("公開辞書は public 定義だけを言葉単位に集計し、本人の定義一覧は非公開も返す", async () => {
    await insertUser("alice");
    await insertUser("bob");
    await insertWord("w1", "朝", "あさ", "alice", 10);
    await insertWord("w2", "夜", "よる", "alice", 20);
    await insertDefinition("public-1", "w1", "alice", "public", 100);
    await insertDefinition("public-2", "w1", "alice", "public", 200);
    await insertDefinition("private", "w2", "alice", "private", 300);
    await insertDefinition("draft", "w2", "alice", "draft", 400);

    const dictionary = await request("bob", "/v1/users/alice/dictionary");
    expect(dictionary.status).toBe(200);
    await expect(dictionary.json()).resolves.toMatchObject({
      items: [{ publicCount: 2, word: { id: "w1" } }],
      nextCursor: null,
    });

    const own = await request("alice", "/v1/users/alice/definitions?limit=10");
    expect(own.status).toBe(200);
    const ownBody = await own.json<Page<{ id: string }>>();
    expect(ownBody.items.map((item) => item.id)).toEqual(["private", "public-2", "public-1"]);

    const other = await request("bob", "/v1/users/alice/definitions?limit=10");
    const otherBody = await other.json<Page<{ id: string }>>();
    expect(otherBody.items.map((item) => item.id)).toEqual(["public-2", "public-1"]);
  });

  test("いいね一覧はいいね日時順で、閲覧者から不可視な定義を除外する", async () => {
    await insertUser("alice");
    await insertUser("bob");
    await insertUser("carol");
    await insertWord("w1", "朝", "あさ", "alice", 10);
    await insertDefinition("public", "w1", "alice", "public", 100);
    await insertDefinition("private", "w1", "alice", "private", 200);
    await env.DB.batch([
      env.DB.prepare("insert into likes values ('carol', 'public', 10)"),
      env.DB.prepare("insert into likes values ('carol', 'private', 20)"),
    ]);

    const response = await request("bob", "/v1/users/carol/liked-definitions");
    expect(response.status).toBe(200);
    const body = await response.json<Page<{ id: string }>>();
    expect(body.items.map((item) => item.id)).toEqual(["public"]);
  });
});

describe("my dictionary lists", () => {
  test("概要・定義済み言葉・状態別定義・保存・ミュートを返す", async () => {
    await insertUser("alice");
    await insertUser("bob", "Bob");
    await insertWord("w1", "朝", "あさ", "alice", 10);
    await insertWord("w2", "夜", "よる", "bob", 20);
    await insertDefinition("public", "w1", "alice", "public", 100);
    await insertDefinition("private", "w1", "alice", "private", 200);
    await insertDefinition("draft", "w2", "alice", "draft", 300);
    await env.DB.batch([
      env.DB.prepare("insert into saved_words values ('alice', 'w2', 400)"),
      env.DB.prepare("insert into user_mutes values ('alice', 'bob', 500)"),
    ]);

    const overview = await request("alice", "/v1/me/dictionary/overview");
    expect(overview.status).toBe(200);
    await expect(overview.json()).resolves.toMatchObject({
      definedWordCount: 2,
      draftCount: 1,
      savedWordCount: 1,
      recentDefinitions: [{ id: "draft" }, { id: "private" }, { id: "public" }],
    });

    const definedWords = await request("alice", "/v1/me/defined-words");
    await expect(definedWords.json()).resolves.toMatchObject({
      items: [
        { draftCount: 0, privateCount: 1, publicCount: 1, word: { id: "w1" } },
        { draftCount: 1, privateCount: 0, publicCount: 0, word: { id: "w2" } },
      ],
    });

    const drafts = await request("alice", "/v1/me/definitions?status=draft");
    await expect(drafts.json()).resolves.toMatchObject({ items: [{ id: "draft" }] });

    const saved = await request("alice", "/v1/me/saved-words");
    await expect(saved.json()).resolves.toMatchObject({
      items: [{ isDefinedByMe: true, word: { id: "w2" } }],
    });

    const mutes = await request("alice", "/v1/me/mutes");
    await expect(mutes.json()).resolves.toMatchObject({
      items: [{ id: "bob", isMutedByMe: true, name: "Bob" }],
    });
  });
});

describe("word definition lists", () => {
  test("scope とリアクション順を適用し keyset で重複なくページングする", async () => {
    await insertUser("alice");
    await insertUser("bob");
    await insertUser("carol");
    await insertWord("w1", "朝", "あさ", "alice", 10);
    await insertDefinition("mine-private", "w1", "alice", "private", 100);
    await insertDefinition("bob-public", "w1", "bob", "public", 200);
    await insertDefinition("carol-public", "w1", "carol", "public", 300);
    await env.DB.batch([
      env.DB.prepare("insert into likes values ('alice', 'bob-public', 1)"),
      env.DB.prepare("insert into likes values ('carol', 'bob-public', 2)"),
      env.DB.prepare("insert into likes values ('alice', 'carol-public', 3)"),
    ]);

    const first = await request(
      "alice",
      "/v1/words/w1/definitions?scope=all&sort=reactions&limit=1",
    );
    expect(first.status).toBe(200);
    const firstBody = await first.json<Page<{ id: string }>>();
    expect(firstBody.items.map((item) => item.id)).toEqual(["bob-public"]);
    expect(firstBody.nextCursor).not.toBeNull();

    const second = await request(
      "alice",
      `/v1/words/w1/definitions?scope=all&sort=reactions&limit=2&cursor=${firstBody.nextCursor}`,
    );
    const secondBody = await second.json<Page<{ id: string }>>();
    expect(secondBody.items.map((item) => item.id)).toEqual(["carol-public", "mine-private"]);
  });

  test("論理削除済みユーザーのいいねは表示件数にもリアクション順にも含めない", async () => {
    await insertUser("alice");
    await insertUser("bob");
    await insertUser("carol");
    await insertUser("deleted");
    await insertWord("w1", "朝", "あさ", "alice", 10);
    await insertDefinition("older", "w1", "bob", "public", 100);
    await insertDefinition("newer", "w1", "carol", "public", 200);
    await env.DB.batch([
      env.DB.prepare("insert into likes values ('alice', 'older', 1)"),
      env.DB.prepare("insert into likes values ('deleted', 'older', 2)"),
      env.DB.prepare("insert into likes values ('alice', 'newer', 3)"),
      env.DB.prepare("update users set deleted_at = 4 where id = 'deleted'"),
    ]);

    const first = await request(
      "alice",
      "/v1/words/w1/definitions?scope=all&sort=reactions&limit=1",
    );
    const firstBody = await first.json<Page<{ id: string; likesCount: number }>>();
    expect(firstBody.items).toMatchObject([{ id: "newer", likesCount: 1 }]);
    expect(firstBody.nextCursor).not.toBeNull();

    const second = await request(
      "alice",
      `/v1/words/w1/definitions?scope=all&sort=reactions&limit=1&cursor=${firstBody.nextCursor}`,
    );
    const secondBody = await second.json<Page<{ id: string; likesCount: number }>>();
    expect(secondBody.items).toMatchObject([{ id: "older", likesCount: 1 }]);
  });
});

describe("timelines and search", () => {
  test("見つけるは定義と言葉を完全な新着順で混在し、ミュート対象を除外する", async () => {
    await insertUser("alice");
    await insertUser("bob");
    await insertUser("carol");
    await insertWord("old-word", "古", "ふる", "carol", 100);
    await insertWord("muted-word", "無音", "むおん", "bob", 400);
    await insertDefinition("new-definition", "old-word", "carol", "public", 300);
    await insertDefinition("muted-definition", "old-word", "bob", "public", 500);
    await env.DB.prepare("insert into user_mutes values ('alice', 'bob', 1)").run();

    const response = await request("alice", "/v1/timeline/discover");
    expect(response.status).toBe(200);
    const body =
      await response.json<
        Page<{ type: string; definition?: { id: string }; word?: { id: string } }>
      >();
    expect(body.items).toMatchObject([
      { definition: { id: "new-definition" }, type: "definition" },
      { type: "wordRegistered", word: { id: "old-word" } },
    ]);
  });

  test("フォロー中はフォロー対象の公開定義だけを返しミュートを優先する", async () => {
    await insertUser("alice");
    await insertUser("bob");
    await insertUser("carol");
    await insertWord("w1", "朝", "あさ", "bob", 10);
    await insertDefinition("bob-public", "w1", "bob", "public", 200);
    await insertDefinition("carol-public", "w1", "carol", "public", 300);
    await env.DB.batch([
      env.DB.prepare("insert into follows values ('alice', 'bob', 1)"),
      env.DB.prepare("insert into follows values ('alice', 'carol', 2)"),
      env.DB.prepare("insert into user_mutes values ('alice', 'carol', 3)"),
    ]);

    const response = await request("alice", "/v1/timeline/following");
    const body = await response.json<Page<{ id: string }>>();
    expect(body.items.map((item) => item.id)).toEqual(["bob-public"]);
  });

  test("言葉・ユーザーを部分一致検索し、ミュート対象とその登録語を除外する", async () => {
    await insertUser("alice", "Alice", "111111111");
    await insertUser("bob", "Bobby", "222222222");
    await insertUser("carol", "Carol", "333333333");
    await insertWord("w1", "朝焼け", "あさやけ", "bob", 10);
    await insertWord("w2", "朝食", "ちょうしょく", "carol", 20);
    await env.DB.prepare("insert into user_mutes values ('alice', 'bob', 1)").run();

    const words = await request("alice", "/v1/search/words?q=%E6%9C%9D");
    expect(words.status).toBe(200);
    const wordBody = await words.json<Page<{ id: string }>>();
    expect(wordBody.items.map((item) => item.id)).toEqual(["w2"]);

    const users = await request("alice", "/v1/search/users?q=2");
    const userBody = await users.json<Page<{ id: string }>>();
    expect(userBody.items).toEqual([]);
  });
});

describe("query plans", () => {
  test("主要一覧は設計済みインデックスを使用できる", async () => {
    const definitionPlan = await env.DB.prepare(
      `explain query plan
       select id from definitions
       where status = 'public' and deleted_at is null
       order by finalized_at desc, id desc limit 21`,
    ).all<{ detail: string }>();
    expect(definitionPlan.results.map((row) => row.detail).join("\n")).toContain(
      "definitions_timeline_idx",
    );

    const wordPlan = await env.DB.prepare(
      `explain query plan
       select id from words order by reading_sub_group, reading, id limit 21`,
    ).all<{ detail: string }>();
    expect(wordPlan.results.map((row) => row.detail).join("\n")).toContain(
      "words_reading_order_idx",
    );
  });
});
