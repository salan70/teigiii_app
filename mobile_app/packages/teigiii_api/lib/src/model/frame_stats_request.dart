//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/frame_stats_device.dart';
import 'package:teigiii_api/src/model/frame_stats_screen.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'frame_stats_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FrameStatsRequest {
  /// Returns a new [FrameStatsRequest] instance.
  FrameStatsRequest({
    required this.sessionId,

    required this.device,

    required this.screens,
  });

  @JsonKey(name: r'sessionId', required: true, includeIfNull: false)
  final String sessionId;

  @JsonKey(name: r'device', required: true, includeIfNull: false)
  final FrameStatsDevice device;

  @JsonKey(name: r'screens', required: true, includeIfNull: false)
  final List<FrameStatsScreen> screens;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrameStatsRequest &&
          other.sessionId == sessionId &&
          other.device == device &&
          other.screens == screens;

  @override
  int get hashCode => sessionId.hashCode + device.hashCode + screens.hashCode;

  factory FrameStatsRequest.fromJson(Map<String, dynamic> json) =>
      _$FrameStatsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FrameStatsRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
