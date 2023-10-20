import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_info_repository.g.dart';

@Riverpod(keepAlive: true)
DeviceInfoRepository deviceInfoRepository(DeviceInfoRepositoryRef ref) =>
    DeviceInfoRepository();

class DeviceInfoRepository {
  DeviceInfoRepository();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// OSのバージョンを取得する
  ///
  /// OSがiOSでもAndroidでもない場合はnullを返す
  Future<String?> fetchOsVersion() async {
    if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return 'iOS ${iosInfo.systemVersion}';
    }
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return 'Android ${androidInfo.version.release}';
    }

    // iOSでもAndroidでもない場合はnullを返す
    return null;
  }
}
