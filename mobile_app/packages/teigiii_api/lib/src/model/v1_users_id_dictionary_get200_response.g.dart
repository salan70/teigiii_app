// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_id_dictionary_get200_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$V1UsersIdDictionaryGet200ResponseCWProxy {
  V1UsersIdDictionaryGet200Response items(List<UserDictionaryItem> items);

  V1UsersIdDictionaryGet200Response nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1UsersIdDictionaryGet200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1UsersIdDictionaryGet200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1UsersIdDictionaryGet200Response call({
    List<UserDictionaryItem> items,
    String? nextCursor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfV1UsersIdDictionaryGet200Response.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfV1UsersIdDictionaryGet200Response.copyWith.fieldName(...)`
class _$V1UsersIdDictionaryGet200ResponseCWProxyImpl
    implements _$V1UsersIdDictionaryGet200ResponseCWProxy {
  const _$V1UsersIdDictionaryGet200ResponseCWProxyImpl(this._value);

  final V1UsersIdDictionaryGet200Response _value;

  @override
  V1UsersIdDictionaryGet200Response items(List<UserDictionaryItem> items) =>
      this(items: items);

  @override
  V1UsersIdDictionaryGet200Response nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1UsersIdDictionaryGet200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1UsersIdDictionaryGet200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1UsersIdDictionaryGet200Response call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return V1UsersIdDictionaryGet200Response(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<UserDictionaryItem>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $V1UsersIdDictionaryGet200ResponseCopyWith
    on V1UsersIdDictionaryGet200Response {
  /// Returns a callable class that can be used as follows: `instanceOfV1UsersIdDictionaryGet200Response.copyWith(...)` or like so:`instanceOfV1UsersIdDictionaryGet200Response.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$V1UsersIdDictionaryGet200ResponseCWProxy get copyWith =>
      _$V1UsersIdDictionaryGet200ResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V1UsersIdDictionaryGet200Response _$V1UsersIdDictionaryGet200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('V1UsersIdDictionaryGet200Response', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
  final val = V1UsersIdDictionaryGet200Response(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => UserDictionaryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$V1UsersIdDictionaryGet200ResponseToJson(
  V1UsersIdDictionaryGet200Response instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'nextCursor': instance.nextCursor,
};
