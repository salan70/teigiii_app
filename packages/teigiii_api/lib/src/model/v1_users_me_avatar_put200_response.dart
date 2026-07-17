//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'v1_users_me_avatar_put200_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class V1UsersMeAvatarPut200Response {
  /// Returns a new [V1UsersMeAvatarPut200Response] instance.
  V1UsersMeAvatarPut200Response({required this.avatarUrl});

  @JsonKey(name: r'avatarUrl', required: true, includeIfNull: false)
  final String avatarUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is V1UsersMeAvatarPut200Response && other.avatarUrl == avatarUrl;

  @override
  int get hashCode => avatarUrl.hashCode;

  factory V1UsersMeAvatarPut200Response.fromJson(Map<String, dynamic> json) =>
      _$V1UsersMeAvatarPut200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$V1UsersMeAvatarPut200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
