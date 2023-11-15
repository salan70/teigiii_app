import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:version/version.dart';

import '../../user_config/application/user_config_state.dart';
import '../domain/app_maintenance.dart';
import '../repository/app_config_repository.dart';
import '../repository/entity/app_config_document.dart';

part 'app_config_state.g.dart';

/// AppConfigを監視する
@Riverpod(keepAlive: true)
Stream<AppConfigDocument> appConfig(AppConfigRef ref) =>
    ref.watch(appConfigRepositoryProvider).subscribeAppConfig();

/// アプリのアップデートが必要かどうか
@Riverpod(keepAlive: true)
Future<bool> isRequiredAppUpdate(IsRequiredAppUpdateRef ref) async {
  final appConfig = ref.watch(appConfigProvider).value;
  final currentAppVersion = ref.watch(appVersionProvider).value;

  // 少なくとも片方がロード中の場合、trueになる想定
  if (appConfig == null || currentAppVersion == null) {
    return false;
  }

  final parsedCurrentVersion = Version.parse(currentAppVersion);
  late final Version parsedRequiredVersion;
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      parsedRequiredVersion = Version.parse(appConfig.minAppVersionForIos);
      break;

    case TargetPlatform.android:
      parsedRequiredVersion = Version.parse(appConfig.minAppVersionForAndroid);
      break;

    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      throw UnsupportedError(
        '想定外のプラットフォームです。 defaultTargetPlatform: $defaultTargetPlatform',
      );
  }

  return parsedRequiredVersion > parsedCurrentVersion;
}

/// アプリのメンテナンス情報を保持する
///
/// [AppMaintenance]のinMaintenanceがfalse,
/// もしくは nullの場合はメンテナンス中でない
@Riverpod(keepAlive: true)
AppMaintenance? appMaintenance(AppMaintenanceRef ref) {
  final appConfig = ref.watch(appConfigProvider).value;

  // ロード中の場合、nullを返す
  if (appConfig == null) {
    return null;
  }

  return appConfig.toAppMaintenance();
}
