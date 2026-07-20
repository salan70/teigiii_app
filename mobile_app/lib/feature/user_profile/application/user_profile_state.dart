import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/user_profile.dart';
import '../repository/user_profile_repository.dart';

part 'user_profile_state.g.dart';

@riverpod
Future<UserProfile> userProfile(UserProfileRef ref, String userId) async {
  return ref.read(userProfileRepositoryProvider).fetchUserProfile(userId);
}
