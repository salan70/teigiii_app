// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_summary.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserSummaryCWProxy {
  UserSummary id(String id);

  UserSummary publicId(String publicId);

  UserSummary name(String name);

  UserSummary avatarUrl(String? avatarUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  UserSummary call({
    String id,
    String publicId,
    String name,
    String? avatarUrl,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserSummary.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserSummary.copyWith.fieldName(...)`
class _$UserSummaryCWProxyImpl implements _$UserSummaryCWProxy {
  const _$UserSummaryCWProxyImpl(this._value);

  final UserSummary _value;

  @override
  UserSummary id(String id) => this(id: id);

  @override
  UserSummary publicId(String publicId) => this(publicId: publicId);

  @override
  UserSummary name(String name) => this(name: name);

  @override
  UserSummary avatarUrl(String? avatarUrl) => this(avatarUrl: avatarUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  UserSummary call({
    Object? id = const $CopyWithPlaceholder(),
    Object? publicId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? avatarUrl = const $CopyWithPlaceholder(),
  }) {
    return UserSummary(
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
    );
  }
}

extension $UserSummaryCopyWith on UserSummary {
  /// Returns a callable class that can be used as follows: `instanceOfUserSummary.copyWith(...)` or like so:`instanceOfUserSummary.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserSummaryCWProxy get copyWith => _$UserSummaryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSummary _$UserSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserSummary', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'publicId', 'name', 'avatarUrl'],
      );
      final val = UserSummary(
        id: $checkedConvert('id', (v) => v as String),
        publicId: $checkedConvert('publicId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UserSummaryToJson(UserSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicId': instance.publicId,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
    };
