import { describe, expect, test } from "bun:test";
import { Hono } from "hono";

import {
  createAppCheckMiddleware,
  createFirebaseAuthMiddleware,
  idTokenExemptPaths,
} from "../../src/auth/middleware";

type TestEnv = {
  Variables: {
    appId: string;
    firebaseUid: string;
  };
};

function createTestApp() {
  const app = new Hono<TestEnv>();
  app.use(
    "*",
    createAppCheckMiddleware({
      verify: async (token) => {
        if (token !== "valid-app-check") throw new Error("invalid");
        return { appId: "test-app-id" };
      },
    }),
  );
  app.use(
    "*",
    createFirebaseAuthMiddleware({
      verify: async (token) => {
        if (token !== "valid-id-token") throw new Error("invalid");
        return { uid: "firebase-uid" };
      },
    }),
  );
  app.get("/v1/app-config", (c) => c.json({ appId: c.get("appId") }));
  app.post("/v1/telemetry/frames", (c) => c.json({ appId: c.get("appId") }));
  app.get("/v1/telemetry/frames/extra", (c) => c.json({ appId: c.get("appId") }));
  app.get("/v1/private", (c) => c.json({ appId: c.get("appId"), uid: c.get("firebaseUid") }));
  return app;
}

describe("authentication middleware", () => {
  test("認証 middleware を公開する", async () => {
    const modulePromise = import("../../src/auth/middleware");

    await expect(modulePromise).resolves.toHaveProperty("createAppCheckMiddleware");
    await expect(modulePromise).resolves.toHaveProperty("createFirebaseAuthMiddleware");
  });

  test("App Check ヘッダーがないリクエストを401で拒否する", async () => {
    const response = await createTestApp().request("/v1/private");

    expect(response.status).toBe(401);
    expect(await response.json<unknown>()).toEqual({
      error: { code: "app_check_invalid", message: "Unauthorized" },
    });
  });

  test("app-config は有効な App Check だけで通す", async () => {
    const response = await createTestApp().request("/v1/app-config", {
      headers: { "X-Firebase-AppCheck": "valid-app-check" },
    });

    expect(response.status).toBe(200);
    expect(await response.json<unknown>()).toEqual({ appId: "test-app-id" });
  });

  test("app-config 以外は Firebase ID トークンも必須にする", async () => {
    const response = await createTestApp().request("/v1/private", {
      headers: { "X-Firebase-AppCheck": "valid-app-check" },
    });

    expect(response.status).toBe(401);
    expect(await response.json<unknown>()).toEqual({
      error: { code: "firebase_id_token_invalid", message: "Unauthorized" },
    });
  });

  test("免除パスは app-config とテレメトリ受信だけとする", () => {
    expect([...idTokenExemptPaths]).toEqual(["/v1/app-config", "/v1/telemetry/frames"]);
  });

  test("テレメトリ受信は有効な App Check だけで通す", async () => {
    const response = await createTestApp().request("/v1/telemetry/frames", {
      method: "POST",
      headers: { "X-Firebase-AppCheck": "valid-app-check" },
    });

    expect(response.status).toBe(200);
    expect(await response.json<unknown>()).toEqual({ appId: "test-app-id" });
  });

  test("テレメトリ受信も App Check がなければ401で拒否する", async () => {
    const response = await createTestApp().request("/v1/telemetry/frames", { method: "POST" });

    expect(response.status).toBe(401);
    expect(await response.json<unknown>()).toEqual({
      error: { code: "app_check_invalid", message: "Unauthorized" },
    });
  });

  test("免除は完全一致で、前方一致するパスには波及しない", async () => {
    const response = await createTestApp().request("/v1/telemetry/frames/extra", {
      headers: { "X-Firebase-AppCheck": "valid-app-check" },
    });

    expect(response.status).toBe(401);
    expect(await response.json<unknown>()).toEqual({
      error: { code: "firebase_id_token_invalid", message: "Unauthorized" },
    });
  });

  test("検証済みの appId と uid をリクエストコンテキストへ設定する", async () => {
    const response = await createTestApp().request("/v1/private", {
      headers: {
        Authorization: "Bearer valid-id-token",
        "X-Firebase-AppCheck": "valid-app-check",
      },
    });

    expect(response.status).toBe(200);
    expect(await response.json<unknown>()).toEqual({
      appId: "test-app-id",
      uid: "firebase-uid",
    });
  });

  test("不正な App Check トークンを401で拒否する", async () => {
    const response = await createTestApp().request("/v1/private", {
      headers: { "X-Firebase-AppCheck": "invalid" },
    });

    expect(response.status).toBe(401);
    expect(await response.json<unknown>()).toEqual({
      error: { code: "app_check_invalid", message: "Unauthorized" },
    });
  });
});
