import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../../auth/application/auth_state.dart';
import '../domain/dictionary_index_list_state.dart';
import '../repository/user_dictionary_word_repository.dart';
import 'community_dictionary_index_list_state.dart';

part 'user_dictionary_index_list_state.g.dart';

@Riverpod(keepAlive: true)
class UserDictionaryIndexListStateNotifier
    extends _$UserDictionaryIndexListStateNotifier
    with FetchMoreMixin<DictionaryIndexListState> {
  @override
  FutureOr<DictionaryIndexListState> build(String targetUserId) async {
    return _fetchFirst();
  }

  bool get _isMe => ref.read(userIdProvider) == targetUserId;

  Future<DictionaryIndexListState> _fetchFirst() async {
    final repo = ref.read(userDictionaryWordRepositoryProvider);
    final page = _isMe
        ? await repo.fetchMyDefinedWords(null)
        : await repo.fetchUserDictionary(targetUserId, null);
    return DictionaryIndexListState(
      list: buildIndexedList(page.list),
      allWords: page.list,
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
    );
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () async {
        final repo = ref.read(userDictionaryWordRepositoryProvider);
        final cursor = state.value!.nextCursor;
        final page = _isMe
            ? await repo.fetchMyDefinedWords(cursor)
            : await repo.fetchUserDictionary(targetUserId, cursor);
        return DictionaryIndexListState(
          list: page.list,
          allWords: page.list,
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        );
      },
      mergeFunction: (currentData, newData) {
        final allWords = currentData.allWords + newData.allWords;
        return DictionaryIndexListState(
          list: buildIndexedList(allWords),
          allWords: allWords,
          nextCursor: newData.nextCursor,
          hasMore: newData.hasMore,
        );
      },
    );
  }
}
