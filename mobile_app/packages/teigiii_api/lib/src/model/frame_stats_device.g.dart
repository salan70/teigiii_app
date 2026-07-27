// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_stats_device.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FrameStatsDeviceCWProxy {
  FrameStatsDevice appVersion(String appVersion);

  FrameStatsDevice buildNumber(int buildNumber);

  FrameStatsDevice flavor(FrameStatsDeviceFlavorEnum flavor);

  FrameStatsDevice platform(FrameStatsDevicePlatformEnum platform);

  FrameStatsDevice osVersion(String osVersion);

  FrameStatsDevice deviceModel(String deviceModel);

  FrameStatsDevice refreshRateHz(int refreshRateHz);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FrameStatsDevice(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FrameStatsDevice(...).copyWith(id: 12, name: "My name")
  /// ````
  FrameStatsDevice call({
    String appVersion,
    int buildNumber,
    FrameStatsDeviceFlavorEnum flavor,
    FrameStatsDevicePlatformEnum platform,
    String osVersion,
    String deviceModel,
    int refreshRateHz,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFrameStatsDevice.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFrameStatsDevice.copyWith.fieldName(...)`
class _$FrameStatsDeviceCWProxyImpl implements _$FrameStatsDeviceCWProxy {
  const _$FrameStatsDeviceCWProxyImpl(this._value);

  final FrameStatsDevice _value;

  @override
  FrameStatsDevice appVersion(String appVersion) =>
      this(appVersion: appVersion);

  @override
  FrameStatsDevice buildNumber(int buildNumber) =>
      this(buildNumber: buildNumber);

  @override
  FrameStatsDevice flavor(FrameStatsDeviceFlavorEnum flavor) =>
      this(flavor: flavor);

  @override
  FrameStatsDevice platform(FrameStatsDevicePlatformEnum platform) =>
      this(platform: platform);

  @override
  FrameStatsDevice osVersion(String osVersion) => this(osVersion: osVersion);

  @override
  FrameStatsDevice deviceModel(String deviceModel) =>
      this(deviceModel: deviceModel);

  @override
  FrameStatsDevice refreshRateHz(int refreshRateHz) =>
      this(refreshRateHz: refreshRateHz);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FrameStatsDevice(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FrameStatsDevice(...).copyWith(id: 12, name: "My name")
  /// ````
  FrameStatsDevice call({
    Object? appVersion = const $CopyWithPlaceholder(),
    Object? buildNumber = const $CopyWithPlaceholder(),
    Object? flavor = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
    Object? osVersion = const $CopyWithPlaceholder(),
    Object? deviceModel = const $CopyWithPlaceholder(),
    Object? refreshRateHz = const $CopyWithPlaceholder(),
  }) {
    return FrameStatsDevice(
      appVersion: appVersion == const $CopyWithPlaceholder()
          ? _value.appVersion
          // ignore: cast_nullable_to_non_nullable
          : appVersion as String,
      buildNumber: buildNumber == const $CopyWithPlaceholder()
          ? _value.buildNumber
          // ignore: cast_nullable_to_non_nullable
          : buildNumber as int,
      flavor: flavor == const $CopyWithPlaceholder()
          ? _value.flavor
          // ignore: cast_nullable_to_non_nullable
          : flavor as FrameStatsDeviceFlavorEnum,
      platform: platform == const $CopyWithPlaceholder()
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as FrameStatsDevicePlatformEnum,
      osVersion: osVersion == const $CopyWithPlaceholder()
          ? _value.osVersion
          // ignore: cast_nullable_to_non_nullable
          : osVersion as String,
      deviceModel: deviceModel == const $CopyWithPlaceholder()
          ? _value.deviceModel
          // ignore: cast_nullable_to_non_nullable
          : deviceModel as String,
      refreshRateHz: refreshRateHz == const $CopyWithPlaceholder()
          ? _value.refreshRateHz
          // ignore: cast_nullable_to_non_nullable
          : refreshRateHz as int,
    );
  }
}

extension $FrameStatsDeviceCopyWith on FrameStatsDevice {
  /// Returns a callable class that can be used as follows: `instanceOfFrameStatsDevice.copyWith(...)` or like so:`instanceOfFrameStatsDevice.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FrameStatsDeviceCWProxy get copyWith => _$FrameStatsDeviceCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrameStatsDevice _$FrameStatsDeviceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FrameStatsDevice', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'appVersion',
          'buildNumber',
          'flavor',
          'platform',
          'osVersion',
          'deviceModel',
          'refreshRateHz',
        ],
      );
      final val = FrameStatsDevice(
        appVersion: $checkedConvert('appVersion', (v) => v as String),
        buildNumber: $checkedConvert('buildNumber', (v) => (v as num).toInt()),
        flavor: $checkedConvert(
          'flavor',
          (v) => $enumDecode(_$FrameStatsDeviceFlavorEnumEnumMap, v),
        ),
        platform: $checkedConvert(
          'platform',
          (v) => $enumDecode(_$FrameStatsDevicePlatformEnumEnumMap, v),
        ),
        osVersion: $checkedConvert('osVersion', (v) => v as String),
        deviceModel: $checkedConvert('deviceModel', (v) => v as String),
        refreshRateHz: $checkedConvert(
          'refreshRateHz',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$FrameStatsDeviceToJson(FrameStatsDevice instance) =>
    <String, dynamic>{
      'appVersion': instance.appVersion,
      'buildNumber': instance.buildNumber,
      'flavor': _$FrameStatsDeviceFlavorEnumEnumMap[instance.flavor]!,
      'platform': _$FrameStatsDevicePlatformEnumEnumMap[instance.platform]!,
      'osVersion': instance.osVersion,
      'deviceModel': instance.deviceModel,
      'refreshRateHz': instance.refreshRateHz,
    };

const _$FrameStatsDeviceFlavorEnumEnumMap = {
  FrameStatsDeviceFlavorEnum.dev: 'dev',
  FrameStatsDeviceFlavorEnum.prod: 'prod',
};

const _$FrameStatsDevicePlatformEnumEnumMap = {
  FrameStatsDevicePlatformEnum.ios: 'ios',
  FrameStatsDevicePlatformEnum.android: 'android',
  FrameStatsDevicePlatformEnum.web: 'web',
};
