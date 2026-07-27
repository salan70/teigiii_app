import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_maintenance.dart';

part 'app_config.freezed.dart';

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required String minAppVersionIos,
    required String minAppVersionAndroid,
    required bool inMaintenance,
    required DateTime? maintenanceScheduledEndTime,

    /// フレーム計測テレメトリを送信してよいか。
    ///
    /// このフラグは通信量削減の最適化であり、即時停止の正ではない。
    /// [appConfigProvider] は起動時に一度しか取得しないため、起動中の
    /// セッションには反映されない。停止はサーバー側の受信 API で強制する。
    required bool perfTelemetryEnabled,
  }) = _AppConfig;
  const AppConfig._();

  AppMaintenance toAppMaintenance() => AppMaintenance(
    inMaintenance: inMaintenance,
    scheduledEndTime: maintenanceScheduledEndTime,
  );
}
