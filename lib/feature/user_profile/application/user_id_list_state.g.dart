// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_id_list_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userIdListStateNotifierHash() =>
    r'4a79769703e34438db091d7eecb4028f232e9732';

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
    extends BuildlessAsyncNotifier<UserIdListState> {
  late final UserListType userListType;
  late final String targetUserId;

  FutureOr<UserIdListState> build(
    UserListType userListType,
    String targetUserId,
  );
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
    UserListType userListType,
    String targetUserId,
  ) {
    return UserIdListStateNotifierProvider(
      userListType,
      targetUserId,
    );
  }

  @override
  UserIdListStateNotifierProvider getProviderOverride(
    covariant UserIdListStateNotifierProvider provider,
  ) {
    return call(
      provider.userListType,
      provider.targetUserId,
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
class UserIdListStateNotifierProvider extends AsyncNotifierProviderImpl<
    UserIdListStateNotifier, UserIdListState> {
  /// See also [UserIdListStateNotifier].
  UserIdListStateNotifierProvider(
    UserListType userListType,
    String targetUserId,
  ) : this._internal(
          () => UserIdListStateNotifier()
            ..userListType = userListType
            ..targetUserId = targetUserId,
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
  }) : super.internal();

  final UserListType userListType;
  final String targetUserId;

  @override
  FutureOr<UserIdListState> runNotifierBuild(
    covariant UserIdListStateNotifier notifier,
  ) {
    return notifier.build(
      userListType,
      targetUserId,
    );
  }

  @override
  Override overrideWith(UserIdListStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserIdListStateNotifierProvider._internal(
        () => create()
          ..userListType = userListType
          ..targetUserId = targetUserId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userListType: userListType,
        targetUserId: targetUserId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<UserIdListStateNotifier, UserIdListState>
      createElement() {
    return _UserIdListStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserIdListStateNotifierProvider &&
        other.userListType == userListType &&
        other.targetUserId == targetUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userListType.hashCode);
    hash = _SystemHash.combine(hash, targetUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserIdListStateNotifierRef on AsyncNotifierProviderRef<UserIdListState> {
  /// The parameter `userListType` of this provider.
  UserListType get userListType;

  /// The parameter `targetUserId` of this provider.
  String get targetUserId;
}

class _UserIdListStateNotifierProviderElement
    extends AsyncNotifierProviderElement<UserIdListStateNotifier,
        UserIdListState> with UserIdListStateNotifierRef {
  _UserIdListStateNotifierProviderElement(super.provider);

  @override
  UserListType get userListType =>
      (origin as UserIdListStateNotifierProvider).userListType;
  @override
  String get targetUserId =>
      (origin as UserIdListStateNotifierProvider).targetUserId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
