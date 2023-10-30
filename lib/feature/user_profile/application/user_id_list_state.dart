import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/user_id_list_state.dart';
import '../repository/user_follow_repository.dart';
import '../util/profile_feed_type.dart';

part 'user_id_list_state.g.dart';

@Riverpod(keepAlive: true)
class UserIdListStateNotifier extends _$UserIdListStateNotifier {
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
}
