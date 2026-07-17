//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_word_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateWordRequest {
  /// Returns a new [UpdateWordRequest] instance.
  UpdateWordRequest({this.word, this.reading});

  @JsonKey(name: r'word', required: false, includeIfNull: false)
  final String? word;

  @JsonKey(name: r'reading', required: false, includeIfNull: false)
  final String? reading;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateWordRequest &&
          other.word == word &&
          other.reading == reading;

  @override
  int get hashCode => word.hashCode + reading.hashCode;

  factory UpdateWordRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateWordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateWordRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
