//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_summary.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WordSummary {
  /// Returns a new [WordSummary] instance.
  WordSummary({required this.id, required this.word, required this.reading});

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final String word;

  @JsonKey(name: r'reading', required: true, includeIfNull: false)
  final String reading;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordSummary &&
          other.id == id &&
          other.word == word &&
          other.reading == reading;

  @override
  int get hashCode => id.hashCode + word.hashCode + reading.hashCode;

  factory WordSummary.fromJson(Map<String, dynamic> json) =>
      _$WordSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$WordSummaryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
