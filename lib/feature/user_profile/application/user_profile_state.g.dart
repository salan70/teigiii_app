// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProfileHash() => r'a7743a0223bb6af5424453f27bc0e2acf027afb3';

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

/// See also [userProfile].
@ProviderFor(userProfile)
const userProfileProvider = UserProfileFamily();

/// See also [userProfile].
class UserProfileFamily extends Family<AsyncValue<UserProfile>> {
  /// See also [userProfile].
  const UserProfileFamily();

  /// See also [userProfile].
  UserProfileProvider call(
    String userId,
  ) {
    return UserProfileProvider(
      userId,
    );
  }

  @override
  UserProfileProvider getProviderOverride(
    covariant UserProfileProvider provider,
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
  String? get name => r'userProfileProvider';
}

/// See also [userProfile].
class UserProfileProvider extends AutoDisposeFutureProvider<UserProfile> {
  /// See also [userProfile].
  UserProfileProvider(
    String userId,
  ) : this._internal(
          (ref) => userProfile(
            ref as UserProfileRef,
            userId,
          ),
          from: userProfileProvider,
          name: r'userProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userProfileHash,
          dependencies: UserProfileFamily._dependencies,
          allTransitiveDependencies:
              UserProfileFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserProfileProvider._internal(
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
    FutureOr<UserProfile> Function(UserProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProfileProvider._internal(
        (ref) => create(ref as UserProfileRef),
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
  AutoDisposeFutureProviderElement<UserProfile> createElement() {
    return _UserProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserProfileRef on AutoDisposeFutureProviderRef<UserProfile> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserProfileProviderElement
    extends AutoDisposeFutureProviderElement<UserProfile> with UserProfileRef {
  _UserProfileProviderElement(super.provider);

  @override
  String get userId => (origin as UserProfileProvider).userId;
}

String _$userIdSearchByPublicIdHash() =>
    r'86648bcf5976ad09545803334dc02975c5c4f268';

/// See also [userIdSearchByPublicId].
@ProviderFor(userIdSearchByPublicId)
const userIdSearchByPublicIdProvider = UserIdSearchByPublicIdFamily();

/// See also [userIdSearchByPublicId].
class UserIdSearchByPublicIdFamily extends Family<AsyncValue<String?>> {
  /// See also [userIdSearchByPublicId].
  const UserIdSearchByPublicIdFamily();

  /// See also [userIdSearchByPublicId].
  UserIdSearchByPublicIdProvider call(
    String publicId,
  ) {
    return UserIdSearchByPublicIdProvider(
      publicId,
    );
  }

  @override
  UserIdSearchByPublicIdProvider getProviderOverride(
    covariant UserIdSearchByPublicIdProvider provider,
  ) {
    return call(
      provider.publicId,
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
  String? get name => r'userIdSearchByPublicIdProvider';
}

/// See also [userIdSearchByPublicId].
class UserIdSearchByPublicIdProvider
    extends AutoDisposeFutureProvider<String?> {
  /// See also [userIdSearchByPublicId].
  UserIdSearchByPublicIdProvider(
    String publicId,
  ) : this._internal(
          (ref) => userIdSearchByPublicId(
            ref as UserIdSearchByPublicIdRef,
            publicId,
          ),
          from: userIdSearchByPublicIdProvider,
          name: r'userIdSearchByPublicIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userIdSearchByPublicIdHash,
          dependencies: UserIdSearchByPublicIdFamily._dependencies,
          allTransitiveDependencies:
              UserIdSearchByPublicIdFamily._allTransitiveDependencies,
          publicId: publicId,
        );

  UserIdSearchByPublicIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.publicId,
  }) : super.internal();

  final String publicId;

  @override
  Override overrideWith(
    FutureOr<String?> Function(UserIdSearchByPublicIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserIdSearchByPublicIdProvider._internal(
        (ref) => create(ref as UserIdSearchByPublicIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        publicId: publicId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _UserIdSearchByPublicIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserIdSearchByPublicIdProvider &&
        other.publicId == publicId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, publicId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserIdSearchByPublicIdRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `publicId` of this provider.
  String get publicId;
}

class _UserIdSearchByPublicIdProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with UserIdSearchByPublicIdRef {
  _UserIdSearchByPublicIdProviderElement(super.provider);

  @override
  String get publicId => (origin as UserIdSearchByPublicIdProvider).publicId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
