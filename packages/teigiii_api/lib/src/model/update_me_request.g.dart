// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_me_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateMeRequestCWProxy {
  UpdateMeRequest name(String? name);

  UpdateMeRequest bio(String? bio);

  UpdateMeRequest osVersion(String? osVersion);

  UpdateMeRequest appVersion(String? appVersion);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateMeRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateMeRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateMeRequest call({
    String? name,
    String? bio,
    String? osVersion,
    String? appVersion,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateMeRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateMeRequest.copyWith.fieldName(...)`
class _$UpdateMeRequestCWProxyImpl implements _$UpdateMeRequestCWProxy {
  const _$UpdateMeRequestCWProxyImpl(this._value);

  final UpdateMeRequest _value;

  @override
  UpdateMeRequest name(String? name) => this(name: name);

  @override
  UpdateMeRequest bio(String? bio) => this(bio: bio);

  @override
  UpdateMeRequest osVersion(String? osVersion) => this(osVersion: osVersion);

  @override
  UpdateMeRequest appVersion(String? appVersion) =>
      this(appVersion: appVersion);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateMeRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateMeRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateMeRequest call({
    Object? name = const $CopyWithPlaceholder(),
    Object? bio = const $CopyWithPlaceholder(),
    Object? osVersion = const $CopyWithPlaceholder(),
    Object? appVersion = const $CopyWithPlaceholder(),
  }) {
    return UpdateMeRequest(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      bio: bio == const $CopyWithPlaceholder()
          ? _value.bio
          // ignore: cast_nullable_to_non_nullable
          : bio as String?,
      osVersion: osVersion == const $CopyWithPlaceholder()
          ? _value.osVersion
          // ignore: cast_nullable_to_non_nullable
          : osVersion as String?,
      appVersion: appVersion == const $CopyWithPlaceholder()
          ? _value.appVersion
          // ignore: cast_nullable_to_non_nullable
          : appVersion as String?,
    );
  }
}

extension $UpdateMeRequestCopyWith on UpdateMeRequest {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateMeRequest.copyWith(...)` or like so:`instanceOfUpdateMeRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateMeRequestCWProxy get copyWith => _$UpdateMeRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMeRequest _$UpdateMeRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UpdateMeRequest', json, ($checkedConvert) {
      final val = UpdateMeRequest(
        name: $checkedConvert('name', (v) => v as String?),
        bio: $checkedConvert('bio', (v) => v as String?),
        osVersion: $checkedConvert('osVersion', (v) => v as String?),
        appVersion: $checkedConvert('appVersion', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UpdateMeRequestToJson(UpdateMeRequest instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'bio': ?instance.bio,
      'osVersion': ?instance.osVersion,
      'appVersion': ?instance.appVersion,
    };
