// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_list_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionListStateNotifierHash() =>
    r'2e3a3914cd1d3fd39766b46f6ceca56a1a2c63ae';

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

abstract class _$DefinitionListStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Definition>> {
  late final DefinitionFeedType definitionFeedType;

  FutureOr<List<Definition>> build(
    DefinitionFeedType definitionFeedType,
  );
}

/// See also [DefinitionListStateNotifier].
@ProviderFor(DefinitionListStateNotifier)
const definitionListStateNotifierProvider = DefinitionListStateNotifierFamily();

/// See also [DefinitionListStateNotifier].
class DefinitionListStateNotifierFamily
    extends Family<AsyncValue<List<Definition>>> {
  /// See also [DefinitionListStateNotifier].
  const DefinitionListStateNotifierFamily();

  /// See also [DefinitionListStateNotifier].
  DefinitionListStateNotifierProvider call(
    DefinitionFeedType definitionFeedType,
  ) {
    return DefinitionListStateNotifierProvider(
      definitionFeedType,
    );
  }

  @override
  DefinitionListStateNotifierProvider getProviderOverride(
    covariant DefinitionListStateNotifierProvider provider,
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
  String? get name => r'definitionListStateNotifierProvider';
}

/// See also [DefinitionListStateNotifier].
class DefinitionListStateNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DefinitionListStateNotifier,
        List<Definition>> {
  /// See also [DefinitionListStateNotifier].
  DefinitionListStateNotifierProvider(
    DefinitionFeedType definitionFeedType,
  ) : this._internal(
          () => DefinitionListStateNotifier()
            ..definitionFeedType = definitionFeedType,
          from: definitionListStateNotifierProvider,
          name: r'definitionListStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$definitionListStateNotifierHash,
          dependencies: DefinitionListStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              DefinitionListStateNotifierFamily._allTransitiveDependencies,
          definitionFeedType: definitionFeedType,
        );

  DefinitionListStateNotifierProvider._internal(
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
    covariant DefinitionListStateNotifier notifier,
  ) {
    return notifier.build(
      definitionFeedType,
    );
  }

  @override
  Override overrideWith(DefinitionListStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: DefinitionListStateNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<DefinitionListStateNotifier,
      List<Definition>> createElement() {
    return _DefinitionListStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefinitionListStateNotifierProvider &&
        other.definitionFeedType == definitionFeedType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definitionFeedType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DefinitionListStateNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<Definition>> {
  /// The parameter `definitionFeedType` of this provider.
  DefinitionFeedType get definitionFeedType;
}

class _DefinitionListStateNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DefinitionListStateNotifier,
        List<Definition>> with DefinitionListStateNotifierRef {
  _DefinitionListStateNotifierProviderElement(super.provider);

  @override
  DefinitionFeedType get definitionFeedType =>
      (origin as DefinitionListStateNotifierProvider).definitionFeedType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
