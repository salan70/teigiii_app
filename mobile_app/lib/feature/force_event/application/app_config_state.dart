import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:version/version.dart';

import '../../../util/extension/target_platform_extension.dart';
import '../../user_config/application/user_config_state.dart';
import '../domain/app_config.dart';
import '../repository/app_config_repository.dart';

part 'app_config_state.g.dart';

/// AppConfigを起動時に一度取得する
@Riverpod(keepAlive: true)
Future<AppConfig> appConfig(AppConfigRef ref) =>
    ref.watch(appConfigRepositoryProvider).fetchAppConfig();

/// アプリのアップデートが必要かどうか
@Riverpod(keepAlive: true)
Future<bool> isRequiredAppUpdate(IsRequiredAppUpdateRef ref) async {
  final appConfig = await ref.watch(appConfigProvider.future);
  final currentAppVersion = await ref.watch(appVersionProvider.future);

  final parsedRequiredVersion = defaultTargetPlatform.when(
    onIOS: () => Version.parse(appConfig.minAppVersionIos),
    onAndroid: () => Version.parse(appConfig.minAppVersionAndroid),
  );

  return parsedRequiredVersion > Version.parse(currentAppVersion);
}
