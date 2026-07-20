// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appConfigHash() => r'3b502a13d3804001a07c6bdb48449f75446af81f';

/// AppConfigを起動時に一度取得する
///
/// Copied from [appConfig].
@ProviderFor(appConfig)
final appConfigProvider = FutureProvider<AppConfig>.internal(
  appConfig,
  name: r'appConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppConfigRef = FutureProviderRef<AppConfig>;
String _$isRequiredAppUpdateHash() =>
    r'7f2ad04708c66fe6f976de031b755c1496214061';

/// アプリのアップデートが必要かどうか
///
/// Copied from [isRequiredAppUpdate].
@ProviderFor(isRequiredAppUpdate)
final isRequiredAppUpdateProvider = FutureProvider<bool>.internal(
  isRequiredAppUpdate,
  name: r'isRequiredAppUpdateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isRequiredAppUpdateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsRequiredAppUpdateRef = FutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
