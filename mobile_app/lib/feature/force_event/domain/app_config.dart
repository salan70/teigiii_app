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
  }) = _AppConfig;
  const AppConfig._();

  AppMaintenance toAppMaintenance() => AppMaintenance(
    inMaintenance: inMaintenance,
    scheduledEndTime: maintenanceScheduledEndTime,
  );
}
