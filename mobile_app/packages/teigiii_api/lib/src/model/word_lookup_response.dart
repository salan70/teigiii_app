//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/word_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_lookup_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WordLookupResponse {
  /// Returns a new [WordLookupResponse] instance.
  WordLookupResponse({required this.word});

  @JsonKey(name: r'word', required: true, includeIfNull: true)
  final WordSummary? word;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordLookupResponse && other.word == word;

  @override
  int get hashCode => (word == null ? 0 : word.hashCode);

  factory WordLookupResponse.fromJson(Map<String, dynamic> json) =>
      _$WordLookupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WordLookupResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
