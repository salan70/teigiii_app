import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_profile_for_write.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required String bio,
    required String profileImageUrl,
    required int followerCount,
    required int followingCount,
  }) = _UserProfile;
  const UserProfile._();

  UserProfileForWrite toUserProfileForWrite() {
    return UserProfileForWrite(
      id: id,
      name: name,
      bio: bio,
      profileImageUrl: profileImageUrl,
      croppedFile: null,
    );
  }
}
