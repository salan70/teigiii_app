import { applyD1Migrations, env } from "cloudflare:test";
import { beforeEach, describe, expect, test } from "vitest";

import { createApp } from "../src/app";

const app = createApp({
  logRequest: () => {},
  verifyAppCheck: async () => ({ appId: "test-app-id" }),
});

beforeEach(async () => {
  await applyD1Migrations(env.DB, env.TEST_MIGRATIONS);
  await env.DB.prepare("delete from app_config").run();
});

describe("app config route", () => {
  test("D1の単一行をISO 8601日時へ変換して返す", async () => {
    await env.DB.prepare(
      `insert into app_config
         (id, min_app_version_ios, min_app_version_android, in_maintenance,
          maintenance_scheduled_end_time, perf_telemetry_enabled, updated_at)
       values (1, '2.0.0', '2.1.0', 1, ?, 0, ?)`,
    )
      .bind(Date.parse("2026-07-16T12:00:00.000Z"), Date.parse("2026-07-16T00:00:00.000Z"))
      .run();

    const response = await app.request(
      "/v1/app-config",
      { headers: { "X-Firebase-AppCheck": "valid-app-check" } },
      env,
    );

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toEqual({
      inMaintenance: true,
      maintenanceScheduledEndTime: "2026-07-16T12:00:00.000Z",
      minAppVersionAndroid: "2.1.0",
      minAppVersionIos: "2.0.0",
      perfTelemetryEnabled: false,
      updatedAt: "2026-07-16T00:00:00.000Z",
    });
  });
});
