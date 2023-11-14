import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/toast_controller.dart';
import '../../../util/logger.dart';
import '../../../util/mixin/fetch_more_mixin.dart';
import '../../auth/application/auth_state.dart';
import '../../user_config/application/user_config_state.dart';
import '../domain/word_list_state.dart';
import '../repository/word_repository.dart';

part 'word_list_state_by_search_word.g.dart';

@Riverpod(keepAlive: true)
class WordListStateBySearchWordNotifier
    extends _$WordListStateBySearchWordNotifier
    with FetchMoreMixin<WordListState> {
  @override
  FutureOr<WordListState> build(
    String searchWord,
  ) async =>
      _fetchList(isFirstFetch: true);

  Future<WordListState> _fetchList({required bool isFirstFetch}) async {
    final lastDocument =
        isFirstFetch ? null : state.value!.lastReadQueryDocumentSnapshot;
    try {
      final currentUserId = ref.read(userIdProvider)!;
      final mutedUserIdList = await ref.read(mutedUserIdListProvider.future);

      return ref.read(wordRepositoryProvider).fetchWordListStateBySearchWord(
            searchWord,
            currentUserId,
            mutedUserIdList,
            lastDocument,
          );
    } on Exception catch (e, _) {
      logger.e('$e');
      ref
          .read(toastControllerProvider.notifier)
          .showToast('読み込めませんでした。もう一度お試しください。', causeError: true);

      // stateの更新を移譲するため、rethrow
      rethrow;
    }
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () async => _fetchList(isFirstFetch: false),
      mergeFunction: (currentData, newData) => WordListState(
        list: currentData.list + newData.list,
        lastReadQueryDocumentSnapshot: newData.lastReadQueryDocumentSnapshot,
        hasMore: newData.hasMore,
      ),
    );
  }
}
