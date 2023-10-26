import 'package:freezed_annotation/freezed_annotation.dart';

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
}
