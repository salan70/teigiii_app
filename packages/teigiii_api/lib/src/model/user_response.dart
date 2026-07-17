//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserResponse {
  /// Returns a new [UserResponse] instance.
  UserResponse({
    required this.id,

    required this.publicId,

    required this.name,

    required this.avatarUrl,

    required this.bio,

    required this.publicDefinitionCount,

    required this.followingCount,

    required this.followerCount,

    required this.isFollowedByMe,

    required this.isMutedByMe,

    required this.createdAt,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'publicId', required: true, includeIfNull: false)
  final String publicId;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'avatarUrl', required: true, includeIfNull: true)
  final String? avatarUrl;

  @JsonKey(name: r'bio', required: true, includeIfNull: false)
  final String bio;

  @JsonKey(name: r'publicDefinitionCount', required: true, includeIfNull: false)
  final int publicDefinitionCount;

  @JsonKey(name: r'followingCount', required: true, includeIfNull: false)
  final int followingCount;

  @JsonKey(name: r'followerCount', required: true, includeIfNull: false)
  final int followerCount;

  @JsonKey(name: r'isFollowedByMe', required: true, includeIfNull: false)
  final bool isFollowedByMe;

  @JsonKey(name: r'isMutedByMe', required: true, includeIfNull: false)
  final bool isMutedByMe;

  @JsonKey(name: r'createdAt', required: true, includeIfNull: false)
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserResponse &&
          other.id == id &&
          other.publicId == publicId &&
          other.name == name &&
          other.avatarUrl == avatarUrl &&
          other.bio == bio &&
          other.publicDefinitionCount == publicDefinitionCount &&
          other.followingCount == followingCount &&
          other.followerCount == followerCount &&
          other.isFollowedByMe == isFollowedByMe &&
          other.isMutedByMe == isMutedByMe &&
          other.createdAt == createdAt;

  @override
  int get hashCode =>
      id.hashCode +
      publicId.hashCode +
      name.hashCode +
      (avatarUrl == null ? 0 : avatarUrl.hashCode) +
      bio.hashCode +
      publicDefinitionCount.hashCode +
      followingCount.hashCode +
      followerCount.hashCode +
      isFollowedByMe.hashCode +
      isMutedByMe.hashCode +
      createdAt.hashCode;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
