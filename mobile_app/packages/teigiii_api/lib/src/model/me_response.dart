//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'me_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MeResponse {
  /// Returns a new [MeResponse] instance.
  MeResponse({
    required this.id,

    required this.publicId,

    required this.name,

    required this.avatarUrl,

    required this.bio,

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

  @JsonKey(name: r'createdAt', required: true, includeIfNull: false)
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeResponse &&
          other.id == id &&
          other.publicId == publicId &&
          other.name == name &&
          other.avatarUrl == avatarUrl &&
          other.bio == bio &&
          other.createdAt == createdAt;

  @override
  int get hashCode =>
      id.hashCode +
      publicId.hashCode +
      name.hashCode +
      (avatarUrl == null ? 0 : avatarUrl.hashCode) +
      bio.hashCode +
      createdAt.hashCode;

  factory MeResponse.fromJson(Map<String, dynamic> json) =>
      _$MeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MeResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
