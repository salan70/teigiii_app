import { uuidv7 } from "../lib/uuidv7";
import type { FrameStatsRequest } from "../schemas/telemetry";

/**
 * フレーム計測の集計を専用 D1（TELEMETRY_DB）へ保存する。
 * 1 リクエスト = 1 バッチで書き込み、途中失敗で部分挿入を残さない。
 *
 * @doc doc/specs/workers-api-server.md#フレーム計測テレメトリ
 */
export class FrameStatsService {
  constructor(private readonly database: D1Database) {}

  /** 保存した画面数を返す。 */
  async record(request: FrameStatsRequest, now: number = Date.now()): Promise<number> {
    const statement = this.database.prepare(
      `insert into frame_stats
         (id, session_id, screen_name, recorded_at, app_version, build_number, flavor,
          platform, os_version, device_model, refresh_rate_hz, frame_count,
          slow_build_count, slow_raster_count, frozen_count,
          sum_build_us, sum_raster_us, max_build_us, max_raster_us, created_at)
       values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    );
    const { device } = request;
    const statements = request.screens.map((screen) =>
      statement.bind(
        uuidv7(now),
        request.sessionId,
        screen.screenName,
        Date.parse(screen.recordedAt),
        device.appVersion,
        device.buildNumber,
        device.flavor,
        device.platform,
        device.osVersion,
        device.deviceModel,
        device.refreshRateHz,
        screen.frameCount,
        screen.slowBuildCount,
        screen.slowRasterCount,
        screen.frozenCount,
        screen.sumBuildUs,
        screen.sumRasterUs,
        screen.maxBuildUs,
        screen.maxRasterUs,
        now,
      ),
    );

    await this.database.batch(statements);
    return statements.length;
  }
}
