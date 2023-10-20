// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userIdHash() => r'8124d35a39f3edecbe46a479d9ae70cee6f6c429';

/// 現在ログインしているユーザーのIDを取得する
///
/// ログインしていない場合はnullを返す
///
/// Copied from [userId].
@ProviderFor(userId)
final userIdProvider = FutureProvider<String?>.internal(
  userId,
  name: r'userIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserIdRef = FutureProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
