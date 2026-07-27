import { z } from "@hono/zod-openapi";
import { isoDateTime } from "./common";

export const appConfigResponseSchema = z
  .object({
    minAppVersionIos: z.string().openapi({ example: "2.0.0" }),
    minAppVersionAndroid: z.string().openapi({ example: "2.0.0" }),
    inMaintenance: z.boolean(),
    maintenanceScheduledEndTime: isoDateTime.nullable(),
    /** フレーム計測テレメトリの kill switch。false ならクライアントは送信を止める（サーバー側でも受信を拒否する）。 */
    perfTelemetryEnabled: z.boolean(),
    updatedAt: isoDateTime,
  })
  .openapi("AppConfigResponse");
