//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/definition_draft_response.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'v1_me_definition_drafts_get200_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class V1MeDefinitionDraftsGet200Response {
  /// Returns a new [V1MeDefinitionDraftsGet200Response] instance.
  V1MeDefinitionDraftsGet200Response({
    required this.items,

    required this.nextCursor,
  });

  @JsonKey(name: r'items', required: true, includeIfNull: false)
  final List<DefinitionDraftResponse> items;

  @JsonKey(name: r'nextCursor', required: true, includeIfNull: true)
  final String? nextCursor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is V1MeDefinitionDraftsGet200Response &&
          other.items == items &&
          other.nextCursor == nextCursor;

  @override
  int get hashCode =>
      items.hashCode + (nextCursor == null ? 0 : nextCursor.hashCode);

  factory V1MeDefinitionDraftsGet200Response.fromJson(
    Map<String, dynamic> json,
  ) => _$V1MeDefinitionDraftsGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$V1MeDefinitionDraftsGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
