import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../domain/word_list_state.dart';
import '../repository/user_dictionary_word_repository.dart';

part 'saved_word_list_state.g.dart';

@Riverpod(keepAlive: true)
class SavedWordListStateNotifier extends _$SavedWordListStateNotifier
    with FetchMoreMixin<WordListState> {
  @override
  FutureOr<WordListState> build() async =>
      ref.read(userDictionaryWordRepositoryProvider).fetchMySavedWords(null);

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () => ref
          .read(userDictionaryWordRepositoryProvider)
          .fetchMySavedWords(state.value!.nextCursor),
      mergeFunction: (currentData, newData) => WordListState(
        list: currentData.list + newData.list,
        nextCursor: newData.nextCursor,
        hasMore: newData.hasMore,
      ),
    );
  }
}
