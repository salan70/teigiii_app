import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/extension/target_platform_extension.dart';

void main() {
  group('TargetPlatformExtension.when', () {
    test('iOS で onIOS を返す', () {
      expect(
        TargetPlatform.iOS.when(onIOS: () => 'ios', onAndroid: () => 'android'),
        'ios',
      );
    });

    test('Android で onAndroid を返す', () {
      expect(
        TargetPlatform.android.when(
          onIOS: () => 'ios',
          onAndroid: () => 'android',
        ),
        'android',
      );
    });

    test('orElse なしの desktop で UnsupportedError を投げる', () {
      // kIsWeb は VM テストでは常に false なので、web 分岐は直接検証できない。
      // web 用のフォールバックは orElse の有無というテスト可能な軸に落ちている。
      expect(
        () => TargetPlatform.macOS.when(
          onIOS: () => 'ios',
          onAndroid: () => 'android',
        ),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('orElse ありの desktop で orElse を返す', () {
      expect(
        TargetPlatform.macOS.when(
          onIOS: () => 'ios',
          onAndroid: () => 'android',
          orElse: () => 'other',
        ),
        'other',
      );
    });
  });
}
