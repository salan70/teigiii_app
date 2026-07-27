import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../util/logger.dart';
import '../api/api_providers.dart';
import 'screen_frame_stats.dart';

part 'frame_stats_client.g.dart';

@Riverpod(keepAlive: true)
FrameStatsClient frameStatsClient(FrameStatsClientRef ref) =>
    FrameStatsClient(ref.watch(teigiiiApiProvider).getTelemetryApi());

/// フレーム計測の集計を Workers API へ送る。
///
/// 送信失敗はアプリの動作へ一切影響させない（呼び出し側で握りつぶす）。
/// 送信できなかった集計は再送しない。回帰検知が目的であり、
/// 数セッション分の欠落は結論を変えないため。
///
/// @doc doc/specs/app-performance-telemetry.md#送信
class FrameStatsClient {
  FrameStatsClient(
    this._telemetryApi, {
    void Function(String message)? logWarning,
  }) : _logWarning = logWarning ?? logger.w;

  final TelemetryApi _telemetryApi;
  final void Function(String message) _logWarning;

  /// 1 リクエストで送る画面数の上限（サーバー側の受け入れ上限と一致させる）。
  static const maxScreensPerRequest = 50;

  Future<void> send({
    required String sessionId,
    required FrameStatsDevice device,
    required List<ScreenFrameStats> stats,
    required DateTime recordedAt,
  }) async {
    if (stats.isEmpty) {
      return;
    }

    if (stats.length > maxScreensPerRequest) {
      _logWarning(
        'フレーム計測の送信画面数が上限を超えたため切り詰めます。 '
        'count: ${stats.length}, max: $maxScreensPerRequest',
      );
    }

    final screens = stats
        .take(maxScreensPerRequest)
        .map(
          (item) => FrameStatsScreen(
            screenName: item.screenName,
            recordedAt: recordedAt,
            frameCount: item.frameCount,
            slowBuildCount: item.slowBuildCount,
            slowRasterCount: item.slowRasterCount,
            frozenCount: item.frozenCount,
            sumBuildUs: item.sumBuildUs,
            sumRasterUs: item.sumRasterUs,
            maxBuildUs: item.maxBuildUs,
            maxRasterUs: item.maxRasterUs,
          ),
        )
        .toList();

    await _telemetryApi.v1TelemetryFramesPost(
      frameStatsRequest: FrameStatsRequest(
        sessionId: sessionId,
        device: device,
        screens: screens,
      ),
    );
  }
}
