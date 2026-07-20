import { describe, expect, test } from "bun:test";
import { SignJWT, generateKeyPair } from "jose";

import { FirebaseIdTokenVerifier } from "../../src/auth/firebase-id-token";

const projectId = "teigiii-dev";
const now = new Date("2026-07-15T00:00:00.000Z");

async function createToken(
  overrides: {
    audience?: string;
    expiresAt?: number;
    issuedAt?: number;
    issuer?: string;
    subject?: string;
  } = {},
) {
  const { privateKey, publicKey } = await generateKeyPair("RS256");
  const nowSeconds = Math.floor(now.getTime() / 1000);
  const token = await new SignJWT({})
    .setProtectedHeader({ alg: "RS256", kid: "test-key", typ: "JWT" })
    .setIssuer(overrides.issuer ?? `https://securetoken.google.com/${projectId}`)
    .setAudience(overrides.audience ?? projectId)
    .setSubject(overrides.subject ?? "firebase-uid")
    .setIssuedAt(overrides.issuedAt ?? nowSeconds - 60)
    .setExpirationTime(overrides.expiresAt ?? nowSeconds + 3600)
    .sign(privateKey);

  return { publicKey, token };
}

describe("FirebaseIdTokenVerifier", () => {
  test("Firebase ID トークン検証器を公開する", async () => {
    const modulePromise = import("../../src/auth/firebase-id-token");

    await expect(modulePromise).resolves.toHaveProperty("FirebaseIdTokenVerifier");
  });

  test("正しい署名と必須 claim を持つトークンから uid を返す", async () => {
    const { publicKey, token } = await createToken();
    const verifier = new FirebaseIdTokenVerifier({
      getKey: async () => publicKey,
      now: () => now,
      projectId,
    });

    await expect(verifier.verify(token)).resolves.toEqual({ uid: "firebase-uid" });
  });

  test.each([
    ["aud", { audience: "another-project" }],
    ["iss", { issuer: "https://securetoken.google.com/another-project" }],
    ["sub", { subject: "" }],
    ["exp", { expiresAt: Math.floor(now.getTime() / 1000) - 1 }],
    ["iat", { issuedAt: Math.floor(now.getTime() / 1000) + 1 }],
  ] as const)("不正な %s claim を拒否する", async (_claim, overrides) => {
    const { publicKey, token } = await createToken(overrides);
    const verifier = new FirebaseIdTokenVerifier({
      getKey: async () => publicKey,
      now: () => now,
      projectId,
    });

    await expect(verifier.verify(token)).rejects.toThrow();
  });

  test("RS256 以外の署名アルゴリズムを拒否する", async () => {
    const { privateKey, publicKey } = await generateKeyPair("ES256");
    const nowSeconds = Math.floor(now.getTime() / 1000);
    const token = await new SignJWT({})
      .setProtectedHeader({ alg: "ES256", kid: "test-key" })
      .setIssuer(`https://securetoken.google.com/${projectId}`)
      .setAudience(projectId)
      .setSubject("firebase-uid")
      .setIssuedAt(nowSeconds - 60)
      .setExpirationTime(nowSeconds + 3600)
      .sign(privateKey);
    const verifier = new FirebaseIdTokenVerifier({
      getKey: async () => publicKey,
      now: () => now,
      projectId,
    });

    await expect(verifier.verify(token)).rejects.toThrow();
  });

  test("kid がないトークンを拒否する", async () => {
    const { privateKey, publicKey } = await generateKeyPair("RS256");
    const nowSeconds = Math.floor(now.getTime() / 1000);
    const token = await new SignJWT({})
      .setProtectedHeader({ alg: "RS256" })
      .setIssuer(`https://securetoken.google.com/${projectId}`)
      .setAudience(projectId)
      .setSubject("firebase-uid")
      .setIssuedAt(nowSeconds - 60)
      .setExpirationTime(nowSeconds + 3600)
      .sign(privateKey);
    const verifier = new FirebaseIdTokenVerifier({
      getKey: async () => publicKey,
      now: () => now,
      projectId,
    });

    await expect(verifier.verify(token)).rejects.toThrow();
  });
});
