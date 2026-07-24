import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_info_repository.g.dart';

@riverpod
DeviceInfoRepository deviceInfoRepository(DeviceInfoRepositoryRef ref) =>
    DeviceInfoRepository();

class DeviceInfoRepository {
  DeviceInfoRepository();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// OSのバージョンを取得する
  ///
  /// OSがiOSでもAndroidでもない場合はnullを返す
  Future<String?> fetchOsVersion() async {
    if (kIsWeb) {
      final webInfo = await _deviceInfoPlugin.webBrowserInfo;
      return 'Web ${webInfo.browserName.name}';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return 'iOS ${iosInfo.systemVersion}';
      case TargetPlatform.android:
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return 'Android ${androidInfo.version.release}';
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return null;
    }
  }
}
