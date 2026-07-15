import { describe, expect, test } from "bun:test";

import { FirebasePublicKeyProvider } from "../../src/auth/firebase-public-keys";

const key1 = { algorithm: { name: "RSASSA-PKCS1-v1_5" } } as CryptoKey;
const key2 = { algorithm: { name: "RSASSA-PKCS1-v1_5" } } as CryptoKey;

function certificateResponse(certificates: Record<string, string>, maxAge = 60) {
  return new Response(JSON.stringify(certificates), {
    headers: { "Cache-Control": `public, max-age=${maxAge}, must-revalidate` },
  });
}

function resolve(provider: FirebasePublicKeyProvider, kid: string) {
  return provider.getKey({ alg: "RS256", kid }, {} as never);
}

describe("FirebasePublicKeyProvider", () => {
  test("Firebase 公開鍵 provider を公開する", async () => {
    const modulePromise = import("../../src/auth/firebase-public-keys");

    await expect(modulePromise).resolves.toHaveProperty("FirebasePublicKeyProvider");
  });

  test("max-age の期限内は取得済みの鍵を再利用し、期限後に更新する", async () => {
    let fetchCount = 0;
    let now = new Date("2026-07-15T00:00:00.000Z");
    const provider = new FirebasePublicKeyProvider({
      fetcher: async () => {
        fetchCount++;
        return certificateResponse({ "kid-1": "certificate-1" });
      },
      importCertificate: async () => key1,
      now: () => now,
    });

    await expect(resolve(provider, "kid-1")).resolves.toBe(key1);
    await expect(resolve(provider, "kid-1")).resolves.toBe(key1);
    expect(fetchCount).toBe(1);

    now = new Date("2026-07-15T00:01:01.000Z");
    await expect(resolve(provider, "kid-1")).resolves.toBe(key1);
    expect(fetchCount).toBe(2);
  });

  test("未知の kid では期限内でも公開鍵を再取得してローテーションへ追従する", async () => {
    let fetchCount = 0;
    const provider = new FirebasePublicKeyProvider({
      fetcher: async () => {
        fetchCount++;
        return fetchCount === 1
          ? certificateResponse({ "kid-1": "certificate-1" })
          : certificateResponse({ "kid-2": "certificate-2" });
      },
      importCertificate: async (certificate) => (certificate === "certificate-1" ? key1 : key2),
    });

    await expect(resolve(provider, "kid-1")).resolves.toBe(key1);
    await expect(resolve(provider, "kid-2")).resolves.toBe(key2);
    expect(fetchCount).toBe(2);
  });

  test("同時リクエストの公開鍵取得を1回にまとめる", async () => {
    let fetchCount = 0;
    const provider = new FirebasePublicKeyProvider({
      fetcher: async () => {
        fetchCount++;
        await Promise.resolve();
        return certificateResponse({ "kid-1": "certificate-1" });
      },
      importCertificate: async () => key1,
    });

    await Promise.all([resolve(provider, "kid-1"), resolve(provider, "kid-1")]);
    expect(fetchCount).toBe(1);
  });

  test("再取得後も kid が存在しない場合は拒否する", async () => {
    const provider = new FirebasePublicKeyProvider({
      fetcher: async () => certificateResponse({ "kid-1": "certificate-1" }),
      importCertificate: async () => key1,
    });

    await expect(resolve(provider, "missing-kid")).rejects.toThrow("unknown_firebase_key_id");
  });
});
