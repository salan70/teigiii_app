import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/mixin/fetch_more_mixin.dart';
import '../domain/user_id_list_state.dart';
import '../repository/user_follow_repository.dart';
import '../util/profile_feed_type.dart';

part 'user_id_list_state.g.dart';

@riverpod
class UserIdListStateNotifier extends _$UserIdListStateNotifier
    with FetchMoreMixin<UserIdListState> {
  @override
  FutureOr<UserIdListState> build(
    UserListType userListType,
    String targetUserId,
  ) async {
    switch (userListType) {
      case UserListType.following:
        return await ref
            .read(userFollowRepositoryProvider)
            .fetchFollowingIdListFirst(targetUserId);
      case UserListType.follower:
        return await ref
            .read(userFollowRepositoryProvider)
            .fetchFollowerIdListFirst(targetUserId);
      case UserListType.likedUser:
        // TODO(me): いいねしたユーザー一覧を取得するよう修正する
        return await ref
            .read(userFollowRepositoryProvider)
            .fetchFollowerIdListFirst(targetUserId);
    }
  }

  Future<void> fetchMore() async {
    await fetchMoreHelper(
      ref: ref,
      fetchFunction: _fetchUserIdListStateBasedOnType,
      mergeFunction: (currentData, newData) => UserIdListState(
        userIdList: currentData.userIdList + newData.userIdList,
        lastReadQueryDocumentSnapshot: newData.lastReadQueryDocumentSnapshot,
        hasMore: newData.hasMore,
      ),
    );
  }

  Future<UserIdListState> _fetchUserIdListStateBasedOnType() async {
    switch (userListType) {
      case UserListType.following:
        return ref.read(userFollowRepositoryProvider).fetchFollowingIdListMore(
              targetUserId,
              state.value!.lastReadQueryDocumentSnapshot!,
            );
      case UserListType.follower:
        return ref.read(userFollowRepositoryProvider).fetchFollowerIdListMore(
              targetUserId,
              state.value!.lastReadQueryDocumentSnapshot!,
            );
      case UserListType.likedUser:
        // TODO(me): いいねしたユーザー一覧を取得するよう修正する
        return ref.read(userFollowRepositoryProvider).fetchFollowerIdListMore(
              targetUserId,
              state.value!.lastReadQueryDocumentSnapshot!,
            );
    }
  }
}
