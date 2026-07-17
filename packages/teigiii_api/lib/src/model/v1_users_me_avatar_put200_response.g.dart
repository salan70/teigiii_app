// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_avatar_put200_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$V1UsersMeAvatarPut200ResponseCWProxy {
  V1UsersMeAvatarPut200Response avatarUrl(String avatarUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1UsersMeAvatarPut200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1UsersMeAvatarPut200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1UsersMeAvatarPut200Response call({String avatarUrl});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfV1UsersMeAvatarPut200Response.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfV1UsersMeAvatarPut200Response.copyWith.fieldName(...)`
class _$V1UsersMeAvatarPut200ResponseCWProxyImpl
    implements _$V1UsersMeAvatarPut200ResponseCWProxy {
  const _$V1UsersMeAvatarPut200ResponseCWProxyImpl(this._value);

  final V1UsersMeAvatarPut200Response _value;

  @override
  V1UsersMeAvatarPut200Response avatarUrl(String avatarUrl) =>
      this(avatarUrl: avatarUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `V1UsersMeAvatarPut200Response(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// V1UsersMeAvatarPut200Response(...).copyWith(id: 12, name: "My name")
  /// ````
  V1UsersMeAvatarPut200Response call({
    Object? avatarUrl = const $CopyWithPlaceholder(),
  }) {
    return V1UsersMeAvatarPut200Response(
      avatarUrl: avatarUrl == const $CopyWithPlaceholder()
          ? _value.avatarUrl
          // ignore: cast_nullable_to_non_nullable
          : avatarUrl as String,
    );
  }
}

extension $V1UsersMeAvatarPut200ResponseCopyWith
    on V1UsersMeAvatarPut200Response {
  /// Returns a callable class that can be used as follows: `instanceOfV1UsersMeAvatarPut200Response.copyWith(...)` or like so:`instanceOfV1UsersMeAvatarPut200Response.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$V1UsersMeAvatarPut200ResponseCWProxy get copyWith =>
      _$V1UsersMeAvatarPut200ResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V1UsersMeAvatarPut200Response _$V1UsersMeAvatarPut200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('V1UsersMeAvatarPut200Response', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['avatarUrl']);
  final val = V1UsersMeAvatarPut200Response(
    avatarUrl: $checkedConvert('avatarUrl', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$V1UsersMeAvatarPut200ResponseToJson(
  V1UsersMeAvatarPut200Response instance,
) => <String, dynamic>{'avatarUrl': instance.avatarUrl};
