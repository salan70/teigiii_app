import { describe, expect, test } from "bun:test";

import { createApp } from "../src/app";
import type { RequestLogEntry } from "../src/middleware/request-context";

function testApp() {
  return createApp({
    logRequest: () => {},
    verifyAppCheck: async (token) => {
      if (token !== "valid-app-check") throw new Error("invalid");
      return { appId: "test-app-id" };
    },
    verifyFirebaseIdToken: async (token) => {
      if (token !== "valid-id-token") throw new Error("invalid");
      return { uid: "firebase-uid" };
    },
  });
}

describe("createApp", () => {
  test("依存注入可能な Hono app factory を公開する", async () => {
    const modulePromise = import("../src/app");

    await expect(modulePromise).resolves.toHaveProperty("createApp");
  });

  test("実ルートへ到達する前に App Check を要求する", async () => {
    const response = await testApp().request("/v1/app-config");

    expect(response.status).toBe(401);
  });

  test("app-config は App Check 検証後にルートへ到達する", async () => {
    const response = await testApp().request("/v1/app-config", {
      headers: { "X-Firebase-AppCheck": "valid-app-check" },
    });

    expect(response.status).toBe(501);
  });

  test("認証必須ルートは Firebase ID トークンも要求する", async () => {
    const response = await testApp().request("/v1/users/me", {
      headers: { "X-Firebase-AppCheck": "valid-app-check" },
    });

    expect(response.status).toBe(401);
  });

  test("両トークンの検証後に認証必須ルートへ到達する", async () => {
    // #193 実装までは未実装（501）の /v1/me/mutes で到達確認する
    const response = await testApp().request("/v1/me/mutes", {
      headers: {
        Authorization: "Bearer valid-id-token",
        "X-Firebase-AppCheck": "valid-app-check",
      },
    });

    expect(response.status).toBe(501);
    expect(await response.json<unknown>()).toEqual({
      error: { code: "not_implemented", message: "not implemented" },
    });
  });

  test("認証で拒否したリクエストにも request ID と構造化ログを付ける", async () => {
    const entries: RequestLogEntry[] = [];
    const app = createApp({
      generateRequestId: () => "request-id-1",
      logRequest: (entry) => entries.push(entry),
      verifyAppCheck: async () => ({ appId: "unused" }),
      verifyFirebaseIdToken: async () => ({ uid: "unused" }),
    });

    const response = await app.request("/v1/app-config");

    expect(response.headers.get("X-Request-ID")).toBe("request-id-1");
    expect(entries).toHaveLength(1);
    expect(entries[0]).toMatchObject({ requestId: "request-id-1", status: 401 });
  });

  test("存在しないルートを統一エラー形式で返す", async () => {
    const response = await testApp().request("/missing", {
      headers: {
        Authorization: "Bearer valid-id-token",
        "X-Firebase-AppCheck": "valid-app-check",
      },
    });

    expect(response.status).toBe(404);
    expect(await response.json<unknown>()).toEqual({
      error: { code: "route_not_found", message: "Not Found" },
    });
  });
});
