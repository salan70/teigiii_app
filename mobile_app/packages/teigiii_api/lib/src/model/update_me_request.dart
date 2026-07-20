//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_me_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateMeRequest {
  /// Returns a new [UpdateMeRequest] instance.
  UpdateMeRequest({this.name, this.bio, this.osVersion, this.appVersion});

  @JsonKey(name: r'name', required: false, includeIfNull: false)
  final String? name;

  @JsonKey(name: r'bio', required: false, includeIfNull: false)
  final String? bio;

  @JsonKey(name: r'osVersion', required: false, includeIfNull: false)
  final String? osVersion;

  @JsonKey(name: r'appVersion', required: false, includeIfNull: false)
  final String? appVersion;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateMeRequest &&
          other.name == name &&
          other.bio == bio &&
          other.osVersion == osVersion &&
          other.appVersion == appVersion;

  @override
  int get hashCode =>
      name.hashCode + bio.hashCode + osVersion.hashCode + appVersion.hashCode;

  factory UpdateMeRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMeRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
