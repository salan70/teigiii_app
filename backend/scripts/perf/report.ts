/**
 * パフォーマンス分析用の固定集計。
 * AI 主導線は just perf-report。raw SQL は just perf-query（手動調査用）。
 */

export type AggregateRow = {
  screen_name?: string;
  device_model?: string;
  refresh_rate_hz?: number;
  session_count: number;
  frame_count: number;
  slow_build_count: number;
  slow_raster_count: number;
  frozen_count: number;
};

export type VersionPairRow = {
  platform: string;
  flavor: string;
  screen_name: string;
  latest_build_number: number;
  previous_build_number: number | null;
  latest_session_count: number;
  latest_frame_count: number;
  latest_slow_build_count: number;
  latest_slow_raster_count: number;
  latest_frozen_count: number;
  previous_session_count: number;
  previous_frame_count: number;
  previous_slow_build_count: number;
  previous_slow_raster_count: number;
  previous_frozen_count: number;
};

export type RateBlock = {
  sessionCount: number;
  frameCount: number;
  slowBuildRate: number | null;
  slowRasterRate: number | null;
  frozenRate: number | null;
};

export type PerfReport = {
  generatedAt: string;
  buildNumberFilter: number | null;
  byScreen: Array<RateBlock & { screenName: string }>;
  versionComparison: Array<{
    platform: string;
    flavor: string;
    screenName: string;
    latestBuildNumber: number;
    previousBuildNumber: number | null;
    latest: RateBlock;
    previous: RateBlock;
  }>;
  byDevice: Array<RateBlock & { deviceModel: string }>;
  byRefreshRate: Array<RateBlock & { refreshRateHz: number }>;
};

export function parseOptionalBuildNumber(args: string[] | undefined): number | null {
  if (args === undefined || args.length === 0) {
    return null;
  }
  const raw = args[0];
  if (raw === undefined || !/^[1-9]\d*$/.test(raw)) {
    throw new Error(`build_number must be a positive integer, got: ${raw ?? "(empty)"}`);
  }
  return Number(raw);
}

export function rate(numerator: number, denominator: number): number | null {
  if (denominator === 0) {
    return null;
  }
  return numerator / denominator;
}

function buildNumberFilterSql(buildNumber: number | null): string {
  return buildNumber === null ? "" : `WHERE build_number = ${buildNumber}`;
}

const aggregateSelect = `
  COUNT(DISTINCT session_id) AS session_count,
  SUM(frame_count) AS frame_count,
  SUM(slow_build_count) AS slow_build_count,
  SUM(slow_raster_count) AS slow_raster_count,
  SUM(frozen_count) AS frozen_count
`.trim();

export function buildByScreenQuery(buildNumber: number | null): string {
  const where = buildNumberFilterSql(buildNumber);
  return `
SELECT
  screen_name,
  ${aggregateSelect}
FROM frame_stats
${where}
GROUP BY screen_name
ORDER BY frame_count DESC
`.trim();
}

export function buildByDeviceQuery(buildNumber: number | null): string {
  const where = buildNumberFilterSql(buildNumber);
  return `
SELECT
  device_model,
  ${aggregateSelect}
FROM frame_stats
${where}
GROUP BY device_model
ORDER BY frame_count DESC
`.trim();
}

export function buildByRefreshRateQuery(buildNumber: number | null): string {
  const where = buildNumberFilterSql(buildNumber);
  return `
SELECT
  refresh_rate_hz,
  ${aggregateSelect}
FROM frame_stats
${where}
GROUP BY refresh_rate_hz
ORDER BY refresh_rate_hz DESC
`.trim();
}

/**
 * platform + flavor ごとに数値 build_number で最新と直前を選び、画面別に比較する。
 * app_version の文字列順は使わない（semver 辞書順が壊れるため）。
 *
 * buildNumber 指定時はその値を latest に固定し、直前はそれより小さい最大値。
 * previous_build_number は platform+flavor 単位（画面非依存）。画面未観測なら
 * previous_* 集計は 0 / null だが previousBuildNumber 自体は残る。
 * 行は latest 側の画面が起点。直前にあって最新で消えた画面は出ない。
 */
