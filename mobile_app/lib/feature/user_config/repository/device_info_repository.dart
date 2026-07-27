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

  /// 端末の機種名を取得する
  ///
  /// 取得できない場合は 'unknown' を返す。
  Future<String> fetchDeviceModel() async {
    if (kIsWeb) {
      final webInfo = await _deviceInfoPlugin.webBrowserInfo;
      return webInfo.browserName.name;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.utsname.machine;
      case TargetPlatform.android:
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.model;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return 'unknown';
    }
  }
}
