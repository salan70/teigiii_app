import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../domain/word_list_state.dart';
import '../repository/word_repository.dart';

part 'word_list_state.g.dart';

@riverpod
class WordListStateNotifier extends _$WordListStateNotifier
    with FetchMoreMixin<WordListState> {
  @override
  FutureOr<WordListState> build(
    String initial,
  ) async {
    return await ref
        .read(wordRepositoryProvider)
        .fetchWordDocListByInitialFirst(initial);
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () =>
          ref.read(wordRepositoryProvider).fetchWordDocListByInitialMore(
                initial,
                state.value!.lastReadQueryDocumentSnapshot!,
              ),
      mergeFunction: (currentData, newData) => WordListState(
        wordList: currentData.wordList + newData.wordList,
        lastReadQueryDocumentSnapshot: newData.lastReadQueryDocumentSnapshot,
        hasMore: newData.hasMore,
      ),
    );
  }
}
