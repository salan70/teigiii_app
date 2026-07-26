import { cors } from "hono/cors";
import type { MiddlewareHandler } from "hono";

const LOCALHOST_ORIGIN = /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/i;
const LAN_ORIGIN =
  /^https?:\/\/((192\.168\.\d{1,3}\.\d{1,3})|(10\.\d{1,3}\.\d{1,3}\.\d{1,3})|(172\.(1[6-9]|2\d|3[0-1])\.\d{1,3}\.\d{1,3}))(:\d+)?$/i;

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

/**
 * Web QA プレビュー（localhost / LAN / 自プロジェクトの Cloudflare Pages）からの
 * ブラウザアクセスを許可する origin 判定。
 *
 * `pagesProject` が未設定（prod 等）のときはすべて拒否する。
 */
export function isAllowedWebQaOrigin(
  origin: string,
  pagesProject: string | undefined,
): boolean {
  if (!origin || !pagesProject) return false;
  if (LOCALHOST_ORIGIN.test(origin) || LAN_ORIGIN.test(origin)) return true;

  const pagesDevOrigin = new RegExp(
    `^https:\\/\\/([a-z0-9-]+\\.)?${escapeRegExp(pagesProject)}\\.pages\\.dev$`,
    "i",
  );
  return pagesDevOrigin.test(origin);
}

/**
 * App Check より前に登録し、OPTIONS preflight を short-circuit する。
 *
 * Web QA 緩和は `WEB_QA_PAGES_PROJECT` が設定されている環境（local / dev）のみ有効。
 * prod では binding を置かず allowlist を空にする。
 *
 * @doc doc/specs/workers-api-server.md#cors-web-qa
 */
export function createCorsMiddleware(): MiddlewareHandler {
  return (c, next) => {
    const pagesProject = (c.env as { WEB_QA_PAGES_PROJECT?: string } | undefined)
      ?.WEB_QA_PAGES_PROJECT;

    return cors({
      origin: (origin) =>
        isAllowedWebQaOrigin(origin, pagesProject) ? origin : null,
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
    })(c, next);
  };
}
