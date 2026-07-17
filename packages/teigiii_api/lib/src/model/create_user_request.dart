//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_user_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateUserRequest {
  /// Returns a new [CreateUserRequest] instance.
  CreateUserRequest({
    required this.name,

    this.bio = '',

    required this.osVersion,

    required this.appVersion,
  });

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(
    defaultValue: '',
    name: r'bio',
    required: false,
    includeIfNull: false,
  )
  final String? bio;

  @JsonKey(name: r'osVersion', required: true, includeIfNull: false)
  final String osVersion;

  @JsonKey(name: r'appVersion', required: true, includeIfNull: false)
  final String appVersion;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateUserRequest &&
          other.name == name &&
          other.bio == bio &&
          other.osVersion == osVersion &&
          other.appVersion == appVersion;

  @override
  int get hashCode =>
      name.hashCode + bio.hashCode + osVersion.hashCode + appVersion.hashCode;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
