import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../user_profile/application/user_profile_state.dart';
import '../domain/follow_count.dart';
import '../repository/user_follow_repository.dart';

part 'user_follow_state.g.dart';

@riverpod
Future<FollowCount> followCount(FollowCountRef ref, String userId) async {
  final userProfile = await ref.watch(userProfileProvider(userId).future);

  return FollowCount(
    userId: userId,
    followerCount: userProfile.followerCount,
    followingCount: userProfile.followingCount,
  );
}

@riverpod
Future<bool> isFollowing(IsFollowingRef ref, String targetUserId) async {
  final userProfile = await ref.watch(userProfileProvider(targetUserId).future);

  return userProfile.isFollowedByMe;
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
