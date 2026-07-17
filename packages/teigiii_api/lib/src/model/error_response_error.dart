//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_response_error.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ErrorResponseError {
  /// Returns a new [ErrorResponseError] instance.
  ErrorResponseError({required this.code, required this.message});

  @JsonKey(name: r'code', required: true, includeIfNull: false)
  final String code;

  @JsonKey(name: r'message', required: true, includeIfNull: false)
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorResponseError &&
          other.code == code &&
          other.message == message;

  @override
  int get hashCode => code.hashCode + message.hashCode;

  factory ErrorResponseError.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseErrorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
