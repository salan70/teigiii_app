import { z } from "@hono/zod-openapi";
import { isoDateTime } from "./common";

/** 端末・ビルドの識別情報。個人を特定しうる値は含めない。 */
export const frameStatsDeviceSchema = z
  .object({
    appVersion: z.string().min(1).max(32).openapi({ example: "2.3.0" }),
    buildNumber: z.number().int().min(0).openapi({ example: 128 }),
    flavor: z.enum(["dev", "prod"]),
    platform: z.enum(["ios", "android", "web"]),
    osVersion: z.string().min(1).max(64).openapi({ example: "iOS 26.0" }),
    deviceModel: z.string().min(1).max(64).openapi({ example: "iPhone17,1" }),
    refreshRateHz: z.number().int().min(1).max(480).openapi({ example: 120 }),
  })
  .openapi("FrameStatsDevice");

const counter = z.number().int().min(0);

/** 1 画面ぶんの集計。生フレームもパーセンタイルも送らない。 */
export const frameStatsScreenSchema = z
  .object({
    screenName: z.string().min(1).max(100).openapi({ example: "DiscoverTimelinePage" }),
    recordedAt: isoDateTime,
    frameCount: z.number().int().min(1),
    slowBuildCount: counter,
    slowRasterCount: counter,
    frozenCount: counter,
    sumBuildUs: counter,
    sumRasterUs: counter,
    maxBuildUs: counter,
    maxRasterUs: counter,
  })
  .refine(
    (screen) =>
      screen.slowBuildCount <= screen.frameCount &&
      screen.slowRasterCount <= screen.frameCount &&
      screen.frozenCount <= screen.frameCount,
    { error: "counts must not exceed frameCount" },
  )
  .openapi("FrameStatsScreen");

export const frameStatsRequestSchema = z
  .object({
    sessionId: z
      .string()
      .min(1)
      .max(64)
      .openapi({ example: "0198f1f0-0000-7000-8000-000000000000" }),
    device: frameStatsDeviceSchema,
    screens: z.array(frameStatsScreenSchema).min(1).max(50),
  })
  .openapi("FrameStatsRequest");

export const frameStatsAcceptedResponseSchema = z
  .object({
    /** 実際に保存した画面数。kill switch が false のときは 0。 */
    accepted: z.number().int().min(0),
    /** サーバー側 kill switch により破棄したかどうか。 */
    disabled: z.boolean(),
  })
  .openapi("FrameStatsAcceptedResponse");

export type FrameStatsRequest = z.infer<typeof frameStatsRequestSchema>;
