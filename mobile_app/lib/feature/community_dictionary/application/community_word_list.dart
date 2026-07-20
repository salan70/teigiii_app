import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../word_list/domain/word_list_state.dart';
import '../../word_list/repository/fetch_word_list_repository.dart';
import '../domain/community_dictionary.dart';

part 'community_word_list.g.dart';

@riverpod
class CommunityWordList extends _$CommunityWordList {
  @override
  Future<WordListState> build(CommunityWordFilter filter, String query) => ref
      .read(fetchWordListRepositoryProvider)
      .fetchCommunityWordList(filter: filter, query: query, cursor: null);

  Future<void> fetchMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || state.isLoading) {
      return;
    }
    state = const AsyncLoading<WordListState>().copyWithPrevious(state);
    try {
      final next = await ref
          .read(fetchWordListRepositoryProvider)
          .fetchCommunityWordList(
            filter: filter,
            query: query,
            cursor: current.nextCursor,
          );
      state = AsyncData(
        WordListState(
          list: [...current.list, ...next.list],
          nextCursor: next.nextCursor,
          hasMore: next.hasMore,
        ),
      );
    } on Object catch (error, stackTrace) {
      state = AsyncError<WordListState>(
        error,
        stackTrace,
      ).copyWithPrevious(state);
    }
  }
}
