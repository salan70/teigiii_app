//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/word_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dictionary_item.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserDictionaryItem {
  /// Returns a new [UserDictionaryItem] instance.
  UserDictionaryItem({
    required this.word,

    required this.readingSubGroup,

    required this.publicCount,
  });

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final WordSummary word;

  @JsonKey(name: r'readingSubGroup', required: true, includeIfNull: false)
  final String readingSubGroup;

  @JsonKey(name: r'publicCount', required: true, includeIfNull: false)
  final int publicCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDictionaryItem &&
          other.word == word &&
          other.readingSubGroup == readingSubGroup &&
          other.publicCount == publicCount;

  @override
  int get hashCode =>
      word.hashCode + readingSubGroup.hashCode + publicCount.hashCode;

  factory UserDictionaryItem.fromJson(Map<String, dynamic> json) =>
      _$UserDictionaryItemFromJson(json);

  Map<String, dynamic> toJson() => _$UserDictionaryItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
