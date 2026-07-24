import { OpenAPIHono } from "@hono/zod-openapi";
import type { AppCheckIdentity } from "./auth/app-check";
import type { FirebaseIdentity } from "./auth/firebase-id-token";
import {
  type AuthenticationVariables,
  createAppCheckMiddleware,
  createFirebaseAuthMiddleware,
} from "./auth/middleware";
import {
  verifyAppCheckToken,
  verifyFirebaseIdToken as verifyFirebaseIdTokenWithGoogleKeys,
} from "./auth/production-verifiers";
import {
  createRequestContextMiddleware,
  type RequestContextVariables,
  type RequestLogEntry,
} from "./middleware/request-context";
import { createCorsMiddleware } from "./middleware/cors";
import { createApiErrorHandler, handleNotFound } from "./errors";
import { appConfigRoutes } from "./routes/app-config";
import { definitionRoutes } from "./routes/definitions";
import { meRoutes } from "./routes/me";
import { searchRoutes } from "./routes/search";
import { timelineRoutes } from "./routes/timeline";
import { createUserRoutes } from "./routes/users";
import { wordRoutes } from "./routes/words";

export type Env = {
  AVATARS: R2Bucket;
  AVATAR_BASE_URL: string;
  DB: D1Database;
  FIREBASE_PROJECT_ID: string;
  FIREBASE_PROJECT_NUMBER: string;
};

type ServerEnvironment = {
  Bindings: Env;
  Variables: AuthenticationVariables & RequestContextVariables;
};

type CreateAppOptions = {
  generatePublicId?: () => string;
  generateRequestId?: () => string;
  logRequest?: (entry: RequestLogEntry) => void;
  verifyAppCheck?: (token: string, env: Env) => Promise<AppCheckIdentity>;
  verifyFirebaseIdToken?: (token: string, env: Env) => Promise<FirebaseIdentity>;
};

/**
 * @doc doc/specs/workers-api-server.md#リクエスト処理順序
 */
export function createApp({
  generatePublicId,
  generateRequestId,
  logRequest,
  verifyAppCheck = (token, env) => verifyAppCheckToken(token, env.FIREBASE_PROJECT_NUMBER),
  verifyFirebaseIdToken = (token, env) =>
    verifyFirebaseIdTokenWithGoogleKeys(token, env.FIREBASE_PROJECT_ID),
}: CreateAppOptions = {}) {
  const v1 = new OpenAPIHono<ServerEnvironment>()
    .route("/", appConfigRoutes)
    .route("/", createUserRoutes(generatePublicId ? { generatePublicId } : {}))
    .route("/", meRoutes)
    .route("/", wordRoutes)
    .route("/", definitionRoutes)
    .route("/", timelineRoutes)
    .route("/", searchRoutes);

  const honoApp = new OpenAPIHono<ServerEnvironment>();
  // CORS は App Check より前。OPTIONS preflight を認証なしで short-circuit する。
  honoApp.use("*", createCorsMiddleware());
  honoApp.use(
    "*",
    createRequestContextMiddleware({
      ...(generateRequestId ? { generateRequestId } : {}),
      ...(logRequest ? { log: logRequest } : {}),
    }),
  );
  honoApp.use(
    "*",
    createAppCheckMiddleware({
      verify: (token, context) => verifyAppCheck(token, context.env as Env),
    }),
  );
  honoApp.use(
    "*",
    createFirebaseAuthMiddleware({
      verify: (token, context) => verifyFirebaseIdToken(token, context.env as Env),
    }),
  );
  honoApp.route("/v1", v1);
  honoApp.onError(createApiErrorHandler<ServerEnvironment>());
  honoApp.notFound(handleNotFound);

  honoApp.openAPIRegistry.registerComponent("securitySchemes", "firebaseIdToken", {
    type: "http",
    scheme: "bearer",
    bearerFormat: "JWT",
    description: "Firebase Auth の ID トークン。GET /v1/app-config 以外の全エンドポイントで必須。",
  });

  honoApp.openAPIRegistry.registerComponent("securitySchemes", "appCheck", {
    type: "apiKey",
    in: "header",
    name: "X-Firebase-AppCheck",
    description: "Firebase App Check トークン。全エンドポイントで必須。",
  });

  return honoApp;
}

export const app = createApp();

export function buildOpenApiDocument() {
  return app.getOpenAPIDocument({
    openapi: "3.0.3",
    info: {
      title: "teigiii API",
      version: "1.0.0",
      description:
        "teigiii の REST API。設計の詳細は doc/plans/done/2026-07-15-rdb-schema-api-design.md を参照。",
    },
  });
}
