/**
 * 配信済み v1.2.1+11 の生成クライアントとの後方互換を固定する（#322）。
 *
 * 生成クライアントは `$checkKeys(requiredKeys:)` で必須キーの存在だけを検査し、未知キーは無視する。
 * したがって「旧クライアントが必須とするキーがレスポンスに全て存在すること」が互換の必要十分条件になる。
 * ここでの期待値は tag `v1.2.1+11` の `*.g.dart` から literal で書き写したものであり、
 * 現行スキーマから導出してはならない（導出すると削除を検知できない）。
 */
import { applyD1Migrations, env } from "cloudflare:test";
import { beforeEach, describe, expect, test } from "vitest";

import { createApp } from "../src/app";
import { readingSubGroup } from "../src/words/reading-sub-group";

/** v1.2.1+11:mobile_app/packages/teigiii_api/lib/src/model/my_dictionary_overview.g.dart */
const myDictionaryOverviewRequiredKeys = [
  "definedWordCount",
  "draftCount",
  "savedWordCount",
  "recentDefinitions",
];

/** v1.2.1+11:mobile_app/packages/teigiii_api/lib/src/model/defined_word_item.g.dart:101 */
const definedWordItemRequiredKeys = ["word", "publicCount", "privateCount", "draftCount"];

const authHeaders = {
  Authorization: "Bearer valid-id-token",
  "X-Firebase-AppCheck": "valid-app-check",
};

async function request(path: string) {
  const app = createApp({
    logRequest: () => {},
    verifyAppCheck: async () => ({ appId: "test-app-id" }),
    verifyFirebaseIdToken: async () => ({ uid: "alice" }),
  });
  return app.request(path, { headers: authHeaders }, env);
}

beforeEach(async () => {
  await applyD1Migrations(env.DB, env.TEST_MIGRATIONS);
  await env.DB.batch([env.DB.prepare("delete from users"), env.DB.prepare("delete from words")]);

  await env.DB.prepare(
    `insert into users
       (id, public_id, name, bio, last_os_version, last_app_version, created_at, updated_at)
     values ('alice', 'alice-public', 'alice', '', 'iOS 19', '1.2.1', 1, 1)`,
  ).run();
  await env.DB.prepare(
    `insert into words
       (id, word, reading, reading_sub_group, created_by,
        first_registered_at, first_registered_by, created_at, updated_at)
     values ('w1', '朝', 'あさ', ?, 'alice', 10, 'alice', 10, 10)`,
  )
    .bind(readingSubGroup("あさ"))
    .run();
  await env.DB.prepare(
    `insert into definitions
       (id, word_id, author_id, body, status, finalized_at, is_edited, created_at, updated_at)
     values ('d1', 'w1', 'alice', 'body', 'public', 100, 0, 100, 100)`,
  ).run();
});

describe("v1.2.1+11 の生成クライアントとの互換", () => {
  test("GET /v1/me/dictionary/overview が旧クライアントの必須キーを全て返す", async () => {
    const response = await request("/v1/me/dictionary/overview");
    expect(response.status).toBe(200);

    const body = await response.json<Record<string, unknown>>();
    expect(Object.keys(body)).toEqual(expect.arrayContaining(myDictionaryOverviewRequiredKeys));
    expect(body.draftCount).toBe(0);
  });

  test("GET /v1/me/defined-words の各要素が旧クライアントの必須キーを全て返す", async () => {
    const response = await request("/v1/me/defined-words");
    expect(response.status).toBe(200);

    const body = await response.json<{ items: Record<string, unknown>[] }>();
    expect(body.items.length).toBeGreaterThan(0);
    for (const item of body.items) {
      expect(Object.keys(item)).toEqual(expect.arrayContaining(definedWordItemRequiredKeys));
      expect(item.draftCount).toBe(0);
    }
  });

  // シムは wire レベルに限定し、契約（OpenAPI）へ復活させない。
  // 契約に必須で戻すと、シム撤去時にその時点の配信済みアプリを再び壊す。
  test("draftCount は OpenAPI 契約に含まれない", async () => {
    const { buildOpenApiDocument } = await import("../src/app");
    const schemas = buildOpenApiDocument().components?.schemas ?? {};

    for (const name of ["MyDictionaryOverview", "DefinedWordItem"]) {
      const schema = schemas[name] as { properties?: Record<string, unknown> };
      expect(Object.keys(schema.properties ?? {})).not.toContain("draftCount");
    }
  });
});
