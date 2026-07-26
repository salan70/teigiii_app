import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:version/version.dart';

import '../../../core/analytics/analytics_event.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../util/extension/target_platform_extension.dart';
import '../../user_config/application/user_config_state.dart';
import '../domain/app_config.dart';
import '../repository/app_config_repository.dart';

part 'app_config_state.g.dart';

/// AppConfigを起動時に一度取得する
@Riverpod(keepAlive: true)
Future<AppConfig> appConfig(AppConfigRef ref) async {
  final config = await ref.watch(appConfigRepositoryProvider).fetchAppConfig();
  if (config.inMaintenance) {
    // 計測失敗で起動を阻害しない
    unawaited(
      ref
          .read(analyticsServiceProvider)
          .logEvent(AnalyticsEvent.maintenanceShown),
    );
  }
  return config;
}

/// アプリのアップデートが必要かどうか
@Riverpod(keepAlive: true)
Future<bool> isRequiredAppUpdate(IsRequiredAppUpdateRef ref) async {
  final appConfig = await ref.watch(appConfigProvider.future);
  final currentAppVersion = await ref.watch(appVersionProvider.future);

  // Web QA ではストア配信がないため強制アップデート判定をスキップする。
  final parsedRequiredVersion = defaultTargetPlatform.when(
    onIOS: () => Version.parse(appConfig.minAppVersionIos),
    onAndroid: () => Version.parse(appConfig.minAppVersionAndroid),
    orElse: () => Version.parse('0.0.0'),
  );

  final isRequired = parsedRequiredVersion > Version.parse(currentAppVersion);
  if (isRequired) {
    // 計測失敗で起動を阻害しない
    unawaited(
      ref
          .read(analyticsServiceProvider)
          .logEvent(AnalyticsEvent.forceUpdateShown),
    );
  }
  return isRequired;
}
