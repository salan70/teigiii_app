// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appConfigHash() => r'b931c291b2d3a5049592923f40dc3ea7aa5a07a6';

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
    r'bfb2d0c978863a76d3c4f80d1ba1fea8234d05d6';

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
