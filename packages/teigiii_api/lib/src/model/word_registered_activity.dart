//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/word_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_registered_activity.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WordRegisteredActivity {
  /// Returns a new [WordRegisteredActivity] instance.
  WordRegisteredActivity({
    required this.type,

    required this.occurredAt,

    required this.word,
  });

  @JsonKey(name: r'type', required: true, includeIfNull: false)
  final WordRegisteredActivityTypeEnum type;

  @JsonKey(name: r'occurredAt', required: true, includeIfNull: false)
  final DateTime occurredAt;

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final WordSummary word;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordRegisteredActivity &&
          other.type == type &&
          other.occurredAt == occurredAt &&
          other.word == word;

  @override
  int get hashCode => type.hashCode + occurredAt.hashCode + word.hashCode;

  factory WordRegisteredActivity.fromJson(Map<String, dynamic> json) =>
      _$WordRegisteredActivityFromJson(json);

  Map<String, dynamic> toJson() => _$WordRegisteredActivityToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum WordRegisteredActivityTypeEnum {
  @JsonValue(r'wordRegistered')
  wordRegistered(r'wordRegistered');

  const WordRegisteredActivityTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
