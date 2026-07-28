#!/usr/bin/env bun
/**
 * just perf-report の実体。prod TELEMETRY_DB の固定集計を JSON で出力する。
 */

import {
  buildByDeviceQuery,
  buildByRefreshRateQuery,
  buildByScreenQuery,
  buildPerfReport,
  buildVersionComparisonQuery,
  parseOptionalBuildNumber,
  type AggregateRow,
  type VersionPairRow,
} from "./perf/report";
import { executeTelemetrySql } from "./perf/execute";

function asAggregateRows(rows: Record<string, unknown>[]): AggregateRow[] {
  return rows.map((row) => {
    const result: AggregateRow = {
      session_count: Number(row.session_count ?? 0),
      frame_count: Number(row.frame_count ?? 0),
      slow_build_count: Number(row.slow_build_count ?? 0),
      slow_raster_count: Number(row.slow_raster_count ?? 0),
      frozen_count: Number(row.frozen_count ?? 0),
    };
    if (typeof row.screen_name === "string") {
      result.screen_name = row.screen_name;
    }
    if (typeof row.device_model === "string") {
      result.device_model = row.device_model;
    }
    if (typeof row.refresh_rate_hz === "number" || typeof row.refresh_rate_hz === "string") {
      result.refresh_rate_hz = Number(row.refresh_rate_hz);
    }
    return result;
  });
}

function asVersionPairRows(rows: Record<string, unknown>[]): VersionPairRow[] {
  return rows.map((row) => ({
    platform: String(row.platform),
    flavor: String(row.flavor),
    screen_name: String(row.screen_name),
    latest_build_number: Number(row.latest_build_number),
    previous_build_number:
      row.previous_build_number === null || row.previous_build_number === undefined
        ? null
        : Number(row.previous_build_number),
    latest_session_count: Number(row.latest_session_count ?? 0),
    latest_frame_count: Number(row.latest_frame_count ?? 0),
    latest_slow_build_count: Number(row.latest_slow_build_count ?? 0),
    latest_slow_raster_count: Number(row.latest_slow_raster_count ?? 0),
    latest_frozen_count: Number(row.latest_frozen_count ?? 0),
    previous_session_count: Number(row.previous_session_count ?? 0),
    previous_frame_count: Number(row.previous_frame_count ?? 0),
    previous_slow_build_count: Number(row.previous_slow_build_count ?? 0),
    previous_slow_raster_count: Number(row.previous_slow_raster_count ?? 0),
    previous_frozen_count: Number(row.previous_frozen_count ?? 0),
  }));
}

async function main(): Promise<void> {
  const buildNumber = parseOptionalBuildNumber(Bun.argv.slice(2));
  const [byScreen, versionComparison, byDevice, byRefreshRate] = await Promise.all([
    executeTelemetrySql(buildByScreenQuery(buildNumber)).then(asAggregateRows),
    executeTelemetrySql(buildVersionComparisonQuery(buildNumber)).then(asVersionPairRows),
    executeTelemetrySql(buildByDeviceQuery(buildNumber)).then(asAggregateRows),
    executeTelemetrySql(buildByRefreshRateQuery(buildNumber)).then(asAggregateRows),
  ]);

  const report = buildPerfReport({
    buildNumber,
    byScreen,
    versionComparison,
    byDevice,
    byRefreshRate,
  });
  process.stdout.write(`${JSON.stringify(report, null, 2)}\n`);
}

main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  console.error(message);
  process.exit(1);
});
