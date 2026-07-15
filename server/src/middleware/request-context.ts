import type { MiddlewareHandler } from "hono";

export type RequestContextVariables = {
  requestId: string;
};

export type RequestLogEntry = {
  durationMs: number;
  method: string;
  path: string;
  requestId: string;
  status: number;
};

type RequestContextEnvironment = {
  Variables: RequestContextVariables;
};

type RequestContextMiddlewareOptions = {
  generateRequestId?: () => string;
  log?: (entry: RequestLogEntry) => void;
  now?: () => number;
};

/**
 * @doc doc/specs/workers-api-server.md#リクエスト-id-とログ
 */
export function createRequestContextMiddleware({
  generateRequestId = () => crypto.randomUUID(),
  log = (entry) => console.log(JSON.stringify(entry)),
  now = () => performance.now(),
}: RequestContextMiddlewareOptions = {}): MiddlewareHandler<RequestContextEnvironment> {
  return async (context, next) => {
    const requestId = generateRequestId();
    const startedAt = now();
    context.set("requestId", requestId);
    context.header("X-Request-ID", requestId);

    let status = 500;
    try {
      await next();
      status = context.res.status;
    } finally {
      log({
        durationMs: Math.max(0, now() - startedAt),
        method: context.req.method,
        path: context.req.path,
        requestId,
        status,
      });
    }
  };
}
