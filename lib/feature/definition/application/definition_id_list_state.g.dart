// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_id_list_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionIdListStateNotifierHash() =>
    r'ad746c8cbe7521c5d129feb8a5f9530852d2aa45';

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

abstract class _$DefinitionIdListStateNotifier
    extends BuildlessAsyncNotifier<DefinitionIdListState> {
  late final DefinitionFeedType definitionFeedType;
  late final String? wordId;

  FutureOr<DefinitionIdListState> build(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
  });
}

/// See also [DefinitionIdListStateNotifier].
@ProviderFor(DefinitionIdListStateNotifier)
const definitionIdListStateNotifierProvider =
    DefinitionIdListStateNotifierFamily();

/// See also [DefinitionIdListStateNotifier].
class DefinitionIdListStateNotifierFamily
    extends Family<AsyncValue<DefinitionIdListState>> {
  /// See also [DefinitionIdListStateNotifier].
  const DefinitionIdListStateNotifierFamily();

  /// See also [DefinitionIdListStateNotifier].
  DefinitionIdListStateNotifierProvider call(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
  }) {
    return DefinitionIdListStateNotifierProvider(
      definitionFeedType,
      wordId: wordId,
    );
  }

  @override
  DefinitionIdListStateNotifierProvider getProviderOverride(
    covariant DefinitionIdListStateNotifierProvider provider,
  ) {
    return call(
      provider.definitionFeedType,
      wordId: provider.wordId,
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
  String? get name => r'definitionIdListStateNotifierProvider';
}

/// See also [DefinitionIdListStateNotifier].
class DefinitionIdListStateNotifierProvider extends AsyncNotifierProviderImpl<
    DefinitionIdListStateNotifier, DefinitionIdListState> {
  /// See also [DefinitionIdListStateNotifier].
  DefinitionIdListStateNotifierProvider(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
  }) : this._internal(
          () => DefinitionIdListStateNotifier()
            ..definitionFeedType = definitionFeedType
            ..wordId = wordId,
          from: definitionIdListStateNotifierProvider,
          name: r'definitionIdListStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$definitionIdListStateNotifierHash,
          dependencies: DefinitionIdListStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              DefinitionIdListStateNotifierFamily._allTransitiveDependencies,
          definitionFeedType: definitionFeedType,
          wordId: wordId,
        );

  DefinitionIdListStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.definitionFeedType,
    required this.wordId,
  }) : super.internal();

  final DefinitionFeedType definitionFeedType;
  final String? wordId;

  @override
  FutureOr<DefinitionIdListState> runNotifierBuild(
    covariant DefinitionIdListStateNotifier notifier,
  ) {
    return notifier.build(
      definitionFeedType,
      wordId: wordId,
    );
  }

  @override
  Override overrideWith(DefinitionIdListStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: DefinitionIdListStateNotifierProvider._internal(
        () => create()
          ..definitionFeedType = definitionFeedType
          ..wordId = wordId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        definitionFeedType: definitionFeedType,
        wordId: wordId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<DefinitionIdListStateNotifier,
      DefinitionIdListState> createElement() {
    return _DefinitionIdListStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefinitionIdListStateNotifierProvider &&
        other.definitionFeedType == definitionFeedType &&
        other.wordId == wordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definitionFeedType.hashCode);
    hash = _SystemHash.combine(hash, wordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DefinitionIdListStateNotifierRef
    on AsyncNotifierProviderRef<DefinitionIdListState> {
  /// The parameter `definitionFeedType` of this provider.
  DefinitionFeedType get definitionFeedType;

  /// The parameter `wordId` of this provider.
  String? get wordId;
}

class _DefinitionIdListStateNotifierProviderElement
    extends AsyncNotifierProviderElement<DefinitionIdListStateNotifier,
        DefinitionIdListState> with DefinitionIdListStateNotifierRef {
  _DefinitionIdListStateNotifierProviderElement(super.provider);

  @override
  DefinitionFeedType get definitionFeedType =>
      (origin as DefinitionIdListStateNotifierProvider).definitionFeedType;
  @override
  String? get wordId =>
      (origin as DefinitionIdListStateNotifierProvider).wordId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
