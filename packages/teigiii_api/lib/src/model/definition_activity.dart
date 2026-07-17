//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/definition_response.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'definition_activity.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DefinitionActivity {
  /// Returns a new [DefinitionActivity] instance.
  DefinitionActivity({
    required this.type,

    required this.occurredAt,

    required this.definition,
  });

  @JsonKey(name: r'type', required: true, includeIfNull: false)
  final DefinitionActivityTypeEnum type;

  @JsonKey(name: r'occurredAt', required: true, includeIfNull: false)
  final DateTime occurredAt;

  @JsonKey(name: r'definition', required: true, includeIfNull: false)
  final DefinitionResponse definition;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefinitionActivity &&
          other.type == type &&
          other.occurredAt == occurredAt &&
          other.definition == definition;

  @override
  int get hashCode => type.hashCode + occurredAt.hashCode + definition.hashCode;

  factory DefinitionActivity.fromJson(Map<String, dynamic> json) =>
      _$DefinitionActivityFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionActivityToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum DefinitionActivityTypeEnum {
  @JsonValue(r'definition')
  definition(r'definition');

  const DefinitionActivityTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
