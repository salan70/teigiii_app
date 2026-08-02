//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/word_registration_result.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_word_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateWordResponse {
  /// Returns a new [CreateWordResponse] instance.
  CreateWordResponse({
    required this.id,

    required this.word,

    required this.reading,

    required this.readingSubGroup,

    required this.publicDefinitionCount,

    required this.isSavedByMe,

    required this.isEditableByMe,

    required this.registrationResult,
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

  @JsonKey(name: r'registrationResult', required: true, includeIfNull: false)
  final WordRegistrationResult registrationResult;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateWordResponse &&
          other.id == id &&
          other.word == word &&
          other.reading == reading &&
          other.readingSubGroup == readingSubGroup &&
          other.publicDefinitionCount == publicDefinitionCount &&
          other.isSavedByMe == isSavedByMe &&
          other.isEditableByMe == isEditableByMe &&
          other.registrationResult == registrationResult;

  @override
  int get hashCode =>
      id.hashCode +
      word.hashCode +
      reading.hashCode +
      readingSubGroup.hashCode +
      publicDefinitionCount.hashCode +
      isSavedByMe.hashCode +
      isEditableByMe.hashCode +
      registrationResult.hashCode;

  factory CreateWordResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateWordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateWordResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
