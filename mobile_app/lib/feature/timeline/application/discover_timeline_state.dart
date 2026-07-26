import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../domain/discover_feed_list_state.dart';
import '../repository/discover_timeline_repository.dart';

part 'discover_timeline_state.g.dart';

@Riverpod(keepAlive: true)
class DiscoverTimelineStateNotifier extends _$DiscoverTimelineStateNotifier
    with FetchMoreMixin<DiscoverFeedListState> {
  @override
  FutureOr<DiscoverFeedListState> build() async => _fetch(cursor: null);

  Future<DiscoverFeedListState> _fetch({required String? cursor}) => ref
      .read(discoverTimelineRepositoryProvider)
      .fetchDiscoverTimeline(cursor);

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
