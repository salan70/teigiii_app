//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/user_list_item.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'v1_users_id_followers_get200_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class V1UsersIdFollowersGet200Response {
  /// Returns a new [V1UsersIdFollowersGet200Response] instance.
  V1UsersIdFollowersGet200Response({
    required this.items,

    required this.nextCursor,
  });

  @JsonKey(name: r'items', required: true, includeIfNull: false)
  final List<UserListItem> items;

  @JsonKey(name: r'nextCursor', required: true, includeIfNull: true)
  final String? nextCursor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is V1UsersIdFollowersGet200Response &&
          other.items == items &&
          other.nextCursor == nextCursor;

  @override
  int get hashCode =>
      items.hashCode + (nextCursor == null ? 0 : nextCursor.hashCode);

  factory V1UsersIdFollowersGet200Response.fromJson(
    Map<String, dynamic> json,
  ) => _$V1UsersIdFollowersGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$V1UsersIdFollowersGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
