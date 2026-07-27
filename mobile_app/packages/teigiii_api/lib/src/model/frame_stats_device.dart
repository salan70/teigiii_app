//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'frame_stats_device.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FrameStatsDevice {
  /// Returns a new [FrameStatsDevice] instance.
  FrameStatsDevice({
    required this.appVersion,

    required this.buildNumber,

    required this.flavor,

    required this.platform,

    required this.osVersion,

    required this.deviceModel,

    required this.refreshRateHz,
  });

  @JsonKey(name: r'appVersion', required: true, includeIfNull: false)
  final String appVersion;

  // minimum: 0
  @JsonKey(name: r'buildNumber', required: true, includeIfNull: false)
  final int buildNumber;

  @JsonKey(name: r'flavor', required: true, includeIfNull: false)
  final FrameStatsDeviceFlavorEnum flavor;

  @JsonKey(name: r'platform', required: true, includeIfNull: false)
  final FrameStatsDevicePlatformEnum platform;

  @JsonKey(name: r'osVersion', required: true, includeIfNull: false)
  final String osVersion;

  @JsonKey(name: r'deviceModel', required: true, includeIfNull: false)
  final String deviceModel;

  // minimum: 1
  // maximum: 480
  @JsonKey(name: r'refreshRateHz', required: true, includeIfNull: false)
  final int refreshRateHz;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrameStatsDevice &&
          other.appVersion == appVersion &&
          other.buildNumber == buildNumber &&
          other.flavor == flavor &&
          other.platform == platform &&
          other.osVersion == osVersion &&
          other.deviceModel == deviceModel &&
          other.refreshRateHz == refreshRateHz;

  @override
  int get hashCode =>
      appVersion.hashCode +
      buildNumber.hashCode +
      flavor.hashCode +
      platform.hashCode +
      osVersion.hashCode +
      deviceModel.hashCode +
      refreshRateHz.hashCode;

  factory FrameStatsDevice.fromJson(Map<String, dynamic> json) =>
      _$FrameStatsDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$FrameStatsDeviceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum FrameStatsDeviceFlavorEnum {
  @JsonValue(r'dev')
  dev(r'dev'),
  @JsonValue(r'prod')
  prod(r'prod');

  const FrameStatsDeviceFlavorEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum FrameStatsDevicePlatformEnum {
  @JsonValue(r'ios')
  ios(r'ios'),
  @JsonValue(r'android')
  android(r'android'),
  @JsonValue(r'web')
  web(r'web');

  const FrameStatsDevicePlatformEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
