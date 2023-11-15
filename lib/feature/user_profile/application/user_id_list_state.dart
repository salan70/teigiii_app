import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/toast_controller.dart';
import '../../../util/logger.dart';
import '../../../util/mixin/fetch_more_mixin.dart';
import '../../definition/repository/fetch_definition_repository.dart';
import '../domain/user_id_list_state.dart';
import '../repository/user_follow_repository.dart';
import '../util/profile_feed_type.dart';

part 'user_id_list_state.g.dart';

@Riverpod(keepAlive: true)
class UserIdListStateNotifier extends _$UserIdListStateNotifier
    with FetchMoreMixin<UserIdListState> {
  @override
  FutureOr<UserIdListState> build(
    UserListType userListType, {
    required String? targetUserId,
    required String? targetDefinitionId,
  }) async {
    return await _fetchUserIdListStateBasedOnType(
      isFirstFetch: true,
    );
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: () async => _fetchUserIdListStateBasedOnType(
        isFirstFetch: false,
      ),
      mergeFunction: (currentData, newData) => UserIdListState(
        list: currentData.list + newData.list,
        lastReadQueryDocumentSnapshot: newData.lastReadQueryDocumentSnapshot,
        hasMore: newData.hasMore,
      ),
    );
  }

  Future<UserIdListState> _fetchUserIdListStateBasedOnType({
    required bool isFirstFetch,
  }) async {
    final lastDocument =
        isFirstFetch ? null : state.value!.lastReadQueryDocumentSnapshot;
    try {
      switch (userListType) {
        case UserListType.following:
          if (targetUserId == null) {
            throw ArgumentError('targetUserIdがnullです');
          }
          return await ref
              .read(userFollowRepositoryProvider)
              .fetchFollowingIdList(
                targetUserId!,
                lastDocument,
              );

        case UserListType.follower:
          if (targetUserId == null) {
            throw ArgumentError('targetUserIdがnullです');
          }
          return await ref
              .read(userFollowRepositoryProvider)
              .fetchFollowerIdList(
                targetUserId!,
                lastDocument,
              );

        case UserListType.liked:
          if (targetDefinitionId == null) {
            throw ArgumentError('targetDefinitionIdがnullです');
          }
          return await ref
              .read(fetchDefinitionRepositoryProvider)
              .fetchLikedUserIdList(
                targetDefinitionId!,
                lastDocument,
              );
      }
    } on Exception catch (e, stackTrace) {
      logger.e('error: $e, stackTrace: $stackTrace');
      ref
          .read(toastControllerProvider.notifier)
          .showToast('読み込めませんでした。もう一度お試しください。', causeError: true);

      // stateの更新を移譲するため、rethrow
      rethrow;
    }
  }
}
