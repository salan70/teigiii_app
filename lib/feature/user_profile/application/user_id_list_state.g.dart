// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_id_list_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userIdListStateNotifierHash() =>
    r'b44533a5622901906fc13b124538de8271a3d747';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$UserIdListStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<UserIdListState> {
  late final UserListType userListType;
  late final String? targetUserId;
  late final String? targetDefinitionId;

  FutureOr<UserIdListState> build(
    UserListType userListType, {
    required String? targetUserId,
    required String? targetDefinitionId,
  });
}

/// See also [UserIdListStateNotifier].
@ProviderFor(UserIdListStateNotifier)
const userIdListStateNotifierProvider = UserIdListStateNotifierFamily();

/// See also [UserIdListStateNotifier].
class UserIdListStateNotifierFamily
    extends Family<AsyncValue<UserIdListState>> {
  /// See also [UserIdListStateNotifier].
  const UserIdListStateNotifierFamily();

  /// See also [UserIdListStateNotifier].
  UserIdListStateNotifierProvider call(
    UserListType userListType, {
    required String? targetUserId,
    required String? targetDefinitionId,
  }) {
    return UserIdListStateNotifierProvider(
      userListType,
      targetUserId: targetUserId,
      targetDefinitionId: targetDefinitionId,
    );
  }

  @override
  UserIdListStateNotifierProvider getProviderOverride(
    covariant UserIdListStateNotifierProvider provider,
  ) {
    return call(
      provider.userListType,
      targetUserId: provider.targetUserId,
      targetDefinitionId: provider.targetDefinitionId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userIdListStateNotifierProvider';
}

/// See also [UserIdListStateNotifier].
class UserIdListStateNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserIdListStateNotifier,
        UserIdListState> {
  /// See also [UserIdListStateNotifier].
  UserIdListStateNotifierProvider(
    UserListType userListType, {
    required String? targetUserId,
    required String? targetDefinitionId,
  }) : this._internal(
          () => UserIdListStateNotifier()
            ..userListType = userListType
            ..targetUserId = targetUserId
            ..targetDefinitionId = targetDefinitionId,
          from: userIdListStateNotifierProvider,
          name: r'userIdListStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userIdListStateNotifierHash,
          dependencies: UserIdListStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserIdListStateNotifierFamily._allTransitiveDependencies,
          userListType: userListType,
          targetUserId: targetUserId,
          targetDefinitionId: targetDefinitionId,
        );

  UserIdListStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userListType,
    required this.targetUserId,
    required this.targetDefinitionId,
  }) : super.internal();

  final UserListType userListType;
  final String? targetUserId;
  final String? targetDefinitionId;

  @override
  FutureOr<UserIdListState> runNotifierBuild(
    covariant UserIdListStateNotifier notifier,
  ) {
    return notifier.build(
      userListType,
      targetUserId: targetUserId,
      targetDefinitionId: targetDefinitionId,
    );
  }

  @override
  Override overrideWith(UserIdListStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserIdListStateNotifierProvider._internal(
        () => create()
          ..userListType = userListType
          ..targetUserId = targetUserId
          ..targetDefinitionId = targetDefinitionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userListType: userListType,
        targetUserId: targetUserId,
        targetDefinitionId: targetDefinitionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserIdListStateNotifier,
      UserIdListState> createElement() {
    return _UserIdListStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserIdListStateNotifierProvider &&
        other.userListType == userListType &&
        other.targetUserId == targetUserId &&
        other.targetDefinitionId == targetDefinitionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userListType.hashCode);
    hash = _SystemHash.combine(hash, targetUserId.hashCode);
    hash = _SystemHash.combine(hash, targetDefinitionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserIdListStateNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<UserIdListState> {
  /// The parameter `userListType` of this provider.
  UserListType get userListType;

  /// The parameter `targetUserId` of this provider.
  String? get targetUserId;

  /// The parameter `targetDefinitionId` of this provider.
  String? get targetDefinitionId;
}

class _UserIdListStateNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserIdListStateNotifier,
        UserIdListState> with UserIdListStateNotifierRef {
  _UserIdListStateNotifierProviderElement(super.provider);

  @override
  UserListType get userListType =>
      (origin as UserIdListStateNotifierProvider).userListType;
  @override
  String? get targetUserId =>
      (origin as UserIdListStateNotifierProvider).targetUserId;
  @override
  String? get targetDefinitionId =>
      (origin as UserIdListStateNotifierProvider).targetDefinitionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
