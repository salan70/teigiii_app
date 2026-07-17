//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_summary.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserSummary {
  /// Returns a new [UserSummary] instance.
  UserSummary({
    required this.id,

    required this.publicId,

    required this.name,

    required this.avatarUrl,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'publicId', required: true, includeIfNull: false)
  final String publicId;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'avatarUrl', required: true, includeIfNull: true)
  final String? avatarUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSummary &&
          other.id == id &&
          other.publicId == publicId &&
          other.name == name &&
          other.avatarUrl == avatarUrl;

  @override
  int get hashCode =>
      id.hashCode +
      publicId.hashCode +
      name.hashCode +
      (avatarUrl == null ? 0 : avatarUrl.hashCode);

  factory UserSummary.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$UserSummaryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
