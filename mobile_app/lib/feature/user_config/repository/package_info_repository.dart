import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_info_repository.g.dart';

@riverpod
PackageInfoRepository packageInfoRepository(PackageInfoRepositoryRef ref) =>
    PackageInfoRepository();

class PackageInfoRepository {
  PackageInfoRepository();

  /// アプリのバージョンを取得する
  Future<String> fetchAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// ビルド番号を取得する
  ///
  /// バージョンの新旧判定に使うため、数値として扱えない場合は 0 を返す。
  Future<int> fetchBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return int.tryParse(packageInfo.buildNumber) ?? 0;
  }
}
