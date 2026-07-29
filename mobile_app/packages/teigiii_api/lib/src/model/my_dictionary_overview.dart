//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/definition_response.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_dictionary_overview.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MyDictionaryOverview {
  /// Returns a new [MyDictionaryOverview] instance.
  MyDictionaryOverview({
    required this.definedWordCount,


    required this.savedWordCount,

    required this.recentDefinitions,
  });

  @JsonKey(name: r'definedWordCount', required: true, includeIfNull: false)
  final int definedWordCount;


  @JsonKey(name: r'savedWordCount', required: true, includeIfNull: false)
  final int savedWordCount;

  @JsonKey(name: r'recentDefinitions', required: true, includeIfNull: false)
  final List<DefinitionResponse> recentDefinitions;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyDictionaryOverview &&
          other.definedWordCount == definedWordCount &&
          other.savedWordCount == savedWordCount &&
          other.recentDefinitions == recentDefinitions;

  @override
  int get hashCode =>
      definedWordCount.hashCode +
      savedWordCount.hashCode +
      recentDefinitions.hashCode;

  factory MyDictionaryOverview.fromJson(Map<String, dynamic> json) =>
      _$MyDictionaryOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$MyDictionaryOverviewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
