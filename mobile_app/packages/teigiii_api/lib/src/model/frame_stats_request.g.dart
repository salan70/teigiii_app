// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_stats_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FrameStatsRequestCWProxy {
  FrameStatsRequest sessionId(String sessionId);

  FrameStatsRequest device(FrameStatsDevice device);

  FrameStatsRequest screens(List<FrameStatsScreen> screens);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FrameStatsRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FrameStatsRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  FrameStatsRequest call({
    String sessionId,
    FrameStatsDevice device,
    List<FrameStatsScreen> screens,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFrameStatsRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFrameStatsRequest.copyWith.fieldName(...)`
class _$FrameStatsRequestCWProxyImpl implements _$FrameStatsRequestCWProxy {
  const _$FrameStatsRequestCWProxyImpl(this._value);

  final FrameStatsRequest _value;

  @override
  FrameStatsRequest sessionId(String sessionId) => this(sessionId: sessionId);

  @override
  FrameStatsRequest device(FrameStatsDevice device) => this(device: device);

  @override
  FrameStatsRequest screens(List<FrameStatsScreen> screens) =>
      this(screens: screens);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FrameStatsRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FrameStatsRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  FrameStatsRequest call({
    Object? sessionId = const $CopyWithPlaceholder(),
    Object? device = const $CopyWithPlaceholder(),
    Object? screens = const $CopyWithPlaceholder(),
  }) {
    return FrameStatsRequest(
      sessionId: sessionId == const $CopyWithPlaceholder()
          ? _value.sessionId
          // ignore: cast_nullable_to_non_nullable
          : sessionId as String,
      device: device == const $CopyWithPlaceholder()
          ? _value.device
          // ignore: cast_nullable_to_non_nullable
          : device as FrameStatsDevice,
      screens: screens == const $CopyWithPlaceholder()
          ? _value.screens
          // ignore: cast_nullable_to_non_nullable
          : screens as List<FrameStatsScreen>,
    );
  }
}

extension $FrameStatsRequestCopyWith on FrameStatsRequest {
  /// Returns a callable class that can be used as follows: `instanceOfFrameStatsRequest.copyWith(...)` or like so:`instanceOfFrameStatsRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FrameStatsRequestCWProxy get copyWith =>
      _$FrameStatsRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrameStatsRequest _$FrameStatsRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FrameStatsRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sessionId', 'device', 'screens']);
      final val = FrameStatsRequest(
        sessionId: $checkedConvert('sessionId', (v) => v as String),
        device: $checkedConvert(
          'device',
          (v) => FrameStatsDevice.fromJson(v as Map<String, dynamic>),
        ),
        screens: $checkedConvert(
          'screens',
          (v) => (v as List<dynamic>)
              .map((e) => FrameStatsScreen.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$FrameStatsRequestToJson(FrameStatsRequest instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'device': instance.device.toJson(),
      'screens': instance.screens.map((e) => e.toJson()).toList(),
    };
