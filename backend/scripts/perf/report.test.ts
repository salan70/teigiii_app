import { describe, expect, test } from "bun:test";

import {
  buildByDeviceQuery,
  buildByRefreshRateQuery,
  buildByScreenQuery,
  buildPerfReport,
  buildVersionComparisonQuery,
  parseOptionalBuildNumber,
  rate,
  type AggregateRow,
  type VersionPairRow,
} from "./report";

describe("parseOptionalBuildNumber", () => {
  test("未指定は null", () => {
    expect(parseOptionalBuildNumber(undefined)).toBeNull();
    expect(parseOptionalBuildNumber([])).toBeNull();
  });

  test("正の整数を受け付ける", () => {
    expect(parseOptionalBuildNumber(["42"])).toBe(42);
  });

  test("不正な値はエラー", () => {
    expect(() => parseOptionalBuildNumber(["0"])).toThrow();
    expect(() => parseOptionalBuildNumber(["-1"])).toThrow();
    expect(() => parseOptionalBuildNumber(["1.5"])).toThrow();
    expect(() => parseOptionalBuildNumber(["abc"])).toThrow();
  });
});

describe("rate", () => {
  test("分母0は null", () => {
    expect(rate(1, 0)).toBeNull();
  });

  test("比率を返す", () => {
    expect(rate(1, 4)).toBe(0.25);
  });
});

describe("SQL builders", () => {
  test("画面別クエリは build_number フィルタなしで全件集計する", () => {
    const sql = buildByScreenQuery(null);
    expect(sql).toContain("GROUP BY screen_name");
    expect(sql).not.toContain("build_number =");
    expect(sql).toContain("COUNT(DISTINCT session_id) AS session_count");
    expect(sql).toContain("SUM(frame_count) AS frame_count");
  });

  test("画面別クエリは build_number で絞り込む", () => {
    const sql = buildByScreenQuery(100);
    expect(sql).toContain("build_number = 100");
  });

  test("バージョン比較は platform + flavor ごとに build_number で最新と直前を選ぶ", () => {
    const sql = buildVersionComparisonQuery(null);
    expect(sql).toContain("ORDER BY build_number DESC");
    expect(sql).toContain("platform");
    expect(sql).toContain("flavor");
    expect(sql).toContain("latest_build_number");
    expect(sql).toContain("previous_build_number");
    expect(sql).not.toContain("ORDER BY app_version");
    expect(sql).toContain("DENSE_RANK()");
  });

  test("バージョン比較は指定 build_number を latest に固定する", () => {
    const sql = buildVersionComparisonQuery(42);
    expect(sql).toContain("42 AS latest_build_number");
    expect(sql).toContain("f.build_number < lb.latest_build_number");
    expect(sql).not.toContain("DENSE_RANK()");
  });

  test("バージョン比較は previous_builds を画面と独立に結合する", () => {
    const sql = buildVersionComparisonQuery(null);
    expect(sql).toContain("LEFT JOIN previous_builds pb");
    expect(sql).toContain("LEFT JOIN previous_stats p");
    expect(sql).toContain("pb.previous_build_number");
  });

  test("端末別・リフレッシュレート別もサンプル数を含む", () => {
    expect(buildByDeviceQuery(null)).toContain("session_count");
    expect(buildByRefreshRateQuery(7)).toContain("build_number = 7");
  });
});

