import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../../definition/application/definition_seed_store.dart';
import '../../definition/domain/definition.dart';
import '../domain/discover_feed_list_state.dart';
import '../repository/discover_timeline_repository.dart';

part 'discover_timeline_state.g.dart';

@Riverpod(keepAlive: true)
class DiscoverTimelineStateNotifier extends _$DiscoverTimelineStateNotifier
    with FetchMoreMixin<DiscoverFeedListState> {
  @override
  FutureOr<DiscoverFeedListState> build() async => _fetch(cursor: null);

  Future<DiscoverFeedListState> _fetch({required String? cursor}) async {
    final result = await ref
        .read(discoverTimelineRepositoryProvider)
        .fetchDiscoverTimeline(cursor);

    // 各 tile が定義を再取得しないよう、取得済みの定義をシードとして投入する。
    ref
        .read(definitionSeedStoreProvider)
        .seedAll(result.list.whereType<Definition>());

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
