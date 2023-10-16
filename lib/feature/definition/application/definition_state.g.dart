// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionHash() => r'0451d407a1965ee9b93c15633cd1421fa86ea242';

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
class DefinitionProvider extends FutureProvider<Definition> {
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
  FutureProviderElement<Definition> createElement() {
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

mixin DefinitionRef on FutureProviderRef<Definition> {
  /// The parameter `definitionId` of this provider.
  String get definitionId;
}

class _DefinitionProviderElement extends FutureProviderElement<Definition>
    with DefinitionRef {
  _DefinitionProviderElement(super.provider);

  @override
  String get definitionId => (origin as DefinitionProvider).definitionId;
}

String _$definitionIdListHash() => r'237f5af4fe5a4d30becd75e428ee9ac2c6e2978d';

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
class DefinitionIdListProvider extends FutureProvider<List<String>> {
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
  FutureProviderElement<List<String>> createElement() {
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

mixin DefinitionIdListRef on FutureProviderRef<List<String>> {
  /// The parameter `definitionFeedType` of this provider.
  DefinitionFeedType get definitionFeedType;
}

class _DefinitionIdListProviderElement
    extends FutureProviderElement<List<String>> with DefinitionIdListRef {
  _DefinitionIdListProviderElement(super.provider);

  @override
  DefinitionFeedType get definitionFeedType =>
      (origin as DefinitionIdListProvider).definitionFeedType;
}

String _$homeRecommendDefinitionIdListHash() =>
    r'd7301310084fd9c3c21dacc33fa2e6d781dce7eb';

/// See also [_homeRecommendDefinitionIdList].
@ProviderFor(_homeRecommendDefinitionIdList)
final _homeRecommendDefinitionIdListProvider =
    FutureProvider<List<String>>.internal(
  _homeRecommendDefinitionIdList,
  name: r'_homeRecommendDefinitionIdListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeRecommendDefinitionIdListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _HomeRecommendDefinitionIdListRef = FutureProviderRef<List<String>>;
String _$homeFollowingDefinitionIdListHash() =>
    r'382e7456fd9367d5c3989f2ac8f17efd0bd4f3b5';

/// See also [_homeFollowingDefinitionIdList].
@ProviderFor(_homeFollowingDefinitionIdList)
final _homeFollowingDefinitionIdListProvider =
    FutureProvider<List<String>>.internal(
  _homeFollowingDefinitionIdList,
  name: r'_homeFollowingDefinitionIdListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeFollowingDefinitionIdListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _HomeFollowingDefinitionIdListRef = FutureProviderRef<List<String>>;
String _$mutedUserIdListHash() => r'b9e63bb00ebf1bf4110ea144e0f5c8f70da7ee5a';

/// See also [_mutedUserIdList].
@ProviderFor(_mutedUserIdList)
final _mutedUserIdListProvider = FutureProvider<List<String>>.internal(
  _mutedUserIdList,
  name: r'_mutedUserIdListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mutedUserIdListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _MutedUserIdListRef = FutureProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
