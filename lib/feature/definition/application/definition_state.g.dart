// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionHash() => r'1d0dccf94285064ea083fe181f5447983f0b61ad';

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

/// See also [definition].
@ProviderFor(definition)
const definitionProvider = DefinitionFamily();

/// See also [definition].
class DefinitionFamily extends Family<AsyncValue<Definition>> {
  /// See also [definition].
  const DefinitionFamily();

  /// See also [definition].
  DefinitionProvider call(
    String definitionId,
  ) {
    return DefinitionProvider(
      definitionId,
    );
  }

  @override
  DefinitionProvider getProviderOverride(
    covariant DefinitionProvider provider,
  ) {
    return call(
      provider.definitionId,
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
  String? get name => r'definitionProvider';
}

/// See also [definition].
class DefinitionProvider extends AutoDisposeFutureProvider<Definition> {
  /// See also [definition].
  DefinitionProvider(
    String definitionId,
  ) : this._internal(
          (ref) => definition(
            ref as DefinitionRef,
            definitionId,
          ),
          from: definitionProvider,
          name: r'definitionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$definitionHash,
          dependencies: DefinitionFamily._dependencies,
          allTransitiveDependencies:
              DefinitionFamily._allTransitiveDependencies,
          definitionId: definitionId,
        );

  DefinitionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.definitionId,
  }) : super.internal();

  final String definitionId;

  @override
  Override overrideWith(
    FutureOr<Definition> Function(DefinitionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DefinitionProvider._internal(
        (ref) => create(ref as DefinitionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        definitionId: definitionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Definition> createElement() {
    return _DefinitionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefinitionProvider && other.definitionId == definitionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definitionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DefinitionRef on AutoDisposeFutureProviderRef<Definition> {
  /// The parameter `definitionId` of this provider.
  String get definitionId;
}

class _DefinitionProviderElement
    extends AutoDisposeFutureProviderElement<Definition> with DefinitionRef {
  _DefinitionProviderElement(super.provider);

  @override
  String get definitionId => (origin as DefinitionProvider).definitionId;
}

String _$definitionIdListHash() => r'c7c290dda533ef8427c9606d9501017ffed37cc7';

/// See also [definitionIdList].
@ProviderFor(definitionIdList)
const definitionIdListProvider = DefinitionIdListFamily();

/// See also [definitionIdList].
class DefinitionIdListFamily extends Family<AsyncValue<List<String>>> {
  /// See also [definitionIdList].
  const DefinitionIdListFamily();

  /// See also [definitionIdList].
  DefinitionIdListProvider call(
    DefinitionFeedType definitionFeedType,
  ) {
    return DefinitionIdListProvider(
      definitionFeedType,
    );
  }

  @override
  DefinitionIdListProvider getProviderOverride(
    covariant DefinitionIdListProvider provider,
  ) {
    return call(
      provider.definitionFeedType,
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
  String? get name => r'definitionIdListProvider';
}

/// See also [definitionIdList].
class DefinitionIdListProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [definitionIdList].
  DefinitionIdListProvider(
    DefinitionFeedType definitionFeedType,
  ) : this._internal(
          (ref) => definitionIdList(
            ref as DefinitionIdListRef,
            definitionFeedType,
          ),
          from: definitionIdListProvider,
          name: r'definitionIdListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$definitionIdListHash,
          dependencies: DefinitionIdListFamily._dependencies,
          allTransitiveDependencies:
              DefinitionIdListFamily._allTransitiveDependencies,
          definitionFeedType: definitionFeedType,
        );

  DefinitionIdListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.definitionFeedType,
  }) : super.internal();

  final DefinitionFeedType definitionFeedType;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(DefinitionIdListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DefinitionIdListProvider._internal(
        (ref) => create(ref as DefinitionIdListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        definitionFeedType: definitionFeedType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _DefinitionIdListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefinitionIdListProvider &&
        other.definitionFeedType == definitionFeedType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definitionFeedType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DefinitionIdListRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `definitionFeedType` of this provider.
  DefinitionFeedType get definitionFeedType;
}

class _DefinitionIdListProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with DefinitionIdListRef {
  _DefinitionIdListProviderElement(super.provider);

  @override
  DefinitionFeedType get definitionFeedType =>
      (origin as DefinitionIdListProvider).definitionFeedType;
}

String _$homeRecommendDefinitionIdListHash() =>
    r'3da0bde034a288db90819c023a08ee325be08c32';

/// See also [_homeRecommendDefinitionIdList].
@ProviderFor(_homeRecommendDefinitionIdList)
final _homeRecommendDefinitionIdListProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  _homeRecommendDefinitionIdList,
  name: r'_homeRecommendDefinitionIdListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeRecommendDefinitionIdListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _HomeRecommendDefinitionIdListRef
    = AutoDisposeFutureProviderRef<List<String>>;
String _$homeFollowingDefinitionIdListHash() =>
    r'380bbf9ee8427a2905d2de4127e8a430698a7ff6';

/// See also [_homeFollowingDefinitionIdList].
@ProviderFor(_homeFollowingDefinitionIdList)
final _homeFollowingDefinitionIdListProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  _homeFollowingDefinitionIdList,
  name: r'_homeFollowingDefinitionIdListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeFollowingDefinitionIdListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _HomeFollowingDefinitionIdListRef
    = AutoDisposeFutureProviderRef<List<String>>;
String _$mutedUserIdListHash() => r'98445cc723d89b92449cff8200b0ef59f2ad148c';

/// See also [_mutedUserIdList].
@ProviderFor(_mutedUserIdList)
final _mutedUserIdListProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  _mutedUserIdList,
  name: r'_mutedUserIdListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mutedUserIdListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _MutedUserIdListRef = AutoDisposeFutureProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
