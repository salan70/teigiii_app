//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_config_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AppConfigResponse {
  /// Returns a new [AppConfigResponse] instance.
  AppConfigResponse({
    required this.minAppVersionIos,

    required this.minAppVersionAndroid,

    required this.inMaintenance,

    required this.maintenanceScheduledEndTime,

    required this.updatedAt,
  });

  @JsonKey(name: r'minAppVersionIos', required: true, includeIfNull: false)
  final String minAppVersionIos;

  @JsonKey(name: r'minAppVersionAndroid', required: true, includeIfNull: false)
  final String minAppVersionAndroid;

  @JsonKey(name: r'inMaintenance', required: true, includeIfNull: false)
  final bool inMaintenance;

  @JsonKey(
    name: r'maintenanceScheduledEndTime',
    required: true,
    includeIfNull: true,
  )
  final DateTime? maintenanceScheduledEndTime;

  @JsonKey(name: r'updatedAt', required: true, includeIfNull: false)
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfigResponse &&
          other.minAppVersionIos == minAppVersionIos &&
          other.minAppVersionAndroid == minAppVersionAndroid &&
          other.inMaintenance == inMaintenance &&
          other.maintenanceScheduledEndTime == maintenanceScheduledEndTime &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      minAppVersionIos.hashCode +
      minAppVersionAndroid.hashCode +
      inMaintenance.hashCode +
      (maintenanceScheduledEndTime == null
          ? 0
          : maintenanceScheduledEndTime.hashCode) +
      updatedAt.hashCode;

  factory AppConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$AppConfigResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
