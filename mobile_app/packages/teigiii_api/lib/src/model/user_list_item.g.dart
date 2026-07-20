// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserListItemCWProxy {
  UserListItem id(String id);

  UserListItem publicId(String publicId);

  UserListItem name(String name);

  UserListItem avatarUrl(String? avatarUrl);

  UserListItem isFollowedByMe(bool isFollowedByMe);

  UserListItem isMutedByMe(bool isMutedByMe);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserListItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserListItem(...).copyWith(id: 12, name: "My name")
  /// ````
  UserListItem call({
    String id,
    String publicId,
    String name,
    String? avatarUrl,
    bool isFollowedByMe,
    bool isMutedByMe,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserListItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserListItem.copyWith.fieldName(...)`
class _$UserListItemCWProxyImpl implements _$UserListItemCWProxy {
  const _$UserListItemCWProxyImpl(this._value);

  final UserListItem _value;

  @override
  UserListItem id(String id) => this(id: id);

  @override
  UserListItem publicId(String publicId) => this(publicId: publicId);

  @override
  UserListItem name(String name) => this(name: name);

  @override
  UserListItem avatarUrl(String? avatarUrl) => this(avatarUrl: avatarUrl);

  @override
  UserListItem isFollowedByMe(bool isFollowedByMe) =>
      this(isFollowedByMe: isFollowedByMe);

  @override
  UserListItem isMutedByMe(bool isMutedByMe) => this(isMutedByMe: isMutedByMe);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserListItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserListItem(...).copyWith(id: 12, name: "My name")
  /// ````
  UserListItem call({
    Object? id = const $CopyWithPlaceholder(),
    Object? publicId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? avatarUrl = const $CopyWithPlaceholder(),
    Object? isFollowedByMe = const $CopyWithPlaceholder(),
    Object? isMutedByMe = const $CopyWithPlaceholder(),
  }) {
    return UserListItem(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      publicId: publicId == const $CopyWithPlaceholder()
          ? _value.publicId
          // ignore: cast_nullable_to_non_nullable
          : publicId as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      avatarUrl: avatarUrl == const $CopyWithPlaceholder()
          ? _value.avatarUrl
          // ignore: cast_nullable_to_non_nullable
          : avatarUrl as String?,
      isFollowedByMe: isFollowedByMe == const $CopyWithPlaceholder()
          ? _value.isFollowedByMe
          // ignore: cast_nullable_to_non_nullable
          : isFollowedByMe as bool,
      isMutedByMe: isMutedByMe == const $CopyWithPlaceholder()
          ? _value.isMutedByMe
          // ignore: cast_nullable_to_non_nullable
          : isMutedByMe as bool,
    );
  }
}

extension $UserListItemCopyWith on UserListItem {
  /// Returns a callable class that can be used as follows: `instanceOfUserListItem.copyWith(...)` or like so:`instanceOfUserListItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserListItemCWProxy get copyWith => _$UserListItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserListItem _$UserListItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserListItem', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'publicId',
          'name',
          'avatarUrl',
          'isFollowedByMe',
          'isMutedByMe',
        ],
      );
      final val = UserListItem(
        id: $checkedConvert('id', (v) => v as String),
        publicId: $checkedConvert('publicId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
        isFollowedByMe: $checkedConvert('isFollowedByMe', (v) => v as bool),
        isMutedByMe: $checkedConvert('isMutedByMe', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$UserListItemToJson(UserListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicId': instance.publicId,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'isFollowedByMe': instance.isFollowedByMe,
      'isMutedByMe': instance.isMutedByMe,
    };
