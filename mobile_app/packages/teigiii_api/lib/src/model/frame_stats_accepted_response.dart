//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'frame_stats_accepted_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FrameStatsAcceptedResponse {
  /// Returns a new [FrameStatsAcceptedResponse] instance.
  FrameStatsAcceptedResponse({required this.accepted, required this.disabled});

  // minimum: 0
  @JsonKey(name: r'accepted', required: true, includeIfNull: false)
  final int accepted;

  @JsonKey(name: r'disabled', required: true, includeIfNull: false)
  final bool disabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrameStatsAcceptedResponse &&
          other.accepted == accepted &&
          other.disabled == disabled;

  @override
  int get hashCode => accepted.hashCode + disabled.hashCode;

  factory FrameStatsAcceptedResponse.fromJson(Map<String, dynamic> json) =>
      _$FrameStatsAcceptedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FrameStatsAcceptedResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
