import { describe, expect, test } from "bun:test";
import { SignJWT, generateKeyPair } from "jose";

import { AppCheckTokenVerifier } from "../../src/auth/app-check";

const projectNumber = "123456789012";
const now = new Date("2026-07-15T00:00:00.000Z");

async function createToken(
  overrides: {
    audience?: string;
    expiresAt?: number;
    issuer?: string;
    subject?: string;
  } = {},
) {
  const { privateKey, publicKey } = await generateKeyPair("RS256");
  const nowSeconds = Math.floor(now.getTime() / 1000);
  const token = await new SignJWT({})
    .setProtectedHeader({ alg: "RS256", kid: "app-check-key", typ: "JWT" })
    .setIssuer(overrides.issuer ?? `https://firebaseappcheck.googleapis.com/${projectNumber}`)
    .setAudience(overrides.audience ?? `projects/${projectNumber}`)
    .setSubject(overrides.subject ?? "1:123456789012:ios:test-app")
    .setIssuedAt(nowSeconds - 60)
    .setExpirationTime(overrides.expiresAt ?? nowSeconds + 3600)
    .sign(privateKey);

  return { publicKey, token };
}

describe("AppCheckTokenVerifier", () => {
  test("App Check トークン検証器を公開する", async () => {
    const modulePromise = import("../../src/auth/app-check");

    await expect(modulePromise).resolves.toHaveProperty("AppCheckTokenVerifier");
  });

  test("正しい署名と必須 claim を持つトークンから appId を返す", async () => {
    const { publicKey, token } = await createToken();
    const verifier = new AppCheckTokenVerifier({
      getKey: async () => publicKey,
      now: () => now,
      projectNumber,
    });

    await expect(verifier.verify(token)).resolves.toEqual({
      appId: "1:123456789012:ios:test-app",
    });
  });

  test.each([
    ["aud", { audience: "projects/999999999999" }],
    ["iss", { issuer: "https://firebaseappcheck.googleapis.com/999999999999" }],
    ["sub", { subject: "" }],
    ["exp", { expiresAt: Math.floor(now.getTime() / 1000) - 1 }],
  ] as const)("不正な %s claim を拒否する", async (_claim, overrides) => {
    const { publicKey, token } = await createToken(overrides);
    const verifier = new AppCheckTokenVerifier({
      getKey: async () => publicKey,
      now: () => now,
      projectNumber,
    });

    await expect(verifier.verify(token)).rejects.toThrow();
  });

  test("typ=JWT でないトークンを拒否する", async () => {
    const { privateKey, publicKey } = await generateKeyPair("RS256");
    const nowSeconds = Math.floor(now.getTime() / 1000);
    const token = await new SignJWT({})
      .setProtectedHeader({ alg: "RS256", kid: "app-check-key" })
      .setIssuer(`https://firebaseappcheck.googleapis.com/${projectNumber}`)
      .setAudience(`projects/${projectNumber}`)
      .setSubject("1:123456789012:ios:test-app")
      .setIssuedAt(nowSeconds - 60)
      .setExpirationTime(nowSeconds + 3600)
      .sign(privateKey);
    const verifier = new AppCheckTokenVerifier({
      getKey: async () => publicKey,
      now: () => now,
      projectNumber,
    });

    await expect(verifier.verify(token)).rejects.toThrow();
  });

  test("RS256 以外の署名アルゴリズムを拒否する", async () => {
    const { privateKey, publicKey } = await generateKeyPair("ES256");
    const nowSeconds = Math.floor(now.getTime() / 1000);
    const token = await new SignJWT({})
      .setProtectedHeader({ alg: "ES256", kid: "app-check-key", typ: "JWT" })
      .setIssuer(`https://firebaseappcheck.googleapis.com/${projectNumber}`)
      .setAudience(`projects/${projectNumber}`)
      .setSubject("1:123456789012:ios:test-app")
      .setIssuedAt(nowSeconds - 60)
      .setExpirationTime(nowSeconds + 3600)
      .sign(privateKey);
    const verifier = new AppCheckTokenVerifier({
      getKey: async () => publicKey,
      now: () => now,
      projectNumber,
    });

    await expect(verifier.verify(token)).rejects.toThrow();
  });
});
