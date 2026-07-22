//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/word_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_word_item.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SavedWordItem {
  /// Returns a new [SavedWordItem] instance.
  SavedWordItem({
    required this.word,
    required this.isDefinedByMe,
    required this.publicCount,
  });

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final WordSummary word;

  @JsonKey(name: r'isDefinedByMe', required: true, includeIfNull: false)
  final bool isDefinedByMe;

  @JsonKey(name: r'publicCount', required: true, includeIfNull: false)
  final int publicCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedWordItem &&
          other.word == word &&
          other.isDefinedByMe == isDefinedByMe &&
          other.publicCount == publicCount;

  @override
  int get hashCode =>
      word.hashCode + isDefinedByMe.hashCode + publicCount.hashCode;

  factory SavedWordItem.fromJson(Map<String, dynamic> json) =>
      _$SavedWordItemFromJson(json);

  Map<String, dynamic> toJson() => _$SavedWordItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
