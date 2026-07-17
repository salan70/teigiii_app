//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_word_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateWordRequest {
  /// Returns a new [CreateWordRequest] instance.
  CreateWordRequest({required this.word, required this.reading});

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final String word;

  @JsonKey(name: r'reading', required: true, includeIfNull: false)
  final String reading;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateWordRequest &&
          other.word == word &&
          other.reading == reading;

  @override
  int get hashCode => word.hashCode + reading.hashCode;

  factory CreateWordRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateWordRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
