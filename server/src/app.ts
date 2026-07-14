import { OpenAPIHono } from "@hono/zod-openapi";
import { appConfigRoutes } from "./routes/app-config";
import { definitionRoutes } from "./routes/definitions";
import { meRoutes } from "./routes/me";
import { searchRoutes } from "./routes/search";
import { timelineRoutes } from "./routes/timeline";
import { userRoutes } from "./routes/users";
import { wordRoutes } from "./routes/words";

export type Env = {
  DB: D1Database;
};

const v1 = new OpenAPIHono<{ Bindings: Env }>()
  .route("/", appConfigRoutes)
  .route("/", userRoutes)
  .route("/", meRoutes)
  .route("/", wordRoutes)
  .route("/", definitionRoutes)
  .route("/", timelineRoutes)
  .route("/", searchRoutes);

export const app = new OpenAPIHono<{ Bindings: Env }>().route("/v1", v1);

app.openAPIRegistry.registerComponent("securitySchemes", "firebaseIdToken", {
  type: "http",
  scheme: "bearer",
  bearerFormat: "JWT",
  description: "Firebase Auth の ID トークン。GET /v1/app-config 以外の全エンドポイントで必須。",
});

app.openAPIRegistry.registerComponent("securitySchemes", "appCheck", {
  type: "apiKey",
  in: "header",
  name: "X-Firebase-AppCheck",
  description: "Firebase App Check トークン。全エンドポイントで必須。",
});

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
