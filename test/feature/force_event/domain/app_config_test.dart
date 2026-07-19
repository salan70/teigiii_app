import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/force_event/domain/app_config.dart';

void main() {
  group('toAppMaintenance', () {
    test('メンテナンス状態と nullable な終了予定日時を変換する', () {
      // * Arrange
      final appConfig = AppConfig(
        minAppVersionIos: '2.0.0',
        minAppVersionAndroid: '2.1.0',
        inMaintenance: false,
        maintenanceScheduledEndTime: null,
        updatedAt: DateTime.utc(2026, 7, 19),
      );

      // * Act
      final appMaintenance = appConfig.toAppMaintenance();

      // * Assert
      expect(appMaintenance.inMaintenance, isFalse);
      expect(appMaintenance.scheduledEndTime, isNull);
    });
  });
}
