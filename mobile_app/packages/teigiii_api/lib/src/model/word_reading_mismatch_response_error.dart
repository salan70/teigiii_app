//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_reading_mismatch_response_error.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WordReadingMismatchResponseError {
  /// Returns a new [WordReadingMismatchResponseError] instance.
  WordReadingMismatchResponseError({required this.code, required this.message});

  @JsonKey(name: r'code', required: true, includeIfNull: false)
  final WordReadingMismatchResponseErrorCodeEnum code;

  @JsonKey(name: r'message', required: true, includeIfNull: false)
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordReadingMismatchResponseError &&
          other.code == code &&
          other.message == message;

  @override
  int get hashCode => code.hashCode + message.hashCode;

  factory WordReadingMismatchResponseError.fromJson(
    Map<String, dynamic> json,
  ) => _$WordReadingMismatchResponseErrorFromJson(json);

  Map<String, dynamic> toJson() =>
      _$WordReadingMismatchResponseErrorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum WordReadingMismatchResponseErrorCodeEnum {
  @JsonValue(r'word_reading_mismatch')
  wordReadingMismatch(r'word_reading_mismatch');

  const WordReadingMismatchResponseErrorCodeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
