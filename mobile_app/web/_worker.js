import { evaluateBasicAuth } from "./_lib/basic-auth.js";
import { shouldSkipBasicAuth } from "./_lib/basic-auth-paths.js";

/**
 * Web QA プレビュー（Cloudflare Pages）専用の Basic 認証。
 * native / Workers API / prod には適用しない。
 *
 * Pages Advanced mode: build/web/_worker.js として Direct Upload される。
 *
 * Basic 認証は必須。匿名 Auth があるため、URL を開ける人は共有 dev DB に書き込めてしまう。
 * APP_CHECK_DEBUG_TOKEN はビルド成果物に焼き込まれるので、パスワードが漏れたら token も失効・再発行する。
 * 必要な値: FIREBASE_WEB_API_KEY、FIREBASE_WEB_APP_ID、APP_CHECK_DEBUG_TOKEN、
 * WEB_PREVIEW_BASIC_AUTH_USER、WEB_PREVIEW_BASIC_AUTH_PASSWORD。
 * exchangeDebugToken が 403 のときは、debug token の未登録か、Web API key の referrer 制限に *.pages.dev が無いことを疑う。
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
