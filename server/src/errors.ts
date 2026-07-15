import type { ErrorHandler, NotFoundHandler } from "hono";
import { HTTPException } from "hono/http-exception";
import type { ContentfulStatusCode } from "hono/utils/http-status";
import type { RequestContextVariables } from "./middleware/request-context";

export type UnexpectedErrorLogEntry = {
  errorName: string;
  event: "unhandled_api_error";
  requestId: string | undefined;
};

type ApiErrorEnvironment = {
  Variables: RequestContextVariables;
};

type ApiErrorHandlerOptions = {
  log?: (entry: UnexpectedErrorLogEntry) => void;
};

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

export function createApiErrorHandler<
  Environment extends ApiErrorEnvironment = ApiErrorEnvironment,
>({
  log = (entry) => console.error(JSON.stringify(entry)),
}: ApiErrorHandlerOptions = {}): ErrorHandler<Environment> {
  return (error, context) => {
    if (error instanceof ApiError) {
      return context.json({ error: { code: error.code, message: error.message } }, error.status);
    }

    if (error instanceof HTTPException) {
      const code = error.status === 501 ? "not_implemented" : `http_${error.status}`;
      return context.json({ error: { code, message: error.message } }, error.status);
    }

    log({
      errorName: error instanceof Error ? error.name : "UnknownError",
      event: "unhandled_api_error",
      requestId: context.get("requestId"),
    });

    return context.json(
      { error: { code: "internal_error", message: "Internal Server Error" } },
      500,
    );
  };
}

export const handleApiError = createApiErrorHandler();

export const handleNotFound: NotFoundHandler = (context) =>
  context.json({ error: { code: "route_not_found", message: "Not Found" } }, 404);
