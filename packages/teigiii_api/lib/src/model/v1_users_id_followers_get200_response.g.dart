// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_id_followers_get200_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$V1UsersIdFollowersGet200ResponseCWProxy {
  V1UsersIdFollowersGet200Response items(List<UserListItem> items);

  V1UsersIdFollowersGet200Response nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1UsersIdFollowersGet200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1UsersIdFollowersGet200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1UsersIdFollowersGet200Response call({
    List<UserListItem> items,
    String? nextCursor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfV1UsersIdFollowersGet200Response.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfV1UsersIdFollowersGet200Response.copyWith.fieldName(...)`
class _$V1UsersIdFollowersGet200ResponseCWProxyImpl
    implements _$V1UsersIdFollowersGet200ResponseCWProxy {
  const _$V1UsersIdFollowersGet200ResponseCWProxyImpl(this._value);

  final V1UsersIdFollowersGet200Response _value;

  @override
  V1UsersIdFollowersGet200Response items(List<UserListItem> items) =>
      this(items: items);

  @override
  V1UsersIdFollowersGet200Response nextCursor(String? nextCursor) =>
      this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1UsersIdFollowersGet200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1UsersIdFollowersGet200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1UsersIdFollowersGet200Response call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return V1UsersIdFollowersGet200Response(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<UserListItem>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $V1UsersIdFollowersGet200ResponseCopyWith
    on V1UsersIdFollowersGet200Response {
  /// Returns a callable class that can be used as follows: `instanceOfV1UsersIdFollowersGet200Response.copyWith(...)` or like so:`instanceOfV1UsersIdFollowersGet200Response.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$V1UsersIdFollowersGet200ResponseCWProxy get copyWith =>
      _$V1UsersIdFollowersGet200ResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V1UsersIdFollowersGet200Response _$V1UsersIdFollowersGet200ResponseFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('V1UsersIdFollowersGet200Response', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = V1UsersIdFollowersGet200Response(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => UserListItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$V1UsersIdFollowersGet200ResponseToJson(
  V1UsersIdFollowersGet200Response instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'nextCursor': instance.nextCursor,
};
