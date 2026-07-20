//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'finalize_definition_draft_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FinalizeDefinitionDraftRequest {
  /// Returns a new [FinalizeDefinitionDraftRequest] instance.
  FinalizeDefinitionDraftRequest({this.confirmReadingMismatch = false});

  @JsonKey(
    defaultValue: false,
    name: r'confirmReadingMismatch',
    required: false,
    includeIfNull: false,
  )
  final bool? confirmReadingMismatch;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinalizeDefinitionDraftRequest &&
          other.confirmReadingMismatch == confirmReadingMismatch;

  @override
  int get hashCode => confirmReadingMismatch.hashCode;

  factory FinalizeDefinitionDraftRequest.fromJson(Map<String, dynamic> json) =>
      _$FinalizeDefinitionDraftRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FinalizeDefinitionDraftRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
