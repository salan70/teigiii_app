import { applyD1Migrations, env } from "cloudflare:test";
import { beforeEach, describe, expect, test } from "vitest";

import { createApp } from "../src/app";

const authHeaders = {
  Authorization: "Bearer valid-id-token",
  "X-Firebase-AppCheck": "valid-app-check",
};

type DraftResponse = {
  id: string;
  wordId: string | null;
  word: string;
  reading: string;
  body: string;
  visibility: "public" | "private";
  finalizedDefinitionId: string | null;
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

async function putDraft(
  uid: string,
  id: string,
  overrides: Partial<{
    wordId: string | null;
    word: string;
    reading: string;
    body: string;
    visibility: "public" | "private";
  }> = {},
) {
  return requestJson(uid, `/v1/definition-drafts/${id}`, "PUT", {
    body: "",
    reading: "",
    visibility: "public",
    word: "",
    ...overrides,
  });
}

beforeEach(async () => {
  await applyD1Migrations(env.DB, env.TEST_MIGRATIONS);
  await env.DB.batch([
    env.DB.prepare("delete from users"),
    env.DB.prepare("delete from words"),
    env.DB.prepare("delete from app_config"),
  ]);
});

describe("definition draft CRUD", () => {
  test("PUT は任意の1項目から同じ ID へ冪等に保存する", async () => {
    await createUser("alice");

    const created = await putDraft("alice", "018f0f50-0000-7000-8000-000000000001", {
      body: "本文だけ",
    });
    const updated = await putDraft("alice", "018f0f50-0000-7000-8000-000000000001", {
      reading: "ことば",
    });

    expect(created.status).toBe(200);
    expect(updated.status).toBe(200);
    await expect(updated.json<DraftResponse>()).resolves.toMatchObject({
      body: "",
      id: "018f0f50-0000-7000-8000-000000000001",
      reading: "ことば",
    });
    await expect(
      env.DB.prepare("select count(*) as count from definition_drafts").first(),
    ).resolves.toEqual({ count: 1 });
  });

  test("全項目空の新規 Draft は 400 draft_empty", async () => {
    await createUser("alice");

    const response = await putDraft("alice", "018f0f50-0000-7000-8000-000000000001");

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({ error: { code: "draft_empty" } });
  });

  test("空白を含む一項目入力も編集中の値として保存する", async () => {
    await createUser("alice");

    const response = await putDraft("alice", "018f0f50-0000-7000-8000-000000000001", {
      word: " ",
    });

    expect(response.status).toBe(200);
    await expect(response.json<DraftResponse>()).resolves.toMatchObject({ word: " " });
  });

  test("GET は本人だけ取得でき、他者には存在を秘匿する", async () => {
    await createUser("alice");
    await createUser("bob");
    const id = "018f0f50-0000-7000-8000-000000000001";
    await putDraft("alice", id, { word: "自由" });

    expect((await request("alice", `/v1/definition-drafts/${id}`)).status).toBe(200);
    const others = await request("bob", `/v1/definition-drafts/${id}`);
    expect(others.status).toBe(404);
    await expect(others.json()).resolves.toMatchObject({
      error: { code: "definition_draft_not_found" },
    });
  });

  test("一覧は未確定 Draft だけを更新日時降順で返す", async () => {
    await createUser("alice");
    await putDraft("alice", "018f0f50-0000-7000-8000-000000000001", { word: "先" });
    await putDraft("alice", "018f0f50-0000-7000-8000-000000000002", { word: "後" });

    const response = await request("alice", "/v1/me/definition-drafts?limit=1");

    expect(response.status).toBe(200);
    const first = await response.json<{ items: DraftResponse[]; nextCursor: string | null }>();
    expect(first.items).toHaveLength(1);
    expect(first.items[0]?.word).toBe("後");
    expect(first.nextCursor).not.toBeNull();
    const second = await request(
      "alice",
      `/v1/me/definition-drafts?limit=1&cursor=${encodeURIComponent(first.nextCursor!)}`,
    );
    await expect(second.json<{ items: DraftResponse[] }>()).resolves.toMatchObject({
      items: [{ word: "先" }],
    });
  });

  test("DELETE は本人に対して冪等で、他者の Draft は削除しない", async () => {
    await createUser("alice");
    await createUser("bob");
    const id = "018f0f50-0000-7000-8000-000000000001";
    await putDraft("alice", id, { word: "自由" });

    expect((await request("bob", `/v1/definition-drafts/${id}`, { method: "DELETE" })).status).toBe(
      204,
    );
    expect((await request("alice", `/v1/definition-drafts/${id}`)).status).toBe(200);
    expect(
      (await request("alice", `/v1/definition-drafts/${id}`, { method: "DELETE" })).status,
    ).toBe(204);
    expect(
      (await request("alice", `/v1/definition-drafts/${id}`, { method: "DELETE" })).status,
    ).toBe(204);
  });
});

describe("POST /v1/definition-drafts/{id}/finalize", () => {
  test("必須項目を検証する", async () => {
    await createUser("alice");
    const id = "018f0f50-0000-7000-8000-000000000001";
    await putDraft("alice", id, { body: "本文だけ" });

    const response = await requestJson("alice", `/v1/definition-drafts/${id}/finalize`, "POST", {});

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "draft_incomplete" },
    });
  });

  test("確定時に入力形式を検証する", async () => {
    await createUser("alice");
    const id = "018f0f50-0000-7000-8000-000000000001";
    await putDraft("alice", id, { body: "本文", reading: "漢字", word: "自由" });

    const response = await requestJson("alice", `/v1/definition-drafts/${id}/finalize`, "POST", {});

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toMatchObject({
      error: { code: "draft_invalid" },
    });
  });

  test("新規語を確定時にだけ登録し、同じ Draft ID の再試行で定義を重複作成しない", async () => {
    await createUser("alice");
    const id = "018f0f50-0000-7000-8000-000000000001";
    await putDraft("alice", id, { body: "説明", reading: "じゆう", word: "自由" });
    expect(await env.DB.prepare("select count(*) as count from words").first()).toEqual({
      count: 0,
    });

    const first = await requestJson("alice", `/v1/definition-drafts/${id}/finalize`, "POST", {});
    const retry = await requestJson("alice", `/v1/definition-drafts/${id}/finalize`, "POST", {});

    expect(first.status).toBe(200);
    expect(retry.status).toBe(200);
    const firstBody = await first.json<{ id: string; status: string }>();
    const retryBody = await retry.json<{ id: string; status: string }>();
    expect(retryBody.id).toBe(firstBody.id);
    expect(firstBody.status).toBe("public");
    expect(await env.DB.prepare("select count(*) as count from definitions").first()).toEqual({
      count: 1,
    });
    expect(await env.DB.prepare("select count(*) as count from words").first()).toEqual({
      count: 1,
    });
  });

  test("同一表記・同一よみは確認せず既存語へ紐付ける", async () => {
    await createUser("alice");
    const word = await createWord("alice", "自由", "じゆう");
    const id = "018f0f50-0000-7000-8000-000000000001";
    await putDraft("alice", id, { body: "説明", reading: "じゆう", word: "自由" });

    const response = await requestJson("alice", `/v1/definition-drafts/${id}/finalize`, "POST", {});

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toMatchObject({ word: { id: word.id } });
  });

  test("同一表記・異なるよみだけ確認を要求する", async () => {
    await createUser("alice");
    const word = await createWord("alice", "自由", "フリー");
    const id = "018f0f50-0000-7000-8000-000000000001";
    await putDraft("alice", id, { body: "説明", reading: "じゆう", word: "自由" });

    const conflict = await requestJson("alice", `/v1/definition-drafts/${id}/finalize`, "POST", {});
    expect(conflict.status).toBe(409);
    await expect(conflict.json()).resolves.toMatchObject({
      error: { code: "word_reading_mismatch" },
      existingWord: { id: word.id, reading: "フリー", word: "自由" },
    });

    const confirmed = await requestJson("alice", `/v1/definition-drafts/${id}/finalize`, "POST", {
      confirmReadingMismatch: true,
    });
    expect(confirmed.status).toBe(200);
    await expect(confirmed.json()).resolves.toMatchObject({ word: { id: word.id } });
  });

  test("本人以外は確定できない", async () => {
    await createUser("alice");
    await createUser("bob");
    const id = "018f0f50-0000-7000-8000-000000000001";
    await putDraft("alice", id, { body: "説明", reading: "じゆう", word: "自由" });

    const response = await requestJson("bob", `/v1/definition-drafts/${id}/finalize`, "POST", {});

    expect(response.status).toBe(404);
  });
});
