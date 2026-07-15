import type { Context, MiddlewareHandler } from "hono";
import type { AppCheckIdentity } from "./app-check";
import type { FirebaseIdentity } from "./firebase-id-token";

export type AuthenticationVariables = {
  appId: string;
  firebaseUid: string;
};

type AuthenticationEnvironment = {
  Variables: AuthenticationVariables;
};

type AppCheckMiddlewareOptions = {
  verify: (token: string, context: Context<AuthenticationEnvironment>) => Promise<AppCheckIdentity>;
};

type FirebaseAuthMiddlewareOptions = {
  verify: (token: string, context: Context<AuthenticationEnvironment>) => Promise<FirebaseIdentity>;
};

function unauthorized(
  context: Parameters<MiddlewareHandler>[0],
  code: "app_check_invalid" | "firebase_id_token_invalid",
) {
  return context.json({ error: { code, message: "Unauthorized" } }, 401);
}

/**
 * @doc doc/specs/workers-api-server.md#適用順序
 */
export function createAppCheckMiddleware({
  verify,
}: AppCheckMiddlewareOptions): MiddlewareHandler<AuthenticationEnvironment> {
  return async (context, next) => {
    const token = context.req.header("X-Firebase-AppCheck");
    if (!token) return unauthorized(context, "app_check_invalid");

    try {
      const identity = await verify(token, context);
      context.set("appId", identity.appId);
    } catch {
      return unauthorized(context, "app_check_invalid");
    }

    await next();
  };
}

/**
 * @doc doc/specs/workers-api-server.md#適用順序
 */
export function createFirebaseAuthMiddleware({
  verify,
}: FirebaseAuthMiddlewareOptions): MiddlewareHandler<AuthenticationEnvironment> {
  return async (context, next) => {
    if (context.req.path === "/v1/app-config") {
      await next();
      return;
    }

    const authorization = context.req.header("Authorization");
    const token = authorization?.match(/^Bearer\s+(.+)$/i)?.[1];
    if (!token) return unauthorized(context, "firebase_id_token_invalid");

    try {
      const identity = await verify(token, context);
      context.set("firebaseUid", identity.uid);
    } catch {
      return unauthorized(context, "firebase_id_token_invalid");
    }

    await next();
  };
}
