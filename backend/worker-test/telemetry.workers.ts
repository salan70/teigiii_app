import { applyD1Migrations, env } from "cloudflare:test";
import { beforeEach, describe, expect, test } from "vitest";

import { createApp } from "../src/app";
import { runTelemetryRetention } from "../src/telemetry/retention";

const app = createApp({
  logRequest: () => {},
  verifyAppCheck: async () => ({ appId: "test-app-id" }),
});

const dayMs = 24 * 60 * 60 * 1000;
const recordedAt = "2026-07-16T00:00:00.000Z";

function screen(overrides: Record<string, unknown> = {}) {
  return {
    screenName: "DiscoverTimelinePage",
    recordedAt,
    frameCount: 100,
    slowBuildCount: 3,
    slowRasterCount: 2,
    frozenCount: 1,
    sumBuildUs: 500_000,
    sumRasterUs: 700_000,
    maxBuildUs: 30_000,
    maxRasterUs: 40_000,
    ...overrides,
  };
}

function requestBody(overrides: Record<string, unknown> = {}) {
  return {
    sessionId: "0198f1f0-0000-7000-8000-000000000000",
    device: {
      appVersion: "2.3.0",
      buildNumber: 128,
      flavor: "dev",
      platform: "ios",
      osVersion: "iOS 26.0",
      deviceModel: "iPhone17,1",
      refreshRateHz: 120,
    },
    screens: [screen()],
    ...overrides,
  };
}

function postFrames(body: unknown) {
  return app.request(
    "/v1/telemetry/frames",
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Firebase-AppCheck": "valid-app-check",
      },
      body: JSON.stringify(body),
    },
    env,
  );
}

async function seedAppConfig(perfTelemetryEnabled: boolean) {
  await env.DB.prepare(
    `insert into app_config
       (id, min_app_version_ios, min_app_version_android, in_maintenance,
        maintenance_scheduled_end_time, perf_telemetry_enabled, updated_at)
     values (1, '2.0.0', '2.0.0', 0, null, ?, ?)`,
  )
    .bind(perfTelemetryEnabled ? 1 : 0, Date.parse(recordedAt))
    .run();
}

async function countFrameStats(): Promise<number> {
  const row = await env.TELEMETRY_DB.prepare("select count(*) as count from frame_stats").first<{
    count: number;
  }>();
  return row?.count ?? 0;
}

beforeEach(async () => {
  await applyD1Migrations(env.DB, env.TEST_MIGRATIONS);
  await applyD1Migrations(env.TELEMETRY_DB, env.TEST_TELEMETRY_MIGRATIONS);
  await env.DB.prepare("delete from app_config").run();
  await env.TELEMETRY_DB.prepare("delete from frame_stats").run();
});

describe("POST /v1/telemetry/frames", () => {
  test("画面ごとの集計を専用 D1 へ保存して 202 を返す", async () => {
    await seedAppConfig(true);

    const response = await postFrames(
      requestBody({ screens: [screen(), screen({ screenName: "WordDetailPage" })] }),
    );

    expect(response.status).toBe(202);
    await expect(response.json()).resolves.toEqual({ accepted: 2, disabled: false });
    const rows = await env.TELEMETRY_DB.prepare(
      "select session_id, screen_name, recorded_at, platform, flavor, build_number, frame_count, frozen_count, max_raster_us from frame_stats order by screen_name",
    ).all<Record<string, unknown>>();
    expect(rows.results).toEqual([
      {
        build_number: 128,
        flavor: "dev",
        frame_count: 100,
        frozen_count: 1,
        max_raster_us: 40_000,
        platform: "ios",
        recorded_at: Date.parse(recordedAt),
        screen_name: "DiscoverTimelinePage",
        session_id: "0198f1f0-0000-7000-8000-000000000000",
      },
      {
        build_number: 128,
        flavor: "dev",
        frame_count: 100,
        frozen_count: 1,
        max_raster_us: 40_000,
        platform: "ios",
        recorded_at: Date.parse(recordedAt),
        screen_name: "WordDetailPage",
        session_id: "0198f1f0-0000-7000-8000-000000000000",
      },
    ]);
  });

  test("kill switch が false なら1行も保存せず disabled を返す", async () => {
    await seedAppConfig(false);

    const response = await postFrames(requestBody());

    expect(response.status).toBe(202);
    await expect(response.json()).resolves.toEqual({ accepted: 0, disabled: true });
    await expect(countFrameStats()).resolves.toBe(0);
  });

  test("app_config 行がなければ受信しない", async () => {
    const response = await postFrames(requestBody());

    expect(response.status).toBe(202);
    await expect(response.json()).resolves.toEqual({ accepted: 0, disabled: true });
    await expect(countFrameStats()).resolves.toBe(0);
  });

  test("カウンタが frameCount を超えるリクエストを 400 で拒否する", async () => {
    await seedAppConfig(true);

    const response = await postFrames(
      requestBody({ screens: [screen({ frameCount: 10, slowBuildCount: 11 })] }),
    );

    expect(response.status).toBe(400);
    await expect(countFrameStats()).resolves.toBe(0);
  });

  test("screens が空のリクエストを 400 で拒否する", async () => {
    await seedAppConfig(true);

    const response = await postFrames(requestBody({ screens: [] }));

    expect(response.status).toBe(400);
    await expect(countFrameStats()).resolves.toBe(0);
  });

  test("screens が上限を超えるリクエストを 400 で拒否する", async () => {
    await seedAppConfig(true);

    const response = await postFrames({
      ...requestBody(),
      screens: Array.from({ length: 51 }, (_, index) =>
        screen({ screenName: `Screen${String(index)}` }),
      ),
    });

    expect(response.status).toBe(400);
    await expect(countFrameStats()).resolves.toBe(0);
  });

  test("ID トークンなしでも App Check だけで受理する", async () => {
    await seedAppConfig(true);

    const response = await postFrames(requestBody());

    expect(response.status).toBe(202);
  });
});

describe("telemetry retention", () => {
  test("30日より古い行だけを削除して件数を記録する", async () => {
    const now = Date.parse("2026-07-16T00:00:00.000Z");
    const cutoff = now - 30 * dayMs;
    const insert = env.TELEMETRY_DB.prepare(
      `insert into frame_stats
         (id, session_id, screen_name, recorded_at, app_version, build_number, flavor,
          platform, os_version, device_model, refresh_rate_hz, frame_count,
          slow_build_count, slow_raster_count, frozen_count,
          sum_build_us, sum_raster_us, max_build_us, max_raster_us, created_at)
       values (?, 'session', 'Screen', ?, '2.3.0', 128, 'dev', 'ios', 'iOS 26.0',
               'iPhone17,1', 120, 100, 0, 0, 0, 0, 0, 0, 0, ?)`,
    );
    await env.TELEMETRY_DB.batch([
      insert.bind("old", cutoff - 1, cutoff - 1),
      insert.bind("boundary", cutoff, cutoff),
      insert.bind("recent", now, now),
    ]);
    const logs: unknown[] = [];

    await runTelemetryRetention({ TELEMETRY_DB: env.TELEMETRY_DB }, now, {
      log: (entry) => logs.push(entry),
    });

    const rows = await env.TELEMETRY_DB.prepare("select id from frame_stats order by id").all<{
      id: string;
    }>();
    expect(rows.results.map(({ id }) => id)).toEqual(["boundary", "recent"]);
    expect(logs).toEqual([{ deleted: 1, event: "telemetry_retention_completed" }]);
  });
});
