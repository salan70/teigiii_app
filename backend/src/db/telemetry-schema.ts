import { index, integer, sqliteTable, text } from "drizzle-orm/sqlite-core";

// 日時列はすべて unix ミリ秒の INTEGER。API 境界で ISO 8601 に変換する。
// アプリ本体の D1（DB）とは別データベース（TELEMETRY_DB）に置く。
// 計測データの書き込み量・保持期間・削除運用がアプリデータと独立しているため。

/**
 * フレーム計測の集計行。1 行 = 1 セッション × 1 画面。
 * 生フレームもパーセンタイルも保存せず、件数と合計・最大だけを持つ。
 * 個人を特定しうる識別子（user_id 等）は持たない。session_id は端末のセッション単位で使い捨てる。
 */
export const frameStats = sqliteTable(
  "frame_stats",
  {
    id: text("id").primaryKey(),
    sessionId: text("session_id").notNull(),
    screenName: text("screen_name").notNull(),
    // 端末側で計測区間を閉じた時刻（分析用）。リテンション基準には使わない。
    recordedAt: integer("recorded_at").notNull(),
    appVersion: text("app_version").notNull(),
    buildNumber: integer("build_number").notNull(),
    flavor: text("flavor").notNull(),
    platform: text("platform").notNull(),
    osVersion: text("os_version").notNull(),
    deviceModel: text("device_model").notNull(),
    refreshRateHz: integer("refresh_rate_hz").notNull(),
    frameCount: integer("frame_count").notNull(),
    slowBuildCount: integer("slow_build_count").notNull(),
    slowRasterCount: integer("slow_raster_count").notNull(),
    frozenCount: integer("frozen_count").notNull(),
    sumBuildUs: integer("sum_build_us").notNull(),
    sumRasterUs: integer("sum_raster_us").notNull(),
    maxBuildUs: integer("max_build_us").notNull(),
    maxRasterUs: integer("max_raster_us").notNull(),
    createdAt: integer("created_at").notNull(),
  },
  (table) => [
    // 分析の期間絞り込み用（クライアント計測時刻）。
    index("frame_stats_recorded_at_index").on(table.recordedAt),
    // リテンション削除用（サーバー受信時刻）。
    index("frame_stats_created_at_index").on(table.createdAt),
    // ビルド別の集計用。
    index("frame_stats_platform_flavor_build_index").on(
      table.platform,
      table.flavor,
      table.buildNumber,
    ),
  ],
);
