// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appConfigHash() => r'28e72d143d5d1f2be2ef58a5851f391bb7066eba';

/// AppConfigを監視する
///
/// Copied from [appConfig].
@ProviderFor(appConfig)
final appConfigProvider = StreamProvider<AppConfigDocument>.internal(
  appConfig,
  name: r'appConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppConfigRef = StreamProviderRef<AppConfigDocument>;
String _$isRequiredAppUpdateHash() =>
    r'cb5a7589b46bea1e28263e5ecd4370192b74e81e';

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
