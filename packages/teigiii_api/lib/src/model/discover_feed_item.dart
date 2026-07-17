//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/definition_activity.dart';
import 'package:teigiii_api/src/model/word_registered_activity.dart';
import 'package:teigiii_api/src/model/definition_response.dart';
import 'package:teigiii_api/src/model/word_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discover_feed_item.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DiscoverFeedItem {
  /// Returns a new [DiscoverFeedItem] instance.
  DiscoverFeedItem({
    required this.type,

    required this.occurredAt,

    required this.definition,

    required this.word,
  });

  @JsonKey(name: r'type', required: true, includeIfNull: false)
  final DiscoverFeedItemTypeEnum type;

  @JsonKey(name: r'occurredAt', required: true, includeIfNull: false)
  final DateTime occurredAt;

  @JsonKey(name: r'definition', required: true, includeIfNull: false)
  final DefinitionResponse definition;

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final WordSummary word;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoverFeedItem &&
          other.type == type &&
          other.occurredAt == occurredAt &&
          other.definition == definition &&
          other.word == word;

  @override
  int get hashCode =>
      type.hashCode + occurredAt.hashCode + definition.hashCode + word.hashCode;

  factory DiscoverFeedItem.fromJson(Map<String, dynamic> json) =>
      _$DiscoverFeedItemFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoverFeedItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum DiscoverFeedItemTypeEnum {
  @JsonValue(r'definition')
  definition(r'definition'),
  @JsonValue(r'wordRegistered')
  wordRegistered(r'wordRegistered');

  const DiscoverFeedItemTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
