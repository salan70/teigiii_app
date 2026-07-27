import { OpenAPIHono, createRoute } from "@hono/zod-openapi";
import { AppConfigService } from "../config/app-config-service";
import { frameStatsAcceptedResponseSchema, frameStatsRequestSchema } from "../schemas/telemetry";
import { FrameStatsService } from "../telemetry/frame-stats-service";
import { appCheckOnlySecurity, errorContent, jsonContent } from "./helpers";

const postFrameStatsRoute = createRoute({
  method: "post",
  path: "/telemetry/frames",
  tags: ["telemetry"],
  summary: "フレーム計測の集計を送信",
  description:
    "セッション単位で画面ごとに集計したフレーム統計を受け取る。Firebase ID トークン不要（App Check は必須）。app_config.perfTelemetryEnabled が false のときは 1 行も保存せず accepted=0 / disabled=true を返す。",
  security: appCheckOnlySecurity,
  request: {
    body: jsonContent(frameStatsRequestSchema, "セッション単位のフレーム計測集計"),
  },
  responses: {
    202: jsonContent(frameStatsAcceptedResponseSchema, "受理（保存済み）または kill switch で破棄"),
    400: errorContent("リクエストボディが不正"),
    401: errorContent("App Check トークンが欠落・無効"),
  },
});

type TelemetryRouteEnvironment = {
  Bindings: { DB: D1Database; TELEMETRY_DB: D1Database };
};

export const telemetryRoutes = new OpenAPIHono<TelemetryRouteEnvironment>().openapi(
  postFrameStatsRoute,
  async (context) => {
    if (!(await new AppConfigService(context.env.DB).isPerfTelemetryEnabled())) {
      return context.json({ accepted: 0, disabled: true }, 202);
    }

    const accepted = await new FrameStatsService(context.env.TELEMETRY_DB).record(
      context.req.valid("json"),
    );
    return context.json({ accepted, disabled: false }, 202);
  },
);
