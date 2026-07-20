// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MeResponseCWProxy {
  MeResponse id(String id);

  MeResponse publicId(String publicId);

  MeResponse name(String name);

  MeResponse avatarUrl(String? avatarUrl);

  MeResponse bio(String bio);

  MeResponse createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MeResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MeResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MeResponse call({
    String id,
    String publicId,
    String name,
    String? avatarUrl,
    String bio,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMeResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMeResponse.copyWith.fieldName(...)`
class _$MeResponseCWProxyImpl implements _$MeResponseCWProxy {
  const _$MeResponseCWProxyImpl(this._value);

  final MeResponse _value;

  @override
  MeResponse id(String id) => this(id: id);

  @override
  MeResponse publicId(String publicId) => this(publicId: publicId);

  @override
  MeResponse name(String name) => this(name: name);

  @override
  MeResponse avatarUrl(String? avatarUrl) => this(avatarUrl: avatarUrl);

  @override
  MeResponse bio(String bio) => this(bio: bio);

  @override
  MeResponse createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MeResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MeResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  MeResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? publicId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? avatarUrl = const $CopyWithPlaceholder(),
    Object? bio = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return MeResponse(
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
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $MeResponseCopyWith on MeResponse {
  /// Returns a callable class that can be used as follows: `instanceOfMeResponse.copyWith(...)` or like so:`instanceOfMeResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MeResponseCWProxy get copyWith => _$MeResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeResponse _$MeResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MeResponse', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'publicId',
          'name',
          'avatarUrl',
          'bio',
          'createdAt',
        ],
      );
      final val = MeResponse(
        id: $checkedConvert('id', (v) => v as String),
        publicId: $checkedConvert('publicId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
        bio: $checkedConvert('bio', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MeResponseToJson(MeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicId': instance.publicId,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'createdAt': instance.createdAt.toIso8601String(),
    };
