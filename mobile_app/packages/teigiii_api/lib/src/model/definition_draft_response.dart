//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/definition_visibility.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'definition_draft_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DefinitionDraftResponse {
  /// Returns a new [DefinitionDraftResponse] instance.
  DefinitionDraftResponse({
    required this.id,

    required this.wordId,

    required this.word,

    required this.reading,

    required this.body,

    required this.visibility,

    required this.finalizedDefinitionId,

    required this.createdAt,

    required this.updatedAt,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'wordId', required: true, includeIfNull: true)
  final String? wordId;

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final String word;

  @JsonKey(name: r'reading', required: true, includeIfNull: false)
  final String reading;

  @JsonKey(name: r'body', required: true, includeIfNull: false)
  final String body;

  @JsonKey(name: r'visibility', required: true, includeIfNull: false)
  final DefinitionVisibility visibility;

  @JsonKey(name: r'finalizedDefinitionId', required: true, includeIfNull: true)
  final String? finalizedDefinitionId;

  @JsonKey(name: r'createdAt', required: true, includeIfNull: false)
  final DateTime createdAt;

  @JsonKey(name: r'updatedAt', required: true, includeIfNull: false)
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefinitionDraftResponse &&
          other.id == id &&
          other.wordId == wordId &&
          other.word == word &&
          other.reading == reading &&
          other.body == body &&
          other.visibility == visibility &&
          other.finalizedDefinitionId == finalizedDefinitionId &&
          other.createdAt == createdAt &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      id.hashCode +
      (wordId == null ? 0 : wordId.hashCode) +
      word.hashCode +
      reading.hashCode +
      body.hashCode +
      visibility.hashCode +
      (finalizedDefinitionId == null ? 0 : finalizedDefinitionId.hashCode) +
      createdAt.hashCode +
      updatedAt.hashCode;

  factory DefinitionDraftResponse.fromJson(Map<String, dynamic> json) =>
      _$DefinitionDraftResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionDraftResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
