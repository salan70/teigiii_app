import { decodeProtectedHeader, jwtVerify, type JWTVerifyGetKey } from "jose";

export type AppCheckIdentity = {
  appId: string;
};

type AppCheckTokenVerifierOptions = {
  getKey: JWTVerifyGetKey;
  now?: () => Date;
  projectNumber: string;
};

/**
 * @doc doc/specs/workers-api-server.md#app-check
 */
export class AppCheckTokenVerifier {
  readonly #getKey: JWTVerifyGetKey;
  readonly #now: () => Date;
  readonly #projectNumber: string;

  constructor({ getKey, now = () => new Date(), projectNumber }: AppCheckTokenVerifierOptions) {
    this.#getKey = getKey;
    this.#now = now;
    this.#projectNumber = projectNumber;
  }

  async verify(token: string): Promise<AppCheckIdentity> {
    const header = decodeProtectedHeader(token);
    if (
      header.alg !== "RS256" ||
      header.typ !== "JWT" ||
      typeof header.kid !== "string" ||
      header.kid.length === 0
    ) {
      throw new Error("invalid_app_check_token_header");
    }

    const { payload } = await jwtVerify(token, this.#getKey, {
      algorithms: ["RS256"],
      audience: `projects/${this.#projectNumber}`,
      currentDate: this.#now(),
      issuer: `https://firebaseappcheck.googleapis.com/${this.#projectNumber}`,
      typ: "JWT",
    });

    if (typeof payload.sub !== "string" || payload.sub.length === 0) {
      throw new Error("invalid_app_check_token_sub");
    }

    return { appId: payload.sub };
  }
}
