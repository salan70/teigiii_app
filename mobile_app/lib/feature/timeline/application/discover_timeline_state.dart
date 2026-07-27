import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../../definition/application/definition_seed_store.dart';
import '../../definition/application/definition_state.dart';
import '../domain/discover_feed_entry.dart';
import '../domain/discover_feed_list_state.dart';
import '../repository/discover_timeline_repository.dart';

part 'discover_timeline_state.g.dart';

/// おすすめタイムラインのシード世代キー。
const _seedFeedKey = 'discoverTimeline';

/// おすすめタイムラインの一覧 state。
///
/// keepAlive: ホームタブの往復で一覧を維持する。シード参照の解放は
/// dispose 時の [DefinitionSeedStore.releaseFeed] と世代上限で行う。
@Riverpod(keepAlive: true)
class DiscoverTimelineStateNotifier extends _$DiscoverTimelineStateNotifier
    with FetchMoreMixin<DiscoverFeedListState> {
  @override
  FutureOr<DiscoverFeedListState> build() async {
    // store をキャプチャする。onDispose 内で ref.read すると
    // ProviderContainer.dispose 中に StateError になる。
    final store = ref.read(definitionSeedStoreProvider);
    ref.onDispose(() => store.releaseFeed(_seedFeedKey));
    return _fetch(cursor: null);
  }

  Future<DiscoverFeedListState> _fetch({required String? cursor}) async {
    final result = await ref
        .read(discoverTimelineRepositoryProvider)
        .fetchDiscoverTimeline(cursor);

    // 初回・refresh（cursor == null）はフィード世代を丸ごと置き換える。
    // fetchMore は追記のみ。
    ref.seedDefinitions(
      feedKey: _seedFeedKey,
      definitions: result.list.whereType<DiscoverFeedDefinitionEntry>().map(
        (entry) => entry.definition,
      ),
      isFirstFetch: cursor == null,
    );

    return result;
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () => _fetch(cursor: state.value!.nextCursor),
      mergeFunction: (currentData, newData) => DiscoverFeedListState(
        list: currentData.list + newData.list,
        nextCursor: newData.nextCursor,
        hasMore: newData.hasMore,
      ),
    );
  }
}
