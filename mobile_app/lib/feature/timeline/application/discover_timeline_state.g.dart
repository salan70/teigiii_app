// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_timeline_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$discoverTimelineStateNotifierHash() =>
    r'ccd24d8b7566882716fc5eb327754cd411e04ab0';

/// おすすめタイムラインの一覧 state。
///
/// keepAlive: ホームタブの往復で一覧を維持する。シード参照の解放は
/// dispose 時の [DefinitionSeedStore.releaseFeed] と世代上限で行う。
///
/// Copied from [DiscoverTimelineStateNotifier].
@ProviderFor(DiscoverTimelineStateNotifier)
final discoverTimelineStateNotifierProvider =
    AsyncNotifierProvider<
      DiscoverTimelineStateNotifier,
      DiscoverFeedListState
    >.internal(
      DiscoverTimelineStateNotifier.new,
      name: r'discoverTimelineStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$discoverTimelineStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DiscoverTimelineStateNotifier = AsyncNotifier<DiscoverFeedListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
