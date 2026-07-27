import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../feature/force_event/application/app_config_state.dart';
import '../../util/logger.dart';
import 'frame_stats_client.dart';
import 'frame_stats_collector.dart';
import 'perf_telemetry_device.dart';

part 'perf_telemetry_service.g.dart';

/// 集計を送信する間隔。
const _defaultFlushInterval = Duration(minutes: 1);

@Riverpod(keepAlive: true)
PerfTelemetryService perfTelemetryService(PerfTelemetryServiceRef ref) =>
    PerfTelemetryService(
      client: ref.watch(frameStatsClientProvider),
      resolveDevice: () => ref.read(perfTelemetryDeviceProvider.future),
      // クライアント側のフラグは通信量削減の最適化であり、即時停止の正では
      // ない（appConfigProvider は起動時に一度しか取得しないため）。
      // 起動中のセッションを止める kill switch はサーバー側で効く。
      isEnabled: () =>
          ref.read(appConfigProvider).value?.perfTelemetryEnabled ?? true,
    );

/// 画面別のフレーム統計を集計してサーバーへ送る。
///
/// 用途は回帰検知と効果検証であり、原因特定ではない。原因特定はローカルの
/// profile ビルド + DevTools の役割なので、解像度はカウンタで足りる。
///
/// 画面遷移とフレームの対応付けの契約は [FrameStatsCollector] を参照。
///
/// @doc doc/specs/app-performance-telemetry.md#送信
class PerfTelemetryService {
  PerfTelemetryService({
    required FrameStatsClient client,
    required Future<FrameStatsDevice> Function() resolveDevice,
    required bool Function() isEnabled,
    Duration flushInterval = _defaultFlushInterval,
    int refreshRateHz = 0,
    String? sessionId,
    bool? measurable,
  }) : _client = client,
       _resolveDevice = resolveDevice,
       _isEnabled = isEnabled,
       _flushInterval = flushInterval,
       // debug ビルドの数値は本番の統計に混ぜない（JIT で build が遅く、
       // release の傾向を歪めるため）。
       _measurable = measurable ?? !kDebugMode,
       _sessionId = sessionId ?? _generateSessionId(),
       _collector = FrameStatsCollector(
         frameBudget: frameBudgetOf(
           refreshRateHz > 0 ? refreshRateHz : currentRefreshRateHz(),
         ),
       );

  final FrameStatsClient _client;
  final Future<FrameStatsDevice> Function() _resolveDevice;
  final bool Function() _isEnabled;
  final Duration _flushInterval;
  final bool _measurable;
  final String _sessionId;
  final FrameStatsCollector _collector;

  Timer? _flushTimer;
  AppLifecycleListener? _lifecycleListener;
  bool _started = false;

  @visibleForTesting
  FrameStatsCollector get collector => _collector;

  /// 計測を開始する。2 回目以降の呼び出しは無視する。
  void start() {
    if (_started || !_measurable) {
      return;
    }
    _started = true;

    SchedulerBinding.instance
      // 生成されたフレームをリアルタイムに数える。addTimingsCallback は
      // release で約 1 秒遅れて届くため、画面境界はこちらで取る。
      ..addPersistentFrameCallback((_) => _collector.onFrameProduced())
      ..addTimingsCallback(_collector.onTimings);

    _flushTimer = Timer.periodic(_flushInterval, (_) => unawaited(flush()));
    _lifecycleListener = AppLifecycleListener(
      // background へ回ると次の flush まで送信機会がないため、ここで送る。
      onPause: () => unawaited(flush()),
      onDetach: () => unawaited(flush()),
    );
  }

  /// 表示中の画面が変わったことを伝える。
  void handleScreenChanged(String screenName) {
    if (!_measurable) {
      return;
    }
    _collector.onScreenChanged(screenName);
  }

  /// 集計を取り出して送信する。
  ///
  /// 送信失敗はログのみで、呼び出し元へ例外を伝播させない。
  Future<void> flush() async {
    if (!_measurable) {
      return;
    }

    final stats = _collector.drain();
    if (stats.isEmpty) {
      return;
    }

    // 無効時も drain 済みなのでバッファは溜まらない。
    if (!_isEnabled()) {
      return;
    }

    try {
      await _client.send(
        sessionId: _sessionId,
        device: await _resolveDevice(),
        stats: stats,
        recordedAt: DateTime.now().toUtc(),
      );
    } on Object catch (error) {
      logger.w('フレーム計測の送信に失敗しました。 error: $error');
    }
  }

  /// テスト用。タイマーと lifecycle listener を解放する。
  @visibleForTesting
  void dispose() {
    _flushTimer?.cancel();
    _flushTimer = null;
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
  }
}

String _generateSessionId() {
  final random = Random();
  final suffix = List.generate(
    4,
    (_) => random.nextInt(0x10000).toRadixString(16).padLeft(4, '0'),
  ).join();
  return '${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}-$suffix';
}
