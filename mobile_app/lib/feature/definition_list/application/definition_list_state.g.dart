// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_list_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$definitionListStateNotifierHash() =>
    r'20be3cd16b41e0a4b4e0a26a550ce82ecd286f86';

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

  FutureOr<DefinitionListState> build(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
  });
}

/// 定義フィードの一覧 state。
///
/// keepAlive: ホームの TabBarView など、一時的に unwatch されても
/// 一覧・スクロール位置を維持するため。シード参照の解放は
/// [DefinitionSeedStore.releaseFeed]（dispose / 世代上限）で行う。
///
/// Copied from [DefinitionListStateNotifier].
@ProviderFor(DefinitionListStateNotifier)
const definitionListStateNotifierProvider = DefinitionListStateNotifierFamily();

/// 定義フィードの一覧 state。
///
/// keepAlive: ホームの TabBarView など、一時的に unwatch されても
/// 一覧・スクロール位置を維持するため。シード参照の解放は
/// [DefinitionSeedStore.releaseFeed]（dispose / 世代上限）で行う。
///
/// Copied from [DefinitionListStateNotifier].
class DefinitionListStateNotifierFamily
    extends Family<AsyncValue<DefinitionListState>> {
  /// 定義フィードの一覧 state。
  ///
  /// keepAlive: ホームの TabBarView など、一時的に unwatch されても
  /// 一覧・スクロール位置を維持するため。シード参照の解放は
  /// [DefinitionSeedStore.releaseFeed]（dispose / 世代上限）で行う。
  ///
  /// Copied from [DefinitionListStateNotifier].
  const DefinitionListStateNotifierFamily();

  /// 定義フィードの一覧 state。
  ///
  /// keepAlive: ホームの TabBarView など、一時的に unwatch されても
  /// 一覧・スクロール位置を維持するため。シード参照の解放は
  /// [DefinitionSeedStore.releaseFeed]（dispose / 世代上限）で行う。
  ///
  /// Copied from [DefinitionListStateNotifier].
  DefinitionListStateNotifierProvider call(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
  }) {
    return DefinitionListStateNotifierProvider(
      definitionFeedType,
      wordId: wordId,
      targetUserId: targetUserId,
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

/// 定義フィードの一覧 state。
///
/// keepAlive: ホームの TabBarView など、一時的に unwatch されても
/// 一覧・スクロール位置を維持するため。シード参照の解放は
/// [DefinitionSeedStore.releaseFeed]（dispose / 世代上限）で行う。
///
/// Copied from [DefinitionListStateNotifier].
class DefinitionListStateNotifierProvider
    extends
        AsyncNotifierProviderImpl<
          DefinitionListStateNotifier,
          DefinitionListState
        > {
  /// 定義フィードの一覧 state。
  ///
  /// keepAlive: ホームの TabBarView など、一時的に unwatch されても
  /// 一覧・スクロール位置を維持するため。シード参照の解放は
  /// [DefinitionSeedStore.releaseFeed]（dispose / 世代上限）で行う。
  ///
  /// Copied from [DefinitionListStateNotifier].
  DefinitionListStateNotifierProvider(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
  }) : this._internal(
         () => DefinitionListStateNotifier()
           ..definitionFeedType = definitionFeedType
           ..wordId = wordId
           ..targetUserId = targetUserId,
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
  }) : super.internal();

  final DefinitionFeedType definitionFeedType;
  final String? wordId;
  final String? targetUserId;

  @override
  FutureOr<DefinitionListState> runNotifierBuild(
    covariant DefinitionListStateNotifier notifier,
  ) {
    return notifier.build(
      definitionFeedType,
      wordId: wordId,
      targetUserId: targetUserId,
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
          ..targetUserId = targetUserId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        definitionFeedType: definitionFeedType,
        wordId: wordId,
        targetUserId: targetUserId,
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
        other.targetUserId == targetUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definitionFeedType.hashCode);
    hash = _SystemHash.combine(hash, wordId.hashCode);
    hash = _SystemHash.combine(hash, targetUserId.hashCode);

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
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
