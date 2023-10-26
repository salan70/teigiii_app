import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/logger.dart';

part 'package_info_repository.g.dart';

@Riverpod(keepAlive: true)
PackageInfoRepository packageInfoRepository(PackageInfoRepositoryRef ref) =>
    PackageInfoRepository();

class PackageInfoRepository {
  PackageInfoRepository();

  /// アプリのバージョンを取得する
  Future<String> fetchAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
