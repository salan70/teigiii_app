//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_list_item.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserListItem {
  /// Returns a new [UserListItem] instance.
  UserListItem({
    required this.id,

    required this.publicId,

    required this.name,

    required this.avatarUrl,

    required this.isFollowedByMe,

    required this.isMutedByMe,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'publicId', required: true, includeIfNull: false)
  final String publicId;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'avatarUrl', required: true, includeIfNull: true)
  final String? avatarUrl;

  @JsonKey(name: r'isFollowedByMe', required: true, includeIfNull: false)
  final bool isFollowedByMe;

  @JsonKey(name: r'isMutedByMe', required: true, includeIfNull: false)
  final bool isMutedByMe;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserListItem &&
          other.id == id &&
          other.publicId == publicId &&
          other.name == name &&
          other.avatarUrl == avatarUrl &&
          other.isFollowedByMe == isFollowedByMe &&
          other.isMutedByMe == isMutedByMe;

  @override
  int get hashCode =>
      id.hashCode +
      publicId.hashCode +
      name.hashCode +
      (avatarUrl == null ? 0 : avatarUrl.hashCode) +
      isFollowedByMe.hashCode +
      isMutedByMe.hashCode;

  factory UserListItem.fromJson(Map<String, dynamic> json) =>
      _$UserListItemFromJson(json);

  Map<String, dynamic> toJson() => _$UserListItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
