//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/definition_visibility.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_definition_draft_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PutDefinitionDraftRequest {
  /// Returns a new [PutDefinitionDraftRequest] instance.
  PutDefinitionDraftRequest({
    this.wordId,

    required this.word,

    required this.reading,

    required this.body,

    required this.visibility,
  });

  @JsonKey(name: r'wordId', required: false, includeIfNull: false)
  final String? wordId;

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final String word;

  @JsonKey(name: r'reading', required: true, includeIfNull: false)
  final String reading;

  @JsonKey(name: r'body', required: true, includeIfNull: false)
  final String body;

  @JsonKey(name: r'visibility', required: true, includeIfNull: false)
  final DefinitionVisibility visibility;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PutDefinitionDraftRequest &&
          other.wordId == wordId &&
          other.word == word &&
          other.reading == reading &&
          other.body == body &&
          other.visibility == visibility;

  @override
  int get hashCode =>
      (wordId == null ? 0 : wordId.hashCode) +
      word.hashCode +
      reading.hashCode +
      body.hashCode +
      visibility.hashCode;

  factory PutDefinitionDraftRequest.fromJson(Map<String, dynamic> json) =>
      _$PutDefinitionDraftRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PutDefinitionDraftRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
