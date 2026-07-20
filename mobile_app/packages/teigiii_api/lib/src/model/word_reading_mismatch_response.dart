//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/word_reading_mismatch_response_error.dart';
import 'package:teigiii_api/src/model/word_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_reading_mismatch_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WordReadingMismatchResponse {
  /// Returns a new [WordReadingMismatchResponse] instance.
  WordReadingMismatchResponse({
    required this.error,

    required this.existingWord,
  });

  @JsonKey(name: r'error', required: true, includeIfNull: false)
  final WordReadingMismatchResponseError error;

  @JsonKey(name: r'existingWord', required: true, includeIfNull: false)
  final WordSummary existingWord;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordReadingMismatchResponse &&
          other.error == error &&
          other.existingWord == existingWord;

  @override
  int get hashCode => error.hashCode + existingWord.hashCode;

  factory WordReadingMismatchResponse.fromJson(Map<String, dynamic> json) =>
      _$WordReadingMismatchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WordReadingMismatchResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
