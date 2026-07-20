import { OpenAPIHono, createRoute } from "@hono/zod-openapi";
import { AppConfigService } from "../config/app-config-service";
import { appConfigResponseSchema } from "../schemas/app-config";
import { appCheckOnlySecurity, errorContent, jsonContent } from "./helpers";

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
    500: errorContent("アプリ設定が未初期化"),
  },
});

type AppConfigRouteEnvironment = {
  Bindings: { DB: D1Database };
};

export const appConfigRoutes = new OpenAPIHono<AppConfigRouteEnvironment>().openapi(
  getAppConfigRoute,
  async (context) => context.json(await new AppConfigService(context.env.DB).get(), 200),
);
