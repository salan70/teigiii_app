import { describe, expect, test } from "bun:test";

import { createApp } from "../src/app";
import { isAllowedWebQaOrigin } from "../src/middleware/cors";

const WEB_QA_ENV = { WEB_QA_PAGES_PROJECT: "teigiii-web-dev" };
const PROD_ENV = {};

function testApp() {
  return createApp({
    verifyAppCheck: async () => ({ appId: "test-app-id" }),
    verifyFirebaseIdToken: async () => ({ uid: "firebase-uid" }),
  });
}

describe("isAllowedWebQaOrigin", () => {
  test("pagesProject 未設定ではすべて拒否する", () => {
    expect(isAllowedWebQaOrigin("http://localhost:3000", undefined)).toBe(false);
    expect(isAllowedWebQaOrigin("https://teigiii-web-dev.pages.dev", undefined)).toBe(false);
  });

  test("localhost / 127.0.0.1 を許可する", () => {
    expect(isAllowedWebQaOrigin("http://localhost:3000", "teigiii-web-dev")).toBe(true);
    expect(isAllowedWebQaOrigin("http://127.0.0.1:8080", "teigiii-web-dev")).toBe(true);
  });

  test("LAN IP を許可する", () => {
    expect(isAllowedWebQaOrigin("http://192.168.1.10:5173", "teigiii-web-dev")).toBe(true);
    expect(isAllowedWebQaOrigin("http://10.0.0.5:3000", "teigiii-web-dev")).toBe(true);
    expect(isAllowedWebQaOrigin("http://172.16.0.2:4173", "teigiii-web-dev")).toBe(true);
  });

  test("自プロジェクトの *.pages.dev だけ許可する", () => {
    expect(isAllowedWebQaOrigin("https://teigiii-web-dev.pages.dev", "teigiii-web-dev")).toBe(true);
    expect(
      isAllowedWebQaOrigin("https://abc123.teigiii-web-dev.pages.dev", "teigiii-web-dev"),
    ).toBe(true);
    expect(isAllowedWebQaOrigin("https://other-project.pages.dev", "teigiii-web-dev")).toBe(false);
    expect(isAllowedWebQaOrigin("https://evil.pages.dev", "teigiii-web-dev")).toBe(false);
  });

  test("無関係な origin を拒否する", () => {
    expect(isAllowedWebQaOrigin("https://evil.example.com", "teigiii-web-dev")).toBe(false);
    expect(isAllowedWebQaOrigin("https://pages.dev.evil.com", "teigiii-web-dev")).toBe(false);
    expect(isAllowedWebQaOrigin("", "teigiii-web-dev")).toBe(false);
  });
});

describe("CORS middleware (createApp)", () => {
  test("許可 origin の OPTIONS preflight を App Check なしで通す", async () => {
    const response = await testApp().request(
      "/v1/app-config",
      {
        method: "OPTIONS",
        headers: {
          Origin: "https://teigiii-web-dev.pages.dev",
          "Access-Control-Request-Method": "GET",
          "Access-Control-Request-Headers": "x-firebase-appcheck,authorization",
        },
      },
      WEB_QA_ENV,
    );

    expect(response.status).toBe(204);
    expect(response.headers.get("Access-Control-Allow-Origin")).toBe(
      "https://teigiii-web-dev.pages.dev",
    );
  });

  test("許可 origin の通常リクエストに CORS ヘッダーを付ける", async () => {
    const response = await testApp().request(
      "/v1/app-config",
      {
        headers: {
          Origin: "http://localhost:5173",
          "X-Firebase-AppCheck": "any",
        },
      },
      WEB_QA_ENV,
    );

    expect(response.headers.get("Access-Control-Allow-Origin")).toBe("http://localhost:5173");
  });

  test("拒否 origin には Access-Control-Allow-Origin を付けない", async () => {
    const response = await testApp().request(
      "/v1/app-config",
      {
        method: "OPTIONS",
        headers: {
          Origin: "https://evil.example.com",
          "Access-Control-Request-Method": "GET",
        },
      },
      WEB_QA_ENV,
    );

    expect(response.headers.get("Access-Control-Allow-Origin")).toBeNull();
  });

  test("WEB_QA_PAGES_PROJECT 未設定（prod）では許可 origin も付けない", async () => {
    const response = await testApp().request(
      "/v1/app-config",
      {
        method: "OPTIONS",
        headers: {
          Origin: "https://teigiii-web-dev.pages.dev",
          "Access-Control-Request-Method": "GET",
        },
      },
      PROD_ENV,
    );

    expect(response.headers.get("Access-Control-Allow-Origin")).toBeNull();
  });
});
