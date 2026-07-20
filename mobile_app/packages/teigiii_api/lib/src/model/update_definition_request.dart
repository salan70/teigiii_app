//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/definition_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_definition_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateDefinitionRequest {
  /// Returns a new [UpdateDefinitionRequest] instance.
  UpdateDefinitionRequest({this.wordId, this.body, this.status});

  @JsonKey(name: r'wordId', required: false, includeIfNull: false)
  final String? wordId;

  @JsonKey(name: r'body', required: false, includeIfNull: false)
  final String? body;

  @JsonKey(name: r'status', required: false, includeIfNull: false)
  final DefinitionStatus? status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateDefinitionRequest &&
          other.wordId == wordId &&
          other.body == body &&
          other.status == status;

  @override
  int get hashCode => wordId.hashCode + body.hashCode + status.hashCode;

  factory UpdateDefinitionRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateDefinitionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateDefinitionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
