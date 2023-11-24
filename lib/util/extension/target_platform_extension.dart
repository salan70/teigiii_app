import 'package:flutter/foundation.dart';

extension TargetPlatformExtension on TargetPlatform {
  /// [TargetPlatform]に対して、 iOS と Android の場合で処理を分ける。
  ///
  /// iOS でも Android でもない場合は、[UnsupportedError] を投げる。
  T when<T>({
    required T Function() onIOS,
    required T Function() onAndroid,
  }) {
    switch (this) {
      case TargetPlatform.iOS:
        return onIOS();
      case TargetPlatform.android:
        return onAndroid();

      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        throw UnsupportedError('Unsupported platform $this');
    }
  }
}
