// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_timeline_discover_get200_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$V1TimelineDiscoverGet200ResponseCWProxy {
  V1TimelineDiscoverGet200Response items(List<DiscoverFeedItem> items);

  V1TimelineDiscoverGet200Response nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1TimelineDiscoverGet200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1TimelineDiscoverGet200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1TimelineDiscoverGet200Response call({
    List<DiscoverFeedItem> items,
    String? nextCursor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfV1TimelineDiscoverGet200Response.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfV1TimelineDiscoverGet200Response.copyWith.fieldName(...)`
class _$V1TimelineDiscoverGet200ResponseCWProxyImpl
    implements _$V1TimelineDiscoverGet200ResponseCWProxy {
  const _$V1TimelineDiscoverGet200ResponseCWProxyImpl(this._value);

  final V1TimelineDiscoverGet200Response _value;

  @override
  V1TimelineDiscoverGet200Response items(List<DiscoverFeedItem> items) =>
      this(items: items);

  @override
  V1TimelineDiscoverGet200Response nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1TimelineDiscoverGet200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1TimelineDiscoverGet200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1TimelineDiscoverGet200Response call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return V1TimelineDiscoverGet200Response(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<DiscoverFeedItem>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $V1TimelineDiscoverGet200ResponseCopyWith
    on V1TimelineDiscoverGet200Response {
  /// Returns a callable class that can be used as follows: `instanceOfV1TimelineDiscoverGet200Response.copyWith(...)` or like so:`instanceOfV1TimelineDiscoverGet200Response.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$V1TimelineDiscoverGet200ResponseCWProxy get copyWith =>
      _$V1TimelineDiscoverGet200ResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V1TimelineDiscoverGet200Response _$V1TimelineDiscoverGet200ResponseFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('V1TimelineDiscoverGet200Response', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = V1TimelineDiscoverGet200Response(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => DiscoverFeedItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$V1TimelineDiscoverGet200ResponseToJson(
  V1TimelineDiscoverGet200Response instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'nextCursor': instance.nextCursor,
};