describe("buildPerfReport", () => {
  const screenRows: AggregateRow[] = [
    {
      screen_name: "HomeRoute",
      session_count: 10,
      frame_count: 1000,
      slow_build_count: 50,
      slow_raster_count: 20,
      frozen_count: 1,
    },
    {
      screen_name: "SparseRoute",
      session_count: 1,
      frame_count: 5,
      slow_build_count: 4,
      slow_raster_count: 0,
      frozen_count: 0,
    },
  ];

  const versionRows: VersionPairRow[] = [
    {
      platform: "ios",
      flavor: "prod",
      screen_name: "HomeRoute",
      latest_build_number: 12,
      previous_build_number: 11,
      latest_session_count: 8,
      latest_frame_count: 800,
      latest_slow_build_count: 40,
      latest_slow_raster_count: 16,
      latest_frozen_count: 0,
      previous_session_count: 10,
      previous_frame_count: 1000,
      previous_slow_build_count: 30,
      previous_slow_raster_count: 10,
      previous_frozen_count: 0,
    },
  ];

  const deviceRows: AggregateRow[] = [
    {
      device_model: "iPhone17,1",
      session_count: 5,
      frame_count: 500,
      slow_build_count: 10,
      slow_raster_count: 5,
      frozen_count: 0,
    },
  ];

  const refreshRows: AggregateRow[] = [
    {
      refresh_rate_hz: 120,
      session_count: 7,
      frame_count: 700,
      slow_build_count: 70,
      slow_raster_count: 14,
      frozen_count: 0,
    },
  ];

  const generatedAt = "2026-07-27T00:00:00.000Z";

  test("画面別ジャンク率とサンプル数を含める", () => {
    const report = buildPerfReport({
      buildNumber: null,
      byScreen: screenRows,
      versionComparison: versionRows,
      byDevice: deviceRows,
      byRefreshRate: refreshRows,
      generatedAt,
    });

    expect(report.generatedAt).toBe(generatedAt);
    expect(report.buildNumberFilter).toBeNull();
    expect(report.byScreen).toEqual([
      {
        screenName: "HomeRoute",
        sessionCount: 10,
        frameCount: 1000,
        slowBuildRate: 0.05,
        slowRasterRate: 0.02,
        frozenRate: 0.001,
      },
      {
        screenName: "SparseRoute",
        sessionCount: 1,
        frameCount: 5,
        slowBuildRate: 0.8,
        slowRasterRate: 0,
        frozenRate: 0,
      },
    ]);
  });

  test("バージョン比較は build_number 基準で前後レートを出す", () => {
    const report = buildPerfReport({
      buildNumber: 12,
      byScreen: screenRows,
      versionComparison: versionRows,
      byDevice: deviceRows,
      byRefreshRate: refreshRows,
      generatedAt,
    });

    expect(report.buildNumberFilter).toBe(12);
    expect(report.versionComparison).toEqual([
      {
        platform: "ios",
        flavor: "prod",
        screenName: "HomeRoute",
        latestBuildNumber: 12,
        previousBuildNumber: 11,
        latest: {
          sessionCount: 8,
          frameCount: 800,
          slowBuildRate: 0.05,
          slowRasterRate: 0.02,
          frozenRate: 0,
        },
        previous: {
          sessionCount: 10,
          frameCount: 1000,
          slowBuildRate: 0.03,
          slowRasterRate: 0.01,
          frozenRate: 0,
        },
      },
    ]);
  });

  test("直前ビルド番号はあるが画面未観測なら previous はゼロのまま build 番号を残す", () => {
    const report = buildPerfReport({
      buildNumber: 12,
      byScreen: [],
      versionComparison: [
        {
          platform: "ios",
          flavor: "prod",
          screen_name: "NewRoute",
          latest_build_number: 12,
          previous_build_number: 11,
          latest_session_count: 3,
          latest_frame_count: 300,
          latest_slow_build_count: 0,
          latest_slow_raster_count: 0,
          latest_frozen_count: 0,
          previous_session_count: 0,
          previous_frame_count: 0,
          previous_slow_build_count: 0,
          previous_slow_raster_count: 0,
          previous_frozen_count: 0,
        },
      ],
      byDevice: [],
      byRefreshRate: [],
      generatedAt,
    });

    expect(report.versionComparison[0]).toMatchObject({
      screenName: "NewRoute",
      latestBuildNumber: 12,
      previousBuildNumber: 11,
      previous: {
        sessionCount: 0,
        frameCount: 0,
        slowBuildRate: null,
        slowRasterRate: null,
        frozenRate: null,
      },
    });
  });

  test("端末別・リフレッシュレート別の内訳を含める", () => {
    const report = buildPerfReport({
      buildNumber: null,
      byScreen: [],
      versionComparison: [],
      byDevice: deviceRows,
      byRefreshRate: refreshRows,
      generatedAt,
    });

    expect(report.byDevice[0]).toMatchObject({
      deviceModel: "iPhone17,1",
      sessionCount: 5,
      frameCount: 500,
      slowBuildRate: 0.02,
    });
    expect(report.byRefreshRate[0]).toMatchObject({
      refreshRateHz: 120,
      sessionCount: 7,
      frameCount: 700,
      slowBuildRate: 0.1,
    });
  });
});
