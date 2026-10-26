import { decodeProtectedHeader, jwtVerify, type JWTVerifyGetKey } from "jose";

export type FirebaseIdentity = {
  uid: string;
  authTime?: number;
  signInProvider?: string;
};

type FirebaseIdTokenVerifierOptions = {
  getKey: JWTVerifyGetKey;
  now?: () => Date;
  projectId: string;
};

/**
 * @doc doc/specs/workers-api-server.md#firebase-id-トークン
 */
export class FirebaseIdTokenVerifier {
  readonly #getKey: JWTVerifyGetKey;
  readonly #now: () => Date;
  readonly #projectId: string;

  constructor({ getKey, now = () => new Date(), projectId }: FirebaseIdTokenVerifierOptions) {
    this.#getKey = getKey;
    this.#now = now;
    this.#projectId = projectId;
  }

  async verify(token: string): Promise<FirebaseIdentity> {
    const header = decodeProtectedHeader(token);
    if (header.alg !== "RS256" || typeof header.kid !== "string" || header.kid.length === 0) {
      throw new Error("invalid_firebase_id_token_header");
    }

    const currentDate = this.#now();
    const { payload } = await jwtVerify(token, this.#getKey, {
      algorithms: ["RS256"],
      audience: this.#projectId,
      currentDate,
      issuer: `https://securetoken.google.com/${this.#projectId}`,
    });

    const nowSeconds = Math.floor(currentDate.getTime() / 1000);
    if (typeof payload.iat !== "number" || payload.iat > nowSeconds) {
      throw new Error("invalid_firebase_id_token_iat");
    }
    if (typeof payload.sub !== "string" || payload.sub.length === 0) {
      throw new Error("invalid_firebase_id_token_sub");
    }

    const identity: FirebaseIdentity = { uid: payload.sub };
    if (payload.auth_time !== undefined) {
      if (
        typeof payload.auth_time !== "number" ||
        !Number.isInteger(payload.auth_time) ||
        payload.auth_time < 0 ||
        payload.auth_time > nowSeconds
      ) {
        throw new Error("invalid_firebase_id_token_auth_time");
      }
      identity.authTime = payload.auth_time;
    }
    const firebase = payload.firebase;
    if (typeof firebase === "object" && firebase !== null && !Array.isArray(firebase)) {
      const provider = (firebase as Record<string, unknown>).sign_in_provider;
      if (typeof provider === "string" && provider.length > 0) identity.signInProvider = provider;
    }
    return identity;
  }
}
