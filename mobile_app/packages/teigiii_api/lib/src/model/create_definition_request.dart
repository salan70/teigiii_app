//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/definition_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_definition_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateDefinitionRequest {
  /// Returns a new [CreateDefinitionRequest] instance.
  CreateDefinitionRequest({
    this.wordId,

    this.word,

    this.reading,

    required this.body,

    required this.status,
  });

  @JsonKey(name: r'wordId', required: false, includeIfNull: false)
  final String? wordId;

  @JsonKey(name: r'word', required: false, includeIfNull: false)
  final String? word;

  @JsonKey(name: r'reading', required: false, includeIfNull: false)
  final String? reading;

  @JsonKey(name: r'body', required: true, includeIfNull: false)
  final String body;

  @JsonKey(name: r'status', required: true, includeIfNull: false)
  final DefinitionStatus status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateDefinitionRequest &&
          other.wordId == wordId &&
          other.word == word &&
          other.reading == reading &&
          other.body == body &&
          other.status == status;

  @override
  int get hashCode =>
      wordId.hashCode +
      word.hashCode +
      reading.hashCode +
      body.hashCode +
      status.hashCode;

  factory CreateDefinitionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDefinitionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDefinitionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
