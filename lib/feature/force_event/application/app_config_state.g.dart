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
    r'ad6191ba4d20745d89938655fbaa4a643dc5e5d9';

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
String _$appMaintenanceHash() => r'235fe44d1299e9bd787d26b51f397f095bb3acf6';

/// アプリのメンテナンス情報を保持する
///
/// [AppMaintenance]のinMaintenanceがfalse,
/// もしくは nullの場合はメンテナンス中でない
///
/// Copied from [appMaintenance].
@ProviderFor(appMaintenance)
final appMaintenanceProvider = Provider<AppMaintenance?>.internal(
  appMaintenance,
  name: r'appMaintenanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appMaintenanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppMaintenanceRef = ProviderRef<AppMaintenance?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
