import 'package:flutter/foundation.dart';

extension TargetPlatformExtension on TargetPlatform {
  /// [TargetPlatform]に対して、 iOS と Android の場合で処理を分ける。
  ///
  /// Web、または iOS / Android 以外で [orElse] が無い場合は
  /// [UnsupportedError] を投げる。
  T when<T>({
    required T Function() onIOS,
    required T Function() onAndroid,
    T Function()? orElse,
  }) {
    if (kIsWeb) {
      if (orElse != null) {
        return orElse();
      }
      throw UnsupportedError('Unsupported platform web');
    }

    switch (this) {
      case TargetPlatform.iOS:
        return onIOS();
      case TargetPlatform.android:
        return onAndroid();

      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        if (orElse != null) {
          return orElse();
        }
        throw UnsupportedError('Unsupported platform $this');
    }
  }
}
