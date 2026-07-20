import { SELF } from "cloudflare:test";
import { SignJWT, generateKeyPair } from "jose";
import { describe, expect, test } from "vitest";

import { FirebaseIdTokenVerifier } from "../src/auth/firebase-id-token";

describe("Workers runtime", () => {
  test("App Check がないリクエストを workerd 上でも拒否する", async () => {
    const response = await SELF.fetch("https://example.com/v1/app-config");

    expect(response.status).toBe(401);
    await expect(response.json()).resolves.toEqual({
      error: { code: "app_check_invalid", message: "Unauthorized" },
    });
  });

  test("Web Crypto と jose で Firebase ID トークンを検証できる", async () => {
    const now = new Date("2026-07-15T00:00:00.000Z");
    const nowSeconds = Math.floor(now.getTime() / 1000);
    const { privateKey, publicKey } = await generateKeyPair("RS256");
    const token = await new SignJWT({})
      .setProtectedHeader({ alg: "RS256", kid: "test-key" })
      .setIssuer("https://securetoken.google.com/test-project")
      .setAudience("test-project")
      .setSubject("firebase-uid")
      .setIssuedAt(nowSeconds - 60)
      .setExpirationTime(nowSeconds + 3600)
      .sign(privateKey);
    const verifier = new FirebaseIdTokenVerifier({
      getKey: async () => publicKey,
      now: () => now,
      projectId: "test-project",
    });

    await expect(verifier.verify(token)).resolves.toEqual({ uid: "firebase-uid" });
  });
});
