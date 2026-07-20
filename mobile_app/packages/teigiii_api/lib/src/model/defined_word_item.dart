//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/word_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'defined_word_item.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DefinedWordItem {
  /// Returns a new [DefinedWordItem] instance.
  DefinedWordItem({
    required this.word,

    required this.publicCount,

    required this.privateCount,

    required this.draftCount,
  });

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final WordSummary word;

  @JsonKey(name: r'publicCount', required: true, includeIfNull: false)
  final int publicCount;

  @JsonKey(name: r'privateCount', required: true, includeIfNull: false)
  final int privateCount;

  @JsonKey(name: r'draftCount', required: true, includeIfNull: false)
  final int draftCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefinedWordItem &&
          other.word == word &&
          other.publicCount == publicCount &&
          other.privateCount == privateCount &&
          other.draftCount == draftCount;

  @override
  int get hashCode =>
      word.hashCode +
      publicCount.hashCode +
      privateCount.hashCode +
      draftCount.hashCode;

  factory DefinedWordItem.fromJson(Map<String, dynamic> json) =>
      _$DefinedWordItemFromJson(json);

  Map<String, dynamic> toJson() => _$DefinedWordItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
