// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_me_saved_words_get200_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$V1MeSavedWordsGet200ResponseCWProxy {
  V1MeSavedWordsGet200Response items(List<SavedWordItem> items);

  V1MeSavedWordsGet200Response nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1MeSavedWordsGet200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1MeSavedWordsGet200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1MeSavedWordsGet200Response call({
    List<SavedWordItem> items,
    String? nextCursor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfV1MeSavedWordsGet200Response.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfV1MeSavedWordsGet200Response.copyWith.fieldName(...)`
class _$V1MeSavedWordsGet200ResponseCWProxyImpl
    implements _$V1MeSavedWordsGet200ResponseCWProxy {
  const _$V1MeSavedWordsGet200ResponseCWProxyImpl(this._value);

  final V1MeSavedWordsGet200Response _value;

  @override
  V1MeSavedWordsGet200Response items(List<SavedWordItem> items) =>
      this(items: items);

  @override
  V1MeSavedWordsGet200Response nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1MeSavedWordsGet200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1MeSavedWordsGet200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1MeSavedWordsGet200Response call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return V1MeSavedWordsGet200Response(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<SavedWordItem>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $V1MeSavedWordsGet200ResponseCopyWith
    on V1MeSavedWordsGet200Response {
  /// Returns a callable class that can be used as follows: `instanceOfV1MeSavedWordsGet200Response.copyWith(...)` or like so:`instanceOfV1MeSavedWordsGet200Response.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$V1MeSavedWordsGet200ResponseCWProxy get copyWith =>
      _$V1MeSavedWordsGet200ResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V1MeSavedWordsGet200Response _$V1MeSavedWordsGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('V1MeSavedWordsGet200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
  final val = V1MeSavedWordsGet200Response(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => SavedWordItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$V1MeSavedWordsGet200ResponseToJson(
  V1MeSavedWordsGet200Response instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'nextCursor': instance.nextCursor,
};
