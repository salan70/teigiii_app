import { evaluateBasicAuth } from "./_lib/basic-auth.js";
import { shouldSkipBasicAuth } from "./_lib/basic-auth-paths.js";

/**
 * Web QA プレビュー（Cloudflare Pages）専用の Basic 認証。
 * native / Workers API / prod には適用しない。
 *
 * Pages Advanced mode: build/web/_worker.js として Direct Upload される。
 */
export default {
  /**
   * @param {Request} request
   * @param {{
   *   ASSETS: { fetch: (request: Request) => Promise<Response> },
   *   WEB_PREVIEW_BASIC_AUTH_USER?: string,
   *   WEB_PREVIEW_BASIC_AUTH_PASSWORD?: string,
   * }} env
   */
  async fetch(request, env) {
    const pathname = new URL(request.url).pathname;
    if (shouldSkipBasicAuth(pathname)) {
      return env.ASSETS.fetch(request);
    }

    const result = evaluateBasicAuth(
      request.headers.get("Authorization"),
      env.WEB_PREVIEW_BASIC_AUTH_USER,
      env.WEB_PREVIEW_BASIC_AUTH_PASSWORD,
    );

    if (result === "missing_config") {
      return new Response("Web preview Basic Auth is not configured", {
        status: 500,
      });
    }

    if (result === "unauthorized") {
      return new Response("Unauthorized", {
        status: 401,
        headers: {
          "WWW-Authenticate": 'Basic realm="Teigiii Web QA Preview"',
          "Cache-Control": "no-store",
        },
      });
    }

    return env.ASSETS.fetch(request);
  },
};
