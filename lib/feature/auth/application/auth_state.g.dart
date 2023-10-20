// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userChangesHash() => r'4d38930d75575de157a299ad9b32c030d7490685';

/// ユーザーの状態を監視する
///
/// Copied from [userChanges].
@ProviderFor(userChanges)
final userChangesProvider = StreamProvider<User?>.internal(
  userChanges,
  name: r'userChangesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserChangesRef = StreamProviderRef<User?>;
String _$userIdHash() => r'ddb1ce88c396dbc1fc35794967e712feaf9aadac';

/// 現在ログインしているユーザーのIDを返す
///
/// ログインしていない場合はnullを返す
///
/// [userChangesProvider]をwatchしているため、ユーザーの状態が変更されるたびに更新される
///
/// Copied from [userId].
@ProviderFor(userId)
final userIdProvider = Provider<String?>.internal(
  userId,
  name: r'userIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserIdRef = ProviderRef<String?>;
String _$isSignedInHash() => r'7be28bf7800a870161b37258d04586b45882c83a';

/// 現在ログインしているかどうかを返す
///
/// [userChangesProvider]をwatchしているため、ユーザーの状態が変更されるたびに更新される
///
/// Copied from [isSignedIn].
@ProviderFor(isSignedIn)
final isSignedInProvider = Provider<bool>.internal(
  isSignedIn,
  name: r'isSignedInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isSignedInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsSignedInRef = ProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
