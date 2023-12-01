import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../user_follow/domain/follow_count.dart';
import '../../user_follow/repository/user_follow_repository.dart';

part 'user_follow_state.g.dart';

@riverpod
Future<FollowCount> followCount(
  FollowCountRef ref,
  String userId,
) async {
  final userFollowCountDoc =
      await ref.read(userFollowRepositoryProvider).fetchUserFollowCount(userId);

  return FollowCount.fromDocument(userFollowCountDoc);
}

@riverpod
Future<bool> isFollowing(IsFollowingRef ref, String targetUserId) async {
  final currentUserId = ref.read(userIdProvider)!;

  return ref
      .read(userFollowRepositoryProvider)
      .isFollowing(currentUserId, targetUserId);
}

@riverpod
Future<List<String>> followingIdList(
  FollowingIdListRef ref,
  String targetUserId,
) async {
  return ref
      .read(userFollowRepositoryProvider)
      .fetchAllFollowingIdList(targetUserId);
}
