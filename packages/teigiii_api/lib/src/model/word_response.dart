//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WordResponse {
  /// Returns a new [WordResponse] instance.
  WordResponse({
    required this.id,

    required this.word,

    required this.reading,

    required this.readingSubGroup,

    required this.publicDefinitionCount,

    required this.isSavedByMe,

    required this.isEditableByMe,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final String word;

  @JsonKey(name: r'reading', required: true, includeIfNull: false)
  final String reading;

  @JsonKey(name: r'readingSubGroup', required: true, includeIfNull: false)
  final String readingSubGroup;

  @JsonKey(name: r'publicDefinitionCount', required: true, includeIfNull: false)
  final int publicDefinitionCount;

  @JsonKey(name: r'isSavedByMe', required: true, includeIfNull: false)
  final bool isSavedByMe;

  @JsonKey(name: r'isEditableByMe', required: true, includeIfNull: false)
  final bool isEditableByMe;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordResponse &&
          other.id == id &&
          other.word == word &&
          other.reading == reading &&
          other.readingSubGroup == readingSubGroup &&
          other.publicDefinitionCount == publicDefinitionCount &&
          other.isSavedByMe == isSavedByMe &&
          other.isEditableByMe == isEditableByMe;

  @override
  int get hashCode =>
      id.hashCode +
      word.hashCode +
      reading.hashCode +
      readingSubGroup.hashCode +
      publicDefinitionCount.hashCode +
      isSavedByMe.hashCode +
      isEditableByMe.hashCode;

  factory WordResponse.fromJson(Map<String, dynamic> json) =>
      _$WordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WordResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
