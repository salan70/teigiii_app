// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_list_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionListStateNotifierHash() =>
    r'db04eee695d378dc13d4c33a2ab9d3bdbee274cf';

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
    extends BuildlessAsyncNotifier<DefinitionListState> {
  late final DefinitionFeedType definitionFeedType;
  late final String? wordId;
  late final String? targetUserId;
  late final InitialSubGroup? initialSubGroup;

  FutureOr<DefinitionListState> build(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
    InitialSubGroup? initialSubGroup,
  });
}

/// See also [DefinitionListStateNotifier].
@ProviderFor(DefinitionListStateNotifier)
const definitionListStateNotifierProvider = DefinitionListStateNotifierFamily();

/// See also [DefinitionListStateNotifier].
class DefinitionListStateNotifierFamily
    extends Family<AsyncValue<DefinitionListState>> {
  /// See also [DefinitionListStateNotifier].
  const DefinitionListStateNotifierFamily();

  /// See also [DefinitionListStateNotifier].
  DefinitionListStateNotifierProvider call(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
    InitialSubGroup? initialSubGroup,
  }) {
    return DefinitionListStateNotifierProvider(
      definitionFeedType,
      wordId: wordId,
      targetUserId: targetUserId,
      initialSubGroup: initialSubGroup,
    );
  }

  @override
  DefinitionListStateNotifierProvider getProviderOverride(
    covariant DefinitionListStateNotifierProvider provider,
  ) {
    return call(
      provider.definitionFeedType,
      wordId: provider.wordId,
      targetUserId: provider.targetUserId,
      initialSubGroup: provider.initialSubGroup,
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
    extends
        AsyncNotifierProviderImpl<
          DefinitionListStateNotifier,
          DefinitionListState
        > {
  /// See also [DefinitionListStateNotifier].
  DefinitionListStateNotifierProvider(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
    InitialSubGroup? initialSubGroup,
  }) : this._internal(
         () => DefinitionListStateNotifier()
           ..definitionFeedType = definitionFeedType
           ..wordId = wordId
           ..targetUserId = targetUserId
           ..initialSubGroup = initialSubGroup,
         from: definitionListStateNotifierProvider,
         name: r'definitionListStateNotifierProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$definitionListStateNotifierHash,
         dependencies: DefinitionListStateNotifierFamily._dependencies,
         allTransitiveDependencies:
             DefinitionListStateNotifierFamily._allTransitiveDependencies,
         definitionFeedType: definitionFeedType,
         wordId: wordId,
         targetUserId: targetUserId,
         initialSubGroup: initialSubGroup,
       );

  DefinitionListStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.definitionFeedType,
    required this.wordId,
    required this.targetUserId,
    required this.initialSubGroup,
  }) : super.internal();

  final DefinitionFeedType definitionFeedType;
  final String? wordId;
  final String? targetUserId;
  final InitialSubGroup? initialSubGroup;

  @override
  FutureOr<DefinitionListState> runNotifierBuild(
    covariant DefinitionListStateNotifier notifier,
  ) {
    return notifier.build(
      definitionFeedType,
      wordId: wordId,
      targetUserId: targetUserId,
      initialSubGroup: initialSubGroup,
    );
  }

  @override
  Override overrideWith(DefinitionListStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: DefinitionListStateNotifierProvider._internal(
        () => create()
          ..definitionFeedType = definitionFeedType
          ..wordId = wordId
          ..targetUserId = targetUserId
          ..initialSubGroup = initialSubGroup,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        definitionFeedType: definitionFeedType,
        wordId: wordId,
        targetUserId: targetUserId,
        initialSubGroup: initialSubGroup,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<DefinitionListStateNotifier, DefinitionListState>
  createElement() {
    return _DefinitionListStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefinitionListStateNotifierProvider &&
        other.definitionFeedType == definitionFeedType &&
        other.wordId == wordId &&
        other.targetUserId == targetUserId &&
        other.initialSubGroup == initialSubGroup;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definitionFeedType.hashCode);
    hash = _SystemHash.combine(hash, wordId.hashCode);
    hash = _SystemHash.combine(hash, targetUserId.hashCode);
    hash = _SystemHash.combine(hash, initialSubGroup.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DefinitionListStateNotifierRef
    on AsyncNotifierProviderRef<DefinitionListState> {
  /// The parameter `definitionFeedType` of this provider.
  DefinitionFeedType get definitionFeedType;

  /// The parameter `wordId` of this provider.
  String? get wordId;

  /// The parameter `targetUserId` of this provider.
  String? get targetUserId;

  /// The parameter `initialSubGroup` of this provider.
  InitialSubGroup? get initialSubGroup;
}

class _DefinitionListStateNotifierProviderElement
    extends
        AsyncNotifierProviderElement<
          DefinitionListStateNotifier,
          DefinitionListState
        >
    with DefinitionListStateNotifierRef {
  _DefinitionListStateNotifierProviderElement(super.provider);

  @override
  DefinitionFeedType get definitionFeedType =>
      (origin as DefinitionListStateNotifierProvider).definitionFeedType;
  @override
  String? get wordId => (origin as DefinitionListStateNotifierProvider).wordId;
  @override
  String? get targetUserId =>
      (origin as DefinitionListStateNotifierProvider).targetUserId;
  @override
  InitialSubGroup? get initialSubGroup =>
      (origin as DefinitionListStateNotifierProvider).initialSubGroup;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
