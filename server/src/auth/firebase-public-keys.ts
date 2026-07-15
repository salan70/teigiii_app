import { importX509, type JWTVerifyGetKey } from "jose";

export const firebasePublicKeysUrl =
  "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com";

type FirebasePublicKeyProviderOptions = {
  fetcher?: Fetcher;
  importCertificate?: (certificate: string) => Promise<CryptoKey>;
  now?: () => Date;
};

type Fetcher = (
  input: Parameters<typeof fetch>[0],
  init?: Parameters<typeof fetch>[1],
) => Promise<Response>;

const fallbackMaxAgeSeconds = 300;

function cacheMaxAgeSeconds(cacheControl: string | null): number {
  const match = cacheControl?.match(/(?:^|,)\s*max-age\s*=\s*(\d+)/i);
  return match ? Number(match[1]) : fallbackMaxAgeSeconds;
}

/**
 * @doc doc/specs/workers-api-server.md#公開鍵キャッシュ
 */
export class FirebasePublicKeyProvider {
  readonly #fetcher: Fetcher;
  readonly #importCertificate: (certificate: string) => Promise<CryptoKey>;
  readonly #now: () => Date;
  #expiresAt = 0;
  #keys = new Map<string, CryptoKey>();
  #refreshPromise: Promise<void> | undefined;

  constructor({
    fetcher = (input, init) => fetch(input, init),
    importCertificate = (certificate) => importX509(certificate, "RS256"),
    now = () => new Date(),
  }: FirebasePublicKeyProviderOptions = {}) {
    this.#fetcher = fetcher;
    this.#importCertificate = importCertificate;
    this.#now = now;
  }

  readonly getKey: JWTVerifyGetKey = async (protectedHeader) => {
    const kid = protectedHeader.kid;
    if (typeof kid !== "string" || kid.length === 0) {
      throw new Error("missing_firebase_key_id");
    }

    const cached = this.#keys.get(kid);
    if (cached && this.#now().getTime() < this.#expiresAt) {
      return cached;
    }

    await this.#refresh();
    const refreshed = this.#keys.get(kid);
    if (!refreshed) {
      throw new Error("unknown_firebase_key_id");
    }
    return refreshed;
  };

  async #refresh(): Promise<void> {
    if (this.#refreshPromise) {
      return this.#refreshPromise;
    }

    this.#refreshPromise = this.#fetchAndImport();
    try {
      await this.#refreshPromise;
    } finally {
      this.#refreshPromise = undefined;
    }
  }

  async #fetchAndImport(): Promise<void> {
    const response = await this.#fetcher(firebasePublicKeysUrl);
    if (!response.ok) {
      throw new Error(`firebase_public_keys_fetch_failed:${response.status}`);
    }

    const certificates = (await response.json()) as Record<string, unknown>;
    const imported = new Map<string, CryptoKey>();
    for (const [kid, certificate] of Object.entries(certificates)) {
      if (typeof certificate !== "string") {
        throw new Error("invalid_firebase_public_keys_response");
      }
      imported.set(kid, await this.#importCertificate(certificate));
    }

    this.#keys = imported;
    this.#expiresAt =
      this.#now().getTime() + cacheMaxAgeSeconds(response.headers.get("Cache-Control")) * 1000;
  }
}
