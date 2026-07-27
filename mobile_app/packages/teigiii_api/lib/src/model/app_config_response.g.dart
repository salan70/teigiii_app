// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppConfigResponseCWProxy {
  AppConfigResponse minAppVersionIos(String minAppVersionIos);

  AppConfigResponse minAppVersionAndroid(String minAppVersionAndroid);

  AppConfigResponse inMaintenance(bool inMaintenance);

  AppConfigResponse maintenanceScheduledEndTime(
    DateTime? maintenanceScheduledEndTime,
  );

  AppConfigResponse perfTelemetryEnabled(bool perfTelemetryEnabled);

  AppConfigResponse updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfigResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfigResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfigResponse call({
    String minAppVersionIos,
    String minAppVersionAndroid,
    bool inMaintenance,
    DateTime? maintenanceScheduledEndTime,
    bool perfTelemetryEnabled,
    DateTime updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppConfigResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppConfigResponse.copyWith.fieldName(...)`
class _$AppConfigResponseCWProxyImpl implements _$AppConfigResponseCWProxy {
  const _$AppConfigResponseCWProxyImpl(this._value);

  final AppConfigResponse _value;

  @override
  AppConfigResponse minAppVersionIos(String minAppVersionIos) =>
      this(minAppVersionIos: minAppVersionIos);

  @override
  AppConfigResponse minAppVersionAndroid(String minAppVersionAndroid) =>
      this(minAppVersionAndroid: minAppVersionAndroid);

  @override
  AppConfigResponse inMaintenance(bool inMaintenance) =>
      this(inMaintenance: inMaintenance);

  @override
  AppConfigResponse maintenanceScheduledEndTime(
    DateTime? maintenanceScheduledEndTime,
  ) => this(maintenanceScheduledEndTime: maintenanceScheduledEndTime);

  @override
  AppConfigResponse perfTelemetryEnabled(bool perfTelemetryEnabled) =>
      this(perfTelemetryEnabled: perfTelemetryEnabled);

  @override
  AppConfigResponse updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfigResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfigResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfigResponse call({
    Object? minAppVersionIos = const $CopyWithPlaceholder(),
    Object? minAppVersionAndroid = const $CopyWithPlaceholder(),
    Object? inMaintenance = const $CopyWithPlaceholder(),
    Object? maintenanceScheduledEndTime = const $CopyWithPlaceholder(),
    Object? perfTelemetryEnabled = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return AppConfigResponse(
      minAppVersionIos: minAppVersionIos == const $CopyWithPlaceholder()
          ? _value.minAppVersionIos
          // ignore: cast_nullable_to_non_nullable
          : minAppVersionIos as String,
      minAppVersionAndroid: minAppVersionAndroid == const $CopyWithPlaceholder()
          ? _value.minAppVersionAndroid
          // ignore: cast_nullable_to_non_nullable
          : minAppVersionAndroid as String,
      inMaintenance: inMaintenance == const $CopyWithPlaceholder()
          ? _value.inMaintenance
          // ignore: cast_nullable_to_non_nullable
          : inMaintenance as bool,
      maintenanceScheduledEndTime:
          maintenanceScheduledEndTime == const $CopyWithPlaceholder()
          ? _value.maintenanceScheduledEndTime
          // ignore: cast_nullable_to_non_nullable
          : maintenanceScheduledEndTime as DateTime?,
      perfTelemetryEnabled: perfTelemetryEnabled == const $CopyWithPlaceholder()
          ? _value.perfTelemetryEnabled
          // ignore: cast_nullable_to_non_nullable
          : perfTelemetryEnabled as bool,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
    );
  }
}

extension $AppConfigResponseCopyWith on AppConfigResponse {
  /// Returns a callable class that can be used as follows: `instanceOfAppConfigResponse.copyWith(...)` or like so:`instanceOfAppConfigResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppConfigResponseCWProxy get copyWith =>
      _$AppConfigResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigResponse _$AppConfigResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AppConfigResponse', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'minAppVersionIos',
      'minAppVersionAndroid',
      'inMaintenance',
      'maintenanceScheduledEndTime',
      'perfTelemetryEnabled',
      'updatedAt',
    ],
  );
  final val = AppConfigResponse(
    minAppVersionIos: $checkedConvert('minAppVersionIos', (v) => v as String),
    minAppVersionAndroid: $checkedConvert(
      'minAppVersionAndroid',
      (v) => v as String,
    ),
    inMaintenance: $checkedConvert('inMaintenance', (v) => v as bool),
    maintenanceScheduledEndTime: $checkedConvert(
      'maintenanceScheduledEndTime',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    perfTelemetryEnabled: $checkedConvert(
      'perfTelemetryEnabled',
      (v) => v as bool,
    ),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$AppConfigResponseToJson(AppConfigResponse instance) =>
    <String, dynamic>{
      'minAppVersionIos': instance.minAppVersionIos,
      'minAppVersionAndroid': instance.minAppVersionAndroid,
      'inMaintenance': instance.inMaintenance,
      'maintenanceScheduledEndTime': instance.maintenanceScheduledEndTime
          ?.toIso8601String(),
      'perfTelemetryEnabled': instance.perfTelemetryEnabled,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
