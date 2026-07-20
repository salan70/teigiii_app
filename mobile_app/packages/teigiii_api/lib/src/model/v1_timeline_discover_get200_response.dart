//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/discover_feed_item.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'v1_timeline_discover_get200_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class V1TimelineDiscoverGet200Response {
  /// Returns a new [V1TimelineDiscoverGet200Response] instance.
  V1TimelineDiscoverGet200Response({
    required this.items,

    required this.nextCursor,
  });

  @JsonKey(name: r'items', required: true, includeIfNull: false)
  final List<DiscoverFeedItem> items;

  @JsonKey(name: r'nextCursor', required: true, includeIfNull: true)
  final String? nextCursor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is V1TimelineDiscoverGet200Response &&
          other.items == items &&
          other.nextCursor == nextCursor;

  @override
  int get hashCode =>
      items.hashCode + (nextCursor == null ? 0 : nextCursor.hashCode);

  factory V1TimelineDiscoverGet200Response.fromJson(
    Map<String, dynamic> json,
  ) => _$V1TimelineDiscoverGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$V1TimelineDiscoverGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
