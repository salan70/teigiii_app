import { cors } from "hono/cors";
import type { MiddlewareHandler } from "hono";

const LOCALHOST_ORIGIN = /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/i;
const LAN_ORIGIN =
  /^https?:\/\/((192\.168\.\d{1,3}\.\d{1,3})|(10\.\d{1,3}\.\d{1,3}\.\d{1,3})|(172\.(1[6-9]|2\d|3[0-1])\.\d{1,3}\.\d{1,3}))(:\d+)?$/i;
const PAGES_DEV_ORIGIN = /^https:\/\/([a-z0-9-]+\.)*pages\.dev$/i;

/**
 * Web QA プレビュー（localhost / LAN / Cloudflare Pages）からの
 * ブラウザアクセスを許可する origin 判定。
 */
export function isAllowedWebQaOrigin(origin: string): boolean {
  if (!origin) return false;
  return LOCALHOST_ORIGIN.test(origin) || LAN_ORIGIN.test(origin) || PAGES_DEV_ORIGIN.test(origin);
}

/**
 * App Check より前に登録し、OPTIONS preflight を short-circuit する。
 *
 * @doc doc/specs/workers-api-server.md#リクエスト処理順序
 */
export function createCorsMiddleware(): MiddlewareHandler {
  return cors({
    origin: (origin) => (isAllowedWebQaOrigin(origin) ? origin : null),
    allowHeaders: [
      "Authorization",
      "Content-Type",
      "X-Firebase-AppCheck",
      "If-None-Match",
      "If-Modified-Since",
    ],
    allowMethods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    exposeHeaders: ["X-Request-ID", "ETag", "Cache-Control", "X-Content-Type-Options"],
    maxAge: 86400,
  });
}
