// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userIdSearchByPublicIdHash() =>
    r'f81f720e093a33037ff579fb4780abdd4940d442';

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

String _$userSearchResultNotifierHash() =>
    r'433cd803795fd9a009977f0665b8c2661d18ab52';

abstract class _$UserSearchResultNotifier
    extends BuildlessAsyncNotifier<UserSearchResultState> {
  late final String query;

  FutureOr<UserSearchResultState> build(
    String query,
  );
}

/// See also [UserSearchResultNotifier].
@ProviderFor(UserSearchResultNotifier)
const userSearchResultNotifierProvider = UserSearchResultNotifierFamily();

/// See also [UserSearchResultNotifier].
class UserSearchResultNotifierFamily
    extends Family<AsyncValue<UserSearchResultState>> {
  /// See also [UserSearchResultNotifier].
  const UserSearchResultNotifierFamily();

  /// See also [UserSearchResultNotifier].
  UserSearchResultNotifierProvider call(
    String query,
  ) {
    return UserSearchResultNotifierProvider(
      query,
    );
  }

  @override
  UserSearchResultNotifierProvider getProviderOverride(
    covariant UserSearchResultNotifierProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'userSearchResultNotifierProvider';
}

/// See also [UserSearchResultNotifier].
class UserSearchResultNotifierProvider extends AsyncNotifierProviderImpl<
    UserSearchResultNotifier, UserSearchResultState> {
  /// See also [UserSearchResultNotifier].
  UserSearchResultNotifierProvider(
    String query,
  ) : this._internal(
          () => UserSearchResultNotifier()..query = query,
          from: userSearchResultNotifierProvider,
          name: r'userSearchResultNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userSearchResultNotifierHash,
          dependencies: UserSearchResultNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserSearchResultNotifierFamily._allTransitiveDependencies,
          query: query,
        );

  UserSearchResultNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  FutureOr<UserSearchResultState> runNotifierBuild(
    covariant UserSearchResultNotifier notifier,
  ) {
    return notifier.build(
      query,
    );
  }

  @override
  Override overrideWith(UserSearchResultNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserSearchResultNotifierProvider._internal(
        () => create()..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<UserSearchResultNotifier, UserSearchResultState>
      createElement() {
    return _UserSearchResultNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserSearchResultNotifierProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserSearchResultNotifierRef
    on AsyncNotifierProviderRef<UserSearchResultState> {
  /// The parameter `query` of this provider.
  String get query;
}

class _UserSearchResultNotifierProviderElement
    extends AsyncNotifierProviderElement<UserSearchResultNotifier,
        UserSearchResultState> with UserSearchResultNotifierRef {
  _UserSearchResultNotifierProviderElement(super.provider);

  @override
  String get query => (origin as UserSearchResultNotifierProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
