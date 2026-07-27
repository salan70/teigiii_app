import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../../definition/application/definition_seed_store.dart';
import '../../definition/application/definition_state.dart';
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

    final definitions = result.list.whereType<Definition>().toList();
    final store = ref.read(definitionSeedStoreProvider);

    // 初回・refresh（cursor == null）はフィード世代を丸ごと置き換える。
    // fetchMore は追記のみ。いずれの場合も seed 更新後に
    // definitionProvider を invalidate し、購読中の tile へ反映する。
    final idsToInvalidate = <String>{};
    if (cursor == null) {
      idsToInvalidate
        ..addAll(store.replaceAll(definitions))
        ..addAll(definitions.map((definition) => definition.id));
    } else {
      store.seedAll(definitions);
      idsToInvalidate.addAll(definitions.map((definition) => definition.id));
    }

    for (final id in idsToInvalidate) {
      ref.invalidate(definitionProvider(id));
    }

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
