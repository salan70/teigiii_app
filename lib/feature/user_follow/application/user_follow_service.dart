import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../user_profile/application/user_profile_state.dart';
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
    await ref.read(userFollowRepositoryProvider).follow(targetUserId);

    // フォローした/されたユーザーのProviderを再生成
    _invalidateRelatedUserProvider(targetUserId);
  }

  /// ログイン中のユーザーが [targetUserId] のフォローを解除する。
  Future<void> unfollow(String targetUserId) async {
    await ref.read(userFollowRepositoryProvider).unfollow(targetUserId);

    // UI上でのフォロー/フォロワー数を更新するため、
    // フォローした/されたユーザーのProviderを再生成する。
    _invalidateRelatedUserProvider(targetUserId);
  }

  /// ログイン中のユーザーと [targetUserId] のプロフィール Provider を再生成する。
  ///
  /// followCount / isFollowing は userProfileProvider からの導出のため、
  /// userProfileProvider の再生成で連動して更新される。
  void _invalidateRelatedUserProvider(String targetUserId) {
    final currentUserId = ref.read(userIdProvider)!;

    ref
      ..invalidate(userProfileProvider(currentUserId))
      ..invalidate(userProfileProvider(targetUserId))
      ..invalidate(followingIdListProvider(currentUserId));
  }
}
