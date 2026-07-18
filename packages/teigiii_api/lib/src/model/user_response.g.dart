// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserResponseCWProxy {
  UserResponse id(String id);

  UserResponse publicId(String publicId);

  UserResponse name(String name);

  UserResponse avatarUrl(String? avatarUrl);

  UserResponse bio(String bio);

  UserResponse publicDefinitionCount(int publicDefinitionCount);

  UserResponse followingCount(int followingCount);

  UserResponse followerCount(int followerCount);

  UserResponse isFollowedByMe(bool isFollowedByMe);

  UserResponse isMutedByMe(bool isMutedByMe);

  UserResponse createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  UserResponse call({
    String id,
    String publicId,
    String name,
    String? avatarUrl,
    String bio,
    int publicDefinitionCount,
    int followingCount,
    int followerCount,
    bool isFollowedByMe,
    bool isMutedByMe,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserResponse.copyWith.fieldName(...)`
class _$UserResponseCWProxyImpl implements _$UserResponseCWProxy {
  const _$UserResponseCWProxyImpl(this._value);

  final UserResponse _value;

  @override
  UserResponse id(String id) => this(id: id);

  @override
  UserResponse publicId(String publicId) => this(publicId: publicId);

  @override
  UserResponse name(String name) => this(name: name);

  @override
  UserResponse avatarUrl(String? avatarUrl) => this(avatarUrl: avatarUrl);

  @override
  UserResponse bio(String bio) => this(bio: bio);

  @override
  UserResponse publicDefinitionCount(int publicDefinitionCount) =>
      this(publicDefinitionCount: publicDefinitionCount);

  @override
  UserResponse followingCount(int followingCount) =>
      this(followingCount: followingCount);

  @override
  UserResponse followerCount(int followerCount) =>
      this(followerCount: followerCount);

  @override
  UserResponse isFollowedByMe(bool isFollowedByMe) =>
      this(isFollowedByMe: isFollowedByMe);

  @override
  UserResponse isMutedByMe(bool isMutedByMe) => this(isMutedByMe: isMutedByMe);

  @override
  UserResponse createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  UserResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? publicId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? avatarUrl = const $CopyWithPlaceholder(),
    Object? bio = const $CopyWithPlaceholder(),
    Object? publicDefinitionCount = const $CopyWithPlaceholder(),
    Object? followingCount = const $CopyWithPlaceholder(),
    Object? followerCount = const $CopyWithPlaceholder(),
    Object? isFollowedByMe = const $CopyWithPlaceholder(),
    Object? isMutedByMe = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return UserResponse(
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
      bio: bio == const $CopyWithPlaceholder()
          ? _value.bio
          // ignore: cast_nullable_to_non_nullable
          : bio as String,
      publicDefinitionCount:
          publicDefinitionCount == const $CopyWithPlaceholder()
          ? _value.publicDefinitionCount
          // ignore: cast_nullable_to_non_nullable
          : publicDefinitionCount as int,
      followingCount: followingCount == const $CopyWithPlaceholder()
          ? _value.followingCount
          // ignore: cast_nullable_to_non_nullable
          : followingCount as int,
      followerCount: followerCount == const $CopyWithPlaceholder()
          ? _value.followerCount
          // ignore: cast_nullable_to_non_nullable
          : followerCount as int,
      isFollowedByMe: isFollowedByMe == const $CopyWithPlaceholder()
          ? _value.isFollowedByMe
          // ignore: cast_nullable_to_non_nullable
          : isFollowedByMe as bool,
      isMutedByMe: isMutedByMe == const $CopyWithPlaceholder()
          ? _value.isMutedByMe
          // ignore: cast_nullable_to_non_nullable
          : isMutedByMe as bool,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $UserResponseCopyWith on UserResponse {
  /// Returns a callable class that can be used as follows: `instanceOfUserResponse.copyWith(...)` or like so:`instanceOfUserResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserResponseCWProxy get copyWith => _$UserResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UserResponse', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'publicId',
      'name',
      'avatarUrl',
      'bio',
      'publicDefinitionCount',
      'followingCount',
      'followerCount',
      'isFollowedByMe',
      'isMutedByMe',
      'createdAt',
    ],
  );
  final val = UserResponse(
    id: $checkedConvert('id', (v) => v as String),
    publicId: $checkedConvert('publicId', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
    bio: $checkedConvert('bio', (v) => v as String),
    publicDefinitionCount: $checkedConvert(
      'publicDefinitionCount',
      (v) => (v as num).toInt(),
    ),
    followingCount: $checkedConvert(
      'followingCount',
      (v) => (v as num).toInt(),
    ),
    followerCount: $checkedConvert('followerCount', (v) => (v as num).toInt()),
    isFollowedByMe: $checkedConvert('isFollowedByMe', (v) => v as bool),
    isMutedByMe: $checkedConvert('isMutedByMe', (v) => v as bool),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicId': instance.publicId,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'publicDefinitionCount': instance.publicDefinitionCount,
      'followingCount': instance.followingCount,
      'followerCount': instance.followerCount,
      'isFollowedByMe': instance.isFollowedByMe,
      'isMutedByMe': instance.isMutedByMe,
      'createdAt': instance.createdAt.toIso8601String(),
    };
