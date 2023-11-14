import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../user_profile/repository/user_profile_repository.dart';
import '../domain/follow_count.dart';
import '../domain/user_profile.dart';
import '../repository/user_follow_repository.dart';

part 'user_profile_state.g.dart';

@Riverpod(keepAlive: true)
Future<UserProfile> userProfile(UserProfileRef ref, String userId) async {
  final userProfileDoc =
      await ref.read(userProfileRepositoryProvider).fetchUserProfile(userId);

  return userProfileDoc.toUserProfile();
}

@Riverpod(keepAlive: true)
Future<String?> userIdSearchByPublicId(
  UserIdSearchByPublicIdRef ref,
  String publicId,
) async {
  final userProfileDoc = await ref
      .read(userProfileRepositoryProvider)
      .searchUserProfileByPublicId(publicId);

  return userProfileDoc?.id;
}

@Riverpod(keepAlive: true)
Future<FollowCount> followCount(
  FollowCountRef ref,
  String userId,
) async {
  final userFollowCountDoc =
      await ref.read(userFollowRepositoryProvider).fetchUserFollowCount(userId);

  return FollowCount.fromDocument(userFollowCountDoc);
}

@Riverpod(keepAlive: true)
Future<bool> isFollowing(IsFollowingRef ref, String targetUserId) async {
  final currentUserId = ref.read(userIdProvider)!;

  return ref
      .read(userFollowRepositoryProvider)
      .isFollowing(currentUserId, targetUserId);
}

@Riverpod(keepAlive: true)
Future<List<String>> followingIdList(
  FollowingIdListRef ref,
  String targetUserId,
) async {
  return ref
      .read(userFollowRepositoryProvider)
      .fetchAllFollowingIdList(targetUserId);
}
