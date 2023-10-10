// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionListNotifierHash() =>
    r'35d5db4688e3fa7e24be4649ce264d9faa5ef23c';

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

abstract class _$DefinitionListNotifier
    extends BuildlessAsyncNotifier<List<Definition>> {
  late final DefinitionFeedType definitionFeedType;

  FutureOr<List<Definition>> build(
    DefinitionFeedType definitionFeedType,
  );
}

/// See also [DefinitionListNotifier].
@ProviderFor(DefinitionListNotifier)
const definitionListNotifierProvider = DefinitionListNotifierFamily();

/// See also [DefinitionListNotifier].
class DefinitionListNotifierFamily
    extends Family<AsyncValue<List<Definition>>> {
  /// See also [DefinitionListNotifier].
  const DefinitionListNotifierFamily();

  /// See also [DefinitionListNotifier].
  DefinitionListNotifierProvider call(
    DefinitionFeedType definitionFeedType,
  ) {
    return DefinitionListNotifierProvider(
      definitionFeedType,
    );
  }

  @override
  DefinitionListNotifierProvider getProviderOverride(
    covariant DefinitionListNotifierProvider provider,
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
  String? get name => r'definitionListNotifierProvider';
}

/// See also [DefinitionListNotifier].
class DefinitionListNotifierProvider extends AsyncNotifierProviderImpl<
    DefinitionListNotifier, List<Definition>> {
  /// See also [DefinitionListNotifier].
  DefinitionListNotifierProvider(
    DefinitionFeedType definitionFeedType,
  ) : this._internal(
          () =>
              DefinitionListNotifier()..definitionFeedType = definitionFeedType,
          from: definitionListNotifierProvider,
          name: r'definitionListNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$definitionListNotifierHash,
          dependencies: DefinitionListNotifierFamily._dependencies,
          allTransitiveDependencies:
              DefinitionListNotifierFamily._allTransitiveDependencies,
          definitionFeedType: definitionFeedType,
        );

  DefinitionListNotifierProvider._internal(
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
  FutureOr<List<Definition>> runNotifierBuild(
    covariant DefinitionListNotifier notifier,
  ) {
    return notifier.build(
      definitionFeedType,
    );
  }

  @override
  Override overrideWith(DefinitionListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: DefinitionListNotifierProvider._internal(
        () => create()..definitionFeedType = definitionFeedType,
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
  AsyncNotifierProviderElement<DefinitionListNotifier, List<Definition>>
      createElement() {
    return _DefinitionListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefinitionListNotifierProvider &&
        other.definitionFeedType == definitionFeedType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definitionFeedType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DefinitionListNotifierRef on AsyncNotifierProviderRef<List<Definition>> {
  /// The parameter `definitionFeedType` of this provider.
  DefinitionFeedType get definitionFeedType;
}

class _DefinitionListNotifierProviderElement
    extends AsyncNotifierProviderElement<DefinitionListNotifier,
        List<Definition>> with DefinitionListNotifierRef {
  _DefinitionListNotifierProviderElement(super.provider);

  @override
  DefinitionFeedType get definitionFeedType =>
      (origin as DefinitionListNotifierProvider).definitionFeedType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
