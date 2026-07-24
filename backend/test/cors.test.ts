import { describe, expect, test } from "bun:test";

import { createApp } from "../src/app";
import { isAllowedWebQaOrigin } from "../src/middleware/cors";

function testApp() {
  return createApp({
    verifyAppCheck: async () => ({ appId: "test-app-id" }),
    verifyFirebaseIdToken: async () => ({ uid: "firebase-uid" }),
  });
}

describe("isAllowedWebQaOrigin", () => {
  test("localhost / 127.0.0.1 を許可する", () => {
    expect(isAllowedWebQaOrigin("http://localhost:3000")).toBe(true);
    expect(isAllowedWebQaOrigin("http://127.0.0.1:8080")).toBe(true);
  });

  test("LAN IP を許可する", () => {
    expect(isAllowedWebQaOrigin("http://192.168.1.10:5173")).toBe(true);
    expect(isAllowedWebQaOrigin("http://10.0.0.5:3000")).toBe(true);
    expect(isAllowedWebQaOrigin("http://172.16.0.2:4173")).toBe(true);
  });

  test("*.pages.dev を許可する", () => {
    expect(isAllowedWebQaOrigin("https://teigiii-web-dev.pages.dev")).toBe(true);
    expect(isAllowedWebQaOrigin("https://abc123.teigiii-web-dev.pages.dev")).toBe(true);
  });

  test("無関係な origin を拒否する", () => {
    expect(isAllowedWebQaOrigin("https://evil.example.com")).toBe(false);
    expect(isAllowedWebQaOrigin("https://pages.dev.evil.com")).toBe(false);
    expect(isAllowedWebQaOrigin("")).toBe(false);
  });
});

describe("CORS middleware (createApp)", () => {
  test("許可 origin の OPTIONS preflight を App Check なしで通す", async () => {
    const response = await testApp().request("/v1/app-config", {
      method: "OPTIONS",
      headers: {
        Origin: "https://teigiii-web-dev.pages.dev",
        "Access-Control-Request-Method": "GET",
        "Access-Control-Request-Headers": "x-firebase-appcheck,authorization",
      },
    });

    expect(response.status).toBe(204);
    expect(response.headers.get("Access-Control-Allow-Origin")).toBe(
      "https://teigiii-web-dev.pages.dev",
    );
  });

  test("許可 origin の通常リクエストに CORS ヘッダーを付ける", async () => {
    const response = await testApp().request("/v1/app-config", {
      headers: {
        Origin: "http://localhost:5173",
        "X-Firebase-AppCheck": "any",
      },
    });

    expect(response.headers.get("Access-Control-Allow-Origin")).toBe("http://localhost:5173");
  });

  test("拒否 origin には Access-Control-Allow-Origin を付けない", async () => {
    const response = await testApp().request("/v1/app-config", {
      method: "OPTIONS",
      headers: {
        Origin: "https://evil.example.com",
        "Access-Control-Request-Method": "GET",
      },
    });

    expect(response.headers.get("Access-Control-Allow-Origin")).toBeNull();
  });
});
