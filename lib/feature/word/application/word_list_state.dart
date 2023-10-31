import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../domain/word_list_state.dart';
import '../repository/word_repository.dart';
import 'user_private_word_state.dart';

part 'word_list_state.g.dart';

@riverpod
class WordListStateNotifier extends _$WordListStateNotifier
    with FetchMoreMixin<WordListState> {
  @override
  FutureOr<WordListState> build(
    String initial,
  ) async {
    final userPrivateWordMap =
        await ref.read(userPrivateWordMapProvider.future);

    return await ref
        .read(wordRepositoryProvider)
        .fetchWordDocListByInitialFirst(initial, userPrivateWordMap);
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () async {
        final userPrivateWordMap =
            await ref.read(userPrivateWordMapProvider.future);

        return ref.read(wordRepositoryProvider).fetchWordDocListByInitialMore(
              initial,
              state.value!.lastReadQueryDocumentSnapshot!,
              userPrivateWordMap,
            );
      },
      mergeFunction: (currentData, newData) => WordListState(
        wordList: currentData.wordList + newData.wordList,
        lastReadQueryDocumentSnapshot: newData.lastReadQueryDocumentSnapshot,
        hasMore: newData.hasMore,
      ),
    );
  }
}
