import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../repository/user_follow_repository.dart';
import 'user_follow_state.dart';

part 'user_follow_service.g.dart';

@riverpod
UserFollowService userFollowService(UserFollowServiceRef ref) =>
    UserFollowService(ref);

/// ユーザーのフォローに関する処理を行うクラス。
class UserFollowService {
  UserFollowService(this.ref);

  final Ref ref;

  /// ログイン中のユーザーが [targetUserId] をフォローする。
  Future<void> follow(String targetUserId) async {
    final currentUserId = ref.read(userIdProvider)!;

    await ref.read(userFollowRepositoryProvider).follow(
          currentUserId,
          targetUserId,
        );

    // フォローした/されたユーザーのProviderを再生成
    _invalidateRelatedUserProvider(targetUserId);
  }

  /// ログイン中のユーザーが [targetUserId] のフォローを解除する。
  Future<void> unfollow(String targetUserId) async {
    final currentUserId = ref.read(userIdProvider)!;

    await ref.read(userFollowRepositoryProvider).unfollow(
          currentUserId,
          targetUserId,
        );

    // UI上でのフォロー/フォロワー数を更新するため、
    // フォローした/されたユーザーのProviderを再生成する。
    _invalidateRelatedUserProvider(targetUserId);
  }

  /// ログイン中のユーザーと [targetUserId] の
  /// [followCountProvider], [isFollowingProvider] を再生成する。
  void _invalidateRelatedUserProvider(String targetUserId) {
    final currentUserId = ref.read(userIdProvider)!;

    ref
      ..invalidate(followCountProvider(currentUserId))
      ..invalidate(followCountProvider(targetUserId))
      ..invalidate(isFollowingProvider(targetUserId))
      ..invalidate(followingIdListProvider(currentUserId));
  }
}
