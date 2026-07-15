import { describe, expect, test } from "bun:test";
import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";

import { ApiError, handleApiError, handleNotFound } from "../src/errors";

function appWithErrors() {
  const app = new Hono();
  app.onError(handleApiError);
  app.notFound(handleNotFound);
  app.get("/known", () => {
    throw new ApiError(403, "edit_window_expired", "編集期限を過ぎています");
  });
  app.get("/unknown", () => {
    throw new Error("database password must not leak");
  });
  app.get("/http", () => {
    throw new HTTPException(501, { message: "not implemented" });
  });
  return app;
}

describe("API error handler", () => {
  test("ApiError と error handler を公開する", async () => {
    const modulePromise = import("../src/errors");

    await expect(modulePromise).resolves.toHaveProperty("ApiError");
    await expect(modulePromise).resolves.toHaveProperty("handleApiError");
    await expect(modulePromise).resolves.toHaveProperty("handleNotFound");
  });

  test("想定済みエラーを指定した status と code で返す", async () => {
    const response = await appWithErrors().request("/known");

    expect(response.status).toBe(403);
    expect(await response.json<unknown>()).toEqual({
      error: { code: "edit_window_expired", message: "編集期限を過ぎています" },
    });
  });

  test("予期しない例外の詳細をレスポンスへ含めない", async () => {
    const response = await appWithErrors().request("/unknown");

    expect(response.status).toBe(500);
    const body = await response.json<unknown>();
    expect(body).toEqual({
      error: { code: "internal_error", message: "Internal Server Error" },
    });
    expect(JSON.stringify(body)).not.toContain("database password");
  });

  test("HTTPException の status を維持して統一形式にする", async () => {
    const response = await appWithErrors().request("/http");

    expect(response.status).toBe(501);
    expect(await response.json<unknown>()).toEqual({
      error: { code: "not_implemented", message: "not implemented" },
    });
  });

  test("存在しないルートを統一形式の404にする", async () => {
    const response = await appWithErrors().request("/missing");

    expect(response.status).toBe(404);
    expect(await response.json<unknown>()).toEqual({
      error: { code: "route_not_found", message: "Not Found" },
    });
  });
});
