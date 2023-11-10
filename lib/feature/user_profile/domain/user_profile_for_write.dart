import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_for_write.freezed.dart';

@freezed
class UserProfileForWrite with _$UserProfileForWrite {
  const factory UserProfileForWrite({
    required String id,
    required String name,
    required String bio,
    required String profileImageUrl,
  }) = _UserProfileForWrite;
  const UserProfileForWrite._();

  int get maxNameLength => 15;
  int get maxBioLength => 150;
}
