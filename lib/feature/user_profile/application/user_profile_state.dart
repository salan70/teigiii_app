import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/user_profile.dart';
import '../repository/user_profile_repository.dart';

part 'user_profile_state.g.dart';

@riverpod
Future<UserProfile> userProfile(UserProfileRef ref, String userId) async {
  final userProfileDoc =
      await ref.read(userProfileRepositoryProvider).fetchUserProfile(userId);

  return userProfileDoc.toUserProfile();
}

@riverpod
Future<String?> userIdSearchByPublicId(
  UserIdSearchByPublicIdRef ref,
  String publicId,
) async {
  final userProfileDoc = await ref
      .read(userProfileRepositoryProvider)
      .searchUserProfileByPublicId(publicId);

  return userProfileDoc?.id;
}
