import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../domain/word_list_state.dart';
import '../repository/fetch_word_list_repository.dart';

part 'word_list_state_by_initial.g.dart';

@Riverpod(keepAlive: true)
class WordListStateByInitialNotifier extends _$WordListStateByInitialNotifier
    with FetchMoreMixin<WordListState> {
  @override
  FutureOr<WordListState> build(String initial) async =>
      _fetchList(isFirstFetch: true);

  Future<WordListState> _fetchList({required bool isFirstFetch}) async {
    final cursor = isFirstFetch ? null : state.value!.nextCursor;

    return ref
        .read(fetchWordListRepositoryProvider)
        .fetchWordListStateByInitial(initial, cursor);
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () async => _fetchList(isFirstFetch: false),
      mergeFunction: (currentData, newData) => WordListState(
        list: currentData.list + newData.list,
        nextCursor: newData.nextCursor,
        hasMore: newData.hasMore,
      ),
    );
  }
}
