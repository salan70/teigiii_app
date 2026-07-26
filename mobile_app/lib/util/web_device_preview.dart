import 'package:flutter/foundation.dart';

/// Web QA を PC ブラウザで開いたときだけ DevicePreview（スマホ枠）を有効にする。
/// iPhone / Android 実機ブラウザでは枠を出さない（QR 確認用）。
bool shouldEnableWebDevicePreview({
  required bool isWeb,
  required TargetPlatform platform,
}) {
  if (!isWeb) {
    return false;
  }
  return platform != TargetPlatform.iOS && platform != TargetPlatform.android;
}