export function buildVersionComparisonQuery(buildNumber: number | null): string {
  const latestBuildsCte =
    buildNumber === null
      ? `ranked_builds AS (
  SELECT
    platform,
    flavor,
    build_number,
    DENSE_RANK() OVER (
      PARTITION BY platform, flavor
      ORDER BY build_number DESC
    ) AS build_rank
  FROM frame_stats
  GROUP BY platform, flavor, build_number
),
latest_builds AS (
  SELECT platform, flavor, build_number AS latest_build_number
  FROM ranked_builds
  WHERE build_rank = 1
),
previous_builds AS (
  SELECT platform, flavor, build_number AS previous_build_number
  FROM ranked_builds
  WHERE build_rank = 2
)`
      : `latest_builds AS (
  SELECT DISTINCT
    platform,
    flavor,
    ${buildNumber} AS latest_build_number
  FROM frame_stats
  WHERE build_number = ${buildNumber}
),
previous_builds AS (
  SELECT
    f.platform,
    f.flavor,
    MAX(f.build_number) AS previous_build_number
  FROM frame_stats f
  INNER JOIN latest_builds lb
    ON f.platform = lb.platform
   AND f.flavor = lb.flavor
  WHERE f.build_number < lb.latest_build_number
  GROUP BY f.platform, f.flavor
)`;

  return `
WITH ${latestBuildsCte},
latest_stats AS (
  SELECT
    f.platform,
    f.flavor,
    f.screen_name,
    lb.latest_build_number,
    COUNT(DISTINCT f.session_id) AS session_count,
    SUM(f.frame_count) AS frame_count,
    SUM(f.slow_build_count) AS slow_build_count,
    SUM(f.slow_raster_count) AS slow_raster_count,
    SUM(f.frozen_count) AS frozen_count
  FROM frame_stats f
  INNER JOIN latest_builds lb
    ON f.platform = lb.platform
   AND f.flavor = lb.flavor
   AND f.build_number = lb.latest_build_number
  GROUP BY f.platform, f.flavor, f.screen_name, lb.latest_build_number
),
previous_stats AS (
  SELECT
    f.platform,
    f.flavor,
    f.screen_name,
    pb.previous_build_number,
    COUNT(DISTINCT f.session_id) AS session_count,
    SUM(f.frame_count) AS frame_count,
    SUM(f.slow_build_count) AS slow_build_count,
    SUM(f.slow_raster_count) AS slow_raster_count,
    SUM(f.frozen_count) AS frozen_count
  FROM frame_stats f
  INNER JOIN previous_builds pb
    ON f.platform = pb.platform
   AND f.flavor = pb.flavor
   AND f.build_number = pb.previous_build_number
  GROUP BY f.platform, f.flavor, f.screen_name, pb.previous_build_number
)
SELECT
  l.platform,
  l.flavor,
  l.screen_name,
  l.latest_build_number,
  pb.previous_build_number,
  l.session_count AS latest_session_count,
  l.frame_count AS latest_frame_count,
  l.slow_build_count AS latest_slow_build_count,
  l.slow_raster_count AS latest_slow_raster_count,
  l.frozen_count AS latest_frozen_count,
  COALESCE(p.session_count, 0) AS previous_session_count,
  COALESCE(p.frame_count, 0) AS previous_frame_count,
  COALESCE(p.slow_build_count, 0) AS previous_slow_build_count,
  COALESCE(p.slow_raster_count, 0) AS previous_slow_raster_count,
  COALESCE(p.frozen_count, 0) AS previous_frozen_count
FROM latest_stats l
LEFT JOIN previous_builds pb
  ON l.platform = pb.platform
 AND l.flavor = pb.flavor
LEFT JOIN previous_stats p
  ON l.platform = p.platform
 AND l.flavor = p.flavor
 AND l.screen_name = p.screen_name
ORDER BY l.platform, l.flavor, l.latest_frame_count DESC
`.trim();
}

function toRateBlock(row: {
  session_count: number;
  frame_count: number;
  slow_build_count: number;
  slow_raster_count: number;
  frozen_count: number;
}): RateBlock {
  return {
    sessionCount: row.session_count,
    frameCount: row.frame_count,
    slowBuildRate: rate(row.slow_build_count, row.frame_count),
    slowRasterRate: rate(row.slow_raster_count, row.frame_count),
    frozenRate: rate(row.frozen_count, row.frame_count),
  };
}

export function buildPerfReport(input: {
  buildNumber: number | null;
  byScreen: AggregateRow[];
  versionComparison: VersionPairRow[];
  byDevice: AggregateRow[];
  byRefreshRate: AggregateRow[];
  generatedAt?: string;
}): PerfReport {
  return {
    generatedAt: input.generatedAt ?? new Date().toISOString(),
    buildNumberFilter: input.buildNumber,
    byScreen: input.byScreen.map((row) => ({
      screenName: String(row.screen_name),
      ...toRateBlock(row),
    })),
    versionComparison: input.versionComparison.map((row) => ({
      platform: row.platform,
      flavor: row.flavor,
      screenName: row.screen_name,
      latestBuildNumber: row.latest_build_number,
      previousBuildNumber: row.previous_build_number,
      latest: toRateBlock({
        session_count: row.latest_session_count,
        frame_count: row.latest_frame_count,
        slow_build_count: row.latest_slow_build_count,
        slow_raster_count: row.latest_slow_raster_count,
        frozen_count: row.latest_frozen_count,
      }),
      previous: toRateBlock({
        session_count: row.previous_session_count,
        frame_count: row.previous_frame_count,
        slow_build_count: row.previous_slow_build_count,
        slow_raster_count: row.previous_slow_raster_count,
        frozen_count: row.previous_frozen_count,
      }),
    })),
    byDevice: input.byDevice.map((row) => ({
      deviceModel: String(row.device_model),
      ...toRateBlock(row),
    })),
    byRefreshRate: input.byRefreshRate.map((row) => ({
      refreshRateHz: Number(row.refresh_rate_hz),
      ...toRateBlock(row),
    })),
  };
}
