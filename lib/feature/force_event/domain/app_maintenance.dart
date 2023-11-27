import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_maintenance.freezed.dart';

@freezed
class AppMaintenance with _$AppMaintenance {
  const factory AppMaintenance({
    required bool inMaintenance,
    required String scheduledEndTime,
  }) = _AppMaintenance;
}
