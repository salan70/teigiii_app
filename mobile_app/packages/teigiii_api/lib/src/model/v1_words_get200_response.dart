//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/word_list_item.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'v1_words_get200_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class V1WordsGet200Response {
  /// Returns a new [V1WordsGet200Response] instance.
  V1WordsGet200Response({required this.items, required this.nextCursor});

  @JsonKey(name: r'items', required: true, includeIfNull: false)
  final List<WordListItem> items;

  @JsonKey(name: r'nextCursor', required: true, includeIfNull: true)
  final String? nextCursor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is V1WordsGet200Response &&
          other.items == items &&
          other.nextCursor == nextCursor;

  @override
  int get hashCode =>
      items.hashCode + (nextCursor == null ? 0 : nextCursor.hashCode);

  factory V1WordsGet200Response.fromJson(Map<String, dynamic> json) =>
      _$V1WordsGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$V1WordsGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
