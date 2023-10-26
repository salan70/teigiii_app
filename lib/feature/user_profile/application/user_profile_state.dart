import 'package:riverpod_annotation/riverpod_annotation.dart';

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
