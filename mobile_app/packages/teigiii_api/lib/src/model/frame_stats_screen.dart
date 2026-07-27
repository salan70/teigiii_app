//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'frame_stats_screen.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FrameStatsScreen {
  /// Returns a new [FrameStatsScreen] instance.
  FrameStatsScreen({
    required this.screenName,

    required this.recordedAt,

    required this.frameCount,

    required this.slowBuildCount,

    required this.slowRasterCount,

    required this.frozenCount,

    required this.sumBuildUs,

    required this.sumRasterUs,

    required this.maxBuildUs,

    required this.maxRasterUs,
  });

  @JsonKey(name: r'screenName', required: true, includeIfNull: false)
  final String screenName;

  @JsonKey(name: r'recordedAt', required: true, includeIfNull: false)
  final DateTime recordedAt;

  // minimum: 1
  @JsonKey(name: r'frameCount', required: true, includeIfNull: false)
  final int frameCount;

  // minimum: 0
  @JsonKey(name: r'slowBuildCount', required: true, includeIfNull: false)
  final int slowBuildCount;

  // minimum: 0
  @JsonKey(name: r'slowRasterCount', required: true, includeIfNull: false)
  final int slowRasterCount;

  // minimum: 0
  @JsonKey(name: r'frozenCount', required: true, includeIfNull: false)
  final int frozenCount;

  // minimum: 0
  @JsonKey(name: r'sumBuildUs', required: true, includeIfNull: false)
  final int sumBuildUs;

  // minimum: 0
  @JsonKey(name: r'sumRasterUs', required: true, includeIfNull: false)
  final int sumRasterUs;

  // minimum: 0
  @JsonKey(name: r'maxBuildUs', required: true, includeIfNull: false)
  final int maxBuildUs;

  // minimum: 0
  @JsonKey(name: r'maxRasterUs', required: true, includeIfNull: false)
  final int maxRasterUs;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrameStatsScreen &&
          other.screenName == screenName &&
          other.recordedAt == recordedAt &&
          other.frameCount == frameCount &&
          other.slowBuildCount == slowBuildCount &&
          other.slowRasterCount == slowRasterCount &&
          other.frozenCount == frozenCount &&
          other.sumBuildUs == sumBuildUs &&
          other.sumRasterUs == sumRasterUs &&
          other.maxBuildUs == maxBuildUs &&
          other.maxRasterUs == maxRasterUs;

  @override
  int get hashCode =>
      screenName.hashCode +
      recordedAt.hashCode +
      frameCount.hashCode +
      slowBuildCount.hashCode +
      slowRasterCount.hashCode +
      frozenCount.hashCode +
      sumBuildUs.hashCode +
      sumRasterUs.hashCode +
      maxBuildUs.hashCode +
      maxRasterUs.hashCode;

  factory FrameStatsScreen.fromJson(Map<String, dynamic> json) =>
      _$FrameStatsScreenFromJson(json);

  Map<String, dynamic> toJson() => _$FrameStatsScreenToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
