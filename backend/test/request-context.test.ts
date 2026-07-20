import { describe, expect, test } from "bun:test";
import { Hono } from "hono";

import {
  createRequestContextMiddleware,
  type RequestLogEntry,
} from "../src/middleware/request-context";

describe("request context middleware", () => {
  test("request context middleware を公開する", async () => {
    const modulePromise = import("../src/middleware/request-context");

    await expect(modulePromise).resolves.toHaveProperty("createRequestContextMiddleware");
  });

  test("request IDをコンテキストとレスポンスへ設定して安全な項目だけ記録する", async () => {
    const entries: RequestLogEntry[] = [];
    const times = [100, 125];
    const app = new Hono<{ Variables: { requestId: string } }>();
    app.use(
      "*",
      createRequestContextMiddleware({
        generateRequestId: () => "request-id-1",
        log: (entry) => entries.push(entry),
        now: () => times.shift()!,
      }),
    );
    app.get("/test", (context) => context.json({ requestId: context.get("requestId") }));

    const response = await app.request("/test", {
      headers: {
        Authorization: "Bearer secret-token",
        "X-Firebase-AppCheck": "secret-app-check-token",
      },
    });

    expect(response.headers.get("X-Request-ID")).toBe("request-id-1");
    expect(await response.json<unknown>()).toEqual({ requestId: "request-id-1" });
    expect(entries).toEqual([
      {
        durationMs: 25,
        method: "GET",
        path: "/test",
        requestId: "request-id-1",
        status: 200,
      },
    ]);
    expect(JSON.stringify(entries)).not.toContain("secret-token");
    expect(JSON.stringify(entries)).not.toContain("secret-app-check-token");
  });

  test("ハンドラが例外を投げた場合も500の構造化ログを記録する", async () => {
    const entries: RequestLogEntry[] = [];
    const times = [100, 125];
    const app = new Hono<{ Variables: { requestId: string } }>();
    app.use(
      "*",
      createRequestContextMiddleware({
        generateRequestId: () => "request-id-2",
        log: (entry) => entries.push(entry),
        now: () => times.shift()!,
      }),
    );
    app.get("/error", () => {
      throw new Error("sensitive-error-detail");
    });
    app.onError((_, context) => context.json({ error: "internal_error" }, 500));

    const response = await app.request("/error");

    expect(response.status).toBe(500);
    expect(entries).toEqual([
      {
        durationMs: 25,
        method: "GET",
        path: "/error",
        requestId: "request-id-2",
        status: 500,
      },
    ]);
    expect(JSON.stringify(entries)).not.toContain("sensitive-error-detail");
  });

  test("error handler 自体が例外を投げても500の構造化ログを記録する", async () => {
    const entries: RequestLogEntry[] = [];
    const times = [100, 125];
    const app = new Hono<{ Variables: { requestId: string } }>();
    app.use(
      "*",
      createRequestContextMiddleware({
        generateRequestId: () => "request-id-3",
        log: (entry) => entries.push(entry),
        now: () => times.shift()!,
      }),
    );
    app.get("/error", () => {
      throw new Error("route-error");
    });
    app.onError(() => {
      throw new Error("error-handler-error");
    });

    await expect(app.request("/error")).rejects.toThrow("error-handler-error");
    expect(entries).toEqual([
      {
        durationMs: 25,
        method: "GET",
        path: "/error",
        requestId: "request-id-3",
        status: 500,
      },
    ]);
  });
});
