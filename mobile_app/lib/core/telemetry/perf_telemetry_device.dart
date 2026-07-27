import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../feature/user_config/repository/device_info_repository.dart';
import '../../feature/user_config/repository/package_info_repository.dart';
import '../common_provider/flavor_state.dart';

part 'perf_telemetry_device.g.dart';

/// リフレッシュレートが取得できない場合の既定値。
const _fallbackRefreshRateHz = 60;

/// 端末・ビルドの識別情報。1 セッション中は変わらないため keepAlive で 1 度だけ解決する。
///
/// `user_id` は含めない。パフォーマンス分析に不要で、個人情報の取り扱いが増えるだけ。
@Riverpod(keepAlive: true)
Future<FrameStatsDevice> perfTelemetryDevice(PerfTelemetryDeviceRef ref) async {
  final packageInfoRepository = ref.read(packageInfoRepositoryProvider);
  final deviceInfoRepository = ref.read(deviceInfoRepositoryProvider);

  return FrameStatsDevice(
    appVersion: await packageInfoRepository.fetchAppVersion(),
    buildNumber: await packageInfoRepository.fetchBuildNumber(),
    flavor: switch (ref.read(flavorProvider)) {
      Flavor.prod => FrameStatsDeviceFlavorEnum.prod,
      Flavor.dev => FrameStatsDeviceFlavorEnum.dev,
    },
    platform: currentTelemetryPlatform(),
    osVersion: await deviceInfoRepository.fetchOsVersion() ?? 'unknown',
    deviceModel: await deviceInfoRepository.fetchDeviceModel(),
    refreshRateHz: currentRefreshRateHz(),
  );
}

/// 送信対象のプラットフォーム。iOS / Android / Web 以外は web 扱いにする。
FrameStatsDevicePlatformEnum currentTelemetryPlatform() {
  if (kIsWeb) {
    return FrameStatsDevicePlatformEnum.web;
  }
  return switch (defaultTargetPlatform) {
    TargetPlatform.iOS => FrameStatsDevicePlatformEnum.ios,
    TargetPlatform.android => FrameStatsDevicePlatformEnum.android,
    _ => FrameStatsDevicePlatformEnum.web,
  };
}

/// 端末のリフレッシュレート（Hz）。
///
/// ジャンク判定の予算は `1000 / refreshRate` ms とする。
/// 120Hz 端末の予算は 8.3ms であり、60Hz 固定で判定すると端末間で定義が崩れる。
int currentRefreshRateHz() {
  final views = WidgetsBinding.instance.platformDispatcher.views;
  if (views.isEmpty) {
    return _fallbackRefreshRateHz;
  }

  final refreshRate = views.first.display.refreshRate;
  if (!refreshRate.isFinite || refreshRate <= 0) {
    return _fallbackRefreshRateHz;
  }
  return refreshRate.round();
}

/// リフレッシュレートから 1 フレームの予算を求める。
Duration frameBudgetOf(int refreshRateHz) => Duration(
  microseconds: (Duration.microsecondsPerSecond / refreshRateHz).round(),
);
