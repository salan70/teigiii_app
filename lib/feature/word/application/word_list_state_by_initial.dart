import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../../auth/application/auth_state.dart';
import '../../user_config/application/user_config_state.dart';
import '../domain/word_list_state.dart';
import '../repository/word_repository.dart';

part 'word_list_state_by_initial.g.dart';

@riverpod
class WordListStateByInitialNotifier extends _$WordListStateByInitialNotifier
    with FetchMoreMixin<WordListState> {
  @override
  FutureOr<WordListState> build(
    String initial,
  ) async {
    final currentUserId = ref.read(userIdProvider)!;
    final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);

    return await ref.read(wordRepositoryProvider).fetchWordListStateByInitial(
          initial,
          currentUserId,
          mutedUserIdList,
          null,
        );
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () async {
        final currentUserId = ref.read(userIdProvider)!;
        final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);

        return ref.read(wordRepositoryProvider).fetchWordListStateByInitial(
              initial,
              currentUserId,
              mutedUserIdList,
              state.value!.lastReadQueryDocumentSnapshot,
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
