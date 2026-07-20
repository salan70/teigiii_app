// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateUserRequestCWProxy {
  CreateUserRequest name(String name);

  CreateUserRequest bio(String? bio);

  CreateUserRequest osVersion(String osVersion);

  CreateUserRequest appVersion(String appVersion);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateUserRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateUserRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateUserRequest call({
    String name,
    String? bio,
    String osVersion,
    String appVersion,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateUserRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateUserRequest.copyWith.fieldName(...)`
class _$CreateUserRequestCWProxyImpl implements _$CreateUserRequestCWProxy {
  const _$CreateUserRequestCWProxyImpl(this._value);

  final CreateUserRequest _value;

  @override
  CreateUserRequest name(String name) => this(name: name);

  @override
  CreateUserRequest bio(String? bio) => this(bio: bio);

  @override
  CreateUserRequest osVersion(String osVersion) => this(osVersion: osVersion);

  @override
  CreateUserRequest appVersion(String appVersion) =>
      this(appVersion: appVersion);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateUserRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateUserRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateUserRequest call({
    Object? name = const $CopyWithPlaceholder(),
    Object? bio = const $CopyWithPlaceholder(),
    Object? osVersion = const $CopyWithPlaceholder(),
    Object? appVersion = const $CopyWithPlaceholder(),
  }) {
    return CreateUserRequest(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      bio: bio == const $CopyWithPlaceholder()
          ? _value.bio
          // ignore: cast_nullable_to_non_nullable
          : bio as String?,
      osVersion: osVersion == const $CopyWithPlaceholder()
          ? _value.osVersion
          // ignore: cast_nullable_to_non_nullable
          : osVersion as String,
      appVersion: appVersion == const $CopyWithPlaceholder()
          ? _value.appVersion
          // ignore: cast_nullable_to_non_nullable
          : appVersion as String,
    );
  }
}

extension $CreateUserRequestCopyWith on CreateUserRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCreateUserRequest.copyWith(...)` or like so:`instanceOfCreateUserRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateUserRequestCWProxy get copyWith =>
      _$CreateUserRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserRequest _$CreateUserRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateUserRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name', 'osVersion', 'appVersion']);
      final val = CreateUserRequest(
        name: $checkedConvert('name', (v) => v as String),
        bio: $checkedConvert('bio', (v) => v as String? ?? ''),
        osVersion: $checkedConvert('osVersion', (v) => v as String),
        appVersion: $checkedConvert('appVersion', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CreateUserRequestToJson(CreateUserRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'bio': ?instance.bio,
      'osVersion': instance.osVersion,
      'appVersion': instance.appVersion,
    };
