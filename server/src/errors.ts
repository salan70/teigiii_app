import type { ErrorHandler, NotFoundHandler } from "hono";
import { HTTPException } from "hono/http-exception";
import type { ContentfulStatusCode } from "hono/utils/http-status";

/**
 * @doc doc/specs/workers-api-server.md#エラー形式
 */
export class ApiError extends Error {
  constructor(
    readonly status: ContentfulStatusCode,
    readonly code: string,
    message: string,
  ) {
    super(message);
    this.name = "ApiError";
  }
}

export const handleApiError: ErrorHandler = (error, context) => {
  if (error instanceof ApiError) {
    return context.json({ error: { code: error.code, message: error.message } }, error.status);
  }

  if (error instanceof HTTPException) {
    const code = error.status === 501 ? "not_implemented" : `http_${error.status}`;
    return context.json({ error: { code, message: error.message } }, error.status);
  }

  return context.json({ error: { code: "internal_error", message: "Internal Server Error" } }, 500);
};

export const handleNotFound: NotFoundHandler = (context) =>
  context.json({ error: { code: "route_not_found", message: "Not Found" } }, 404);
