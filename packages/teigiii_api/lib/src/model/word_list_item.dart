//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_list_item.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WordListItem {
  /// Returns a new [WordListItem] instance.
  WordListItem({
    required this.id,

    required this.word,

    required this.reading,

    required this.readingSubGroup,

    required this.publicDefinitionCount,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final String word;

  @JsonKey(name: r'reading', required: true, includeIfNull: false)
  final String reading;

  @JsonKey(name: r'readingSubGroup', required: true, includeIfNull: false)
  final String readingSubGroup;

  @JsonKey(name: r'publicDefinitionCount', required: true, includeIfNull: false)
  final int publicDefinitionCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordListItem &&
          other.id == id &&
          other.word == word &&
          other.reading == reading &&
          other.readingSubGroup == readingSubGroup &&
          other.publicDefinitionCount == publicDefinitionCount;

  @override
  int get hashCode =>
      id.hashCode +
      word.hashCode +
      reading.hashCode +
      readingSubGroup.hashCode +
      publicDefinitionCount.hashCode;

  factory WordListItem.fromJson(Map<String, dynamic> json) =>
      _$WordListItemFromJson(json);

  Map<String, dynamic> toJson() => _$WordListItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
