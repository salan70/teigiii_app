// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_follow_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followCountHash() => r'17ba6de4c566b77df797082d93c76bd14add16d1';

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

/// See also [followCount].
@ProviderFor(followCount)
const followCountProvider = FollowCountFamily();

/// See also [followCount].
class FollowCountFamily extends Family<AsyncValue<FollowCount>> {
  /// See also [followCount].
  const FollowCountFamily();

  /// See also [followCount].
  FollowCountProvider call(
    String userId,
  ) {
    return FollowCountProvider(
      userId,
    );
  }

  @override
  FollowCountProvider getProviderOverride(
    covariant FollowCountProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'followCountProvider';
}

/// See also [followCount].
class FollowCountProvider extends AutoDisposeFutureProvider<FollowCount> {
  /// See also [followCount].
  FollowCountProvider(
    String userId,
  ) : this._internal(
          (ref) => followCount(
            ref as FollowCountRef,
            userId,
          ),
          from: followCountProvider,
          name: r'followCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$followCountHash,
          dependencies: FollowCountFamily._dependencies,
          allTransitiveDependencies:
              FollowCountFamily._allTransitiveDependencies,
          userId: userId,
        );

  FollowCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<FollowCount> Function(FollowCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FollowCountProvider._internal(
        (ref) => create(ref as FollowCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FollowCount> createElement() {
    return _FollowCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowCountProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FollowCountRef on AutoDisposeFutureProviderRef<FollowCount> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _FollowCountProviderElement
    extends AutoDisposeFutureProviderElement<FollowCount> with FollowCountRef {
  _FollowCountProviderElement(super.provider);

  @override
  String get userId => (origin as FollowCountProvider).userId;
}

String _$isFollowingHash() => r'3a25ba5e47b330d5f84f70d1e11e8a5a55640529';

/// See also [isFollowing].
@ProviderFor(isFollowing)
const isFollowingProvider = IsFollowingFamily();

/// See also [isFollowing].
class IsFollowingFamily extends Family<AsyncValue<bool>> {
  /// See also [isFollowing].
  const IsFollowingFamily();

  /// See also [isFollowing].
  IsFollowingProvider call(
    String targetUserId,
  ) {
    return IsFollowingProvider(
      targetUserId,
    );
  }

  @override
  IsFollowingProvider getProviderOverride(
    covariant IsFollowingProvider provider,
  ) {
    return call(
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
  String? get name => r'isFollowingProvider';
}

/// See also [isFollowing].
class IsFollowingProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [isFollowing].
  IsFollowingProvider(
    String targetUserId,
  ) : this._internal(
          (ref) => isFollowing(
            ref as IsFollowingRef,
            targetUserId,
          ),
          from: isFollowingProvider,
          name: r'isFollowingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isFollowingHash,
          dependencies: IsFollowingFamily._dependencies,
          allTransitiveDependencies:
              IsFollowingFamily._allTransitiveDependencies,
          targetUserId: targetUserId,
        );

  IsFollowingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.targetUserId,
  }) : super.internal();

  final String targetUserId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsFollowingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsFollowingProvider._internal(
        (ref) => create(ref as IsFollowingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        targetUserId: targetUserId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsFollowingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsFollowingProvider && other.targetUserId == targetUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, targetUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsFollowingRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `targetUserId` of this provider.
  String get targetUserId;
}

class _IsFollowingProviderElement extends AutoDisposeFutureProviderElement<bool>
    with IsFollowingRef {
  _IsFollowingProviderElement(super.provider);

  @override
  String get targetUserId => (origin as IsFollowingProvider).targetUserId;
}

String _$followingIdListHash() => r'89b4adb2e2544be84286f1dff92397cefc8f04a1';

/// See also [followingIdList].
@ProviderFor(followingIdList)
const followingIdListProvider = FollowingIdListFamily();

/// See also [followingIdList].
class FollowingIdListFamily extends Family<AsyncValue<List<String>>> {
  /// See also [followingIdList].
  const FollowingIdListFamily();

  /// See also [followingIdList].
  FollowingIdListProvider call(
    String targetUserId,
  ) {
    return FollowingIdListProvider(
      targetUserId,
    );
  }

  @override
  FollowingIdListProvider getProviderOverride(
    covariant FollowingIdListProvider provider,
  ) {
    return call(
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
  String? get name => r'followingIdListProvider';
}

/// See also [followingIdList].
class FollowingIdListProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [followingIdList].
  FollowingIdListProvider(
    String targetUserId,
  ) : this._internal(
          (ref) => followingIdList(
            ref as FollowingIdListRef,
            targetUserId,
          ),
          from: followingIdListProvider,
          name: r'followingIdListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$followingIdListHash,
          dependencies: FollowingIdListFamily._dependencies,
          allTransitiveDependencies:
              FollowingIdListFamily._allTransitiveDependencies,
          targetUserId: targetUserId,
        );

  FollowingIdListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.targetUserId,
  }) : super.internal();

  final String targetUserId;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(FollowingIdListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FollowingIdListProvider._internal(
        (ref) => create(ref as FollowingIdListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        targetUserId: targetUserId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _FollowingIdListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowingIdListProvider &&
        other.targetUserId == targetUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, targetUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FollowingIdListRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `targetUserId` of this provider.
  String get targetUserId;
}

class _FollowingIdListProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with FollowingIdListRef {
  _FollowingIdListProviderElement(super.provider);

  @override
  String get targetUserId => (origin as FollowingIdListProvider).targetUserId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
