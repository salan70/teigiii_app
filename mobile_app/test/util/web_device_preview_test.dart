import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/web_device_preview.dart';

void main() {
  group('shouldEnableWebDevicePreview', () {
    test('native では無効', () {
      expect(
        shouldEnableWebDevicePreview(
          isWeb: false,
          platform: TargetPlatform.macOS,
        ),
        isFalse,
      );
    });

    test('Web + デスクトップ OS では有効', () {
      expect(
        shouldEnableWebDevicePreview(
          isWeb: true,
          platform: TargetPlatform.macOS,
        ),
        isTrue,
      );
      expect(
        shouldEnableWebDevicePreview(
          isWeb: true,
          platform: TargetPlatform.windows,
        ),
        isTrue,
      );
    });

    test('Web + iOS/Android 実機ブラウザでは無効', () {
      expect(
        shouldEnableWebDevicePreview(isWeb: true, platform: TargetPlatform.iOS),
        isFalse,
      );
      expect(
        shouldEnableWebDevicePreview(
          isWeb: true,
          platform: TargetPlatform.android,
        ),
        isFalse,
      );
    });
  });
}
