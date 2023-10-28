import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../user_profile/repository/user_profile_repository.dart';
import '../domain/user_profile.dart';
import '../repository/user_follow_repository.dart';

part 'user_profile_state.g.dart';

@Riverpod(keepAlive: true)
Future<UserProfile> userProfile(UserProfileRef ref, String userId) async {
  final userProfileDoc =
      await ref.read(userProfileRepositoryProvider).fetchUserProfile(userId);

  final userFollowCountDoc =
      await ref.read(userFollowRepositoryProvider).fetchUserFollowCount(userId);

  return UserProfile(
    id: userId,
    name: userProfileDoc.name,
    bio: userProfileDoc.bio,
    profileImageUrl: userProfileDoc.profileImageUrl,
    followerCount: userFollowCountDoc.followerCount,
    followingCount: userFollowCountDoc.followingCount,
  );
}

@Riverpod(keepAlive: true)
Future<bool> isFollowing(IsFollowingRef ref, String targetUserId) async {
  final currentUserId = ref.read(userIdProvider)!;

  return ref
      .read(userFollowRepositoryProvider)
      .isFollowing(currentUserId, targetUserId);
}
