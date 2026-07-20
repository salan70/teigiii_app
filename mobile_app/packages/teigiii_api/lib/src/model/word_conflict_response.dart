//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/error_response_error.dart';
import 'package:teigiii_api/src/model/word_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_conflict_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WordConflictResponse {
  /// Returns a new [WordConflictResponse] instance.
  WordConflictResponse({required this.error, required this.existingWord});

  @JsonKey(name: r'error', required: true, includeIfNull: false)
  final ErrorResponseError error;

  @JsonKey(name: r'existingWord', required: true, includeIfNull: false)
  final WordSummary existingWord;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordConflictResponse &&
          other.error == error &&
          other.existingWord == existingWord;

  @override
  int get hashCode => error.hashCode + existingWord.hashCode;

  factory WordConflictResponse.fromJson(Map<String, dynamic> json) =>
      _$WordConflictResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WordConflictResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
