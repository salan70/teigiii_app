//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/defined_word_item.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'v1_me_defined_words_get200_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class V1MeDefinedWordsGet200Response {
  /// Returns a new [V1MeDefinedWordsGet200Response] instance.
  V1MeDefinedWordsGet200Response({
    required this.items,

    required this.nextCursor,
  });

  @JsonKey(name: r'items', required: true, includeIfNull: false)
  final List<DefinedWordItem> items;

  @JsonKey(name: r'nextCursor', required: true, includeIfNull: true)
  final String? nextCursor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is V1MeDefinedWordsGet200Response &&
          other.items == items &&
          other.nextCursor == nextCursor;

  @override
  int get hashCode =>
      items.hashCode + (nextCursor == null ? 0 : nextCursor.hashCode);

  factory V1MeDefinedWordsGet200Response.fromJson(Map<String, dynamic> json) =>
      _$V1MeDefinedWordsGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$V1MeDefinedWordsGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
