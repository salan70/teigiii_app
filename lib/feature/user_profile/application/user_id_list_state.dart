import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../../definition/repository/fetch_definition_repository.dart';
import '../domain/user_id_list_state.dart';
import '../repository/user_follow_repository.dart';
import '../util/profile_feed_type.dart';

part 'user_id_list_state.g.dart';

@riverpod
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
      fetchFunction: () => _fetchUserIdListStateBasedOnType(
        isFirstFetch: false,
      ),
      mergeFunction: (currentData, newData) => UserIdListState(
        userIdList: currentData.userIdList + newData.userIdList,
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
    switch (userListType) {
      case UserListType.following:
        if (targetUserId == null) {
          throw ArgumentError('targetUserIdがnullです');
        }
        return ref.read(userFollowRepositoryProvider).fetchFollowingIdList(
              targetUserId!,
              lastDocument,
            );

      case UserListType.follower:
        if (targetUserId == null) {
          throw ArgumentError('targetUserIdがnullです');
        }
        return ref.read(userFollowRepositoryProvider).fetchFollowerIdList(
              targetUserId!,
              lastDocument,
            );

      case UserListType.likedUser:
        if (targetDefinitionId == null) {
          throw ArgumentError('targetDefinitionIdがnullです');
        }
        return ref
            .read(fetchDefinitionRepositoryProvider)
            .fetchFavoriteUserIdList(
              targetDefinitionId!,
              lastDocument,
            );
    }
  }
}
