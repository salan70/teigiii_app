import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/snack_bar_controller.dart';
import '../../../util/logger.dart';
import '../domain/user_id_list_state.dart';
import '../repository/user_follow_repository.dart';
import '../util/profile_feed_type.dart';

part 'user_id_list_state.g.dart';

@riverpod
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

  /// UserIdListを追加で取得し、stateを更新する
  Future<void> fetchMore() async {
    // これ以上取得できるUserIdがない場合、何もしない
    if (!state.value!.hasMore) {
      return;
    }

    // ローディング中の場合、何もしない
    if (state.isLoading || state.isRefreshing) {
      return;
    }

    // 取得済みのデータを保持しながら状態をローディング中にする
    // これにより、asyncValue.isRefreshingがtrueになる
    // 参考: https://www.zeroichi.biz/blog/1525/
    state = const AsyncLoading<UserIdListState>().copyWithPrevious(state);

    try {
      late final UserIdListState tmpState;
      switch (userListType) {
        case UserListType.following:
          tmpState = await ref
              .read(userFollowRepositoryProvider)
              .fetchFollowingIdListMore(
                targetUserId,
                state.value!.lastReadQueryDocumentSnapshot!,
              );
          break;

        case UserListType.follower:
          tmpState = await ref
              .read(userFollowRepositoryProvider)
              .fetchFollowerIdListMore(
                targetUserId,
                state.value!.lastReadQueryDocumentSnapshot!,
              );
          break;

        case UserListType.likedUser:
          tmpState = await ref
              .read(userFollowRepositoryProvider)
              .fetchFollowerIdListMore(
                targetUserId,
                state.value!.lastReadQueryDocumentSnapshot!,
              );
          break;
      }

      final nextState = UserIdListState(
        userIdList: state.value!.userIdList + tmpState.userIdList,
        lastReadQueryDocumentSnapshot: tmpState.lastReadQueryDocumentSnapshot,
        hasMore: tmpState.hasMore,
      );
      state = AsyncData(nextState);
    } on Exception catch (e, s) {
      logger.e('$e');
      ref
          .read(snackBarControllerProvider.notifier)
          .showSnackBar('読み込めませんでした。もう一度お試しください。', causeError: true);

      state = AsyncError(e, s);
    }
  }
}
