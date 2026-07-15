import { OpenAPIHono, createRoute } from "@hono/zod-openapi";
import { appConfigResponseSchema } from "../schemas/app-config";
import { appCheckOnlySecurity, errorContent, jsonContent, notImplemented } from "./helpers";

const getAppConfigRoute = createRoute({
  method: "get",
  path: "/app-config",
  tags: ["appConfig"],
  summary: "アプリ設定（強制アップデート・メンテナンス）を取得",
  description: "起動時ポーリングで呼び出す。Firebase ID トークン不要（App Check は必須）。",
  security: appCheckOnlySecurity,
  responses: {
    200: jsonContent(appConfigResponseSchema, "アプリ設定"),
    401: errorContent("App Check トークンが欠落・無効"),
  },
});

export const appConfigRoutes = new OpenAPIHono().openapi(getAppConfigRoute, notImplemented);
