// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_stats_screen.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FrameStatsScreenCWProxy {
  FrameStatsScreen screenName(String screenName);

  FrameStatsScreen recordedAt(DateTime recordedAt);

  FrameStatsScreen frameCount(int frameCount);

  FrameStatsScreen slowBuildCount(int slowBuildCount);

  FrameStatsScreen slowRasterCount(int slowRasterCount);

  FrameStatsScreen frozenCount(int frozenCount);

  FrameStatsScreen sumBuildUs(int sumBuildUs);

  FrameStatsScreen sumRasterUs(int sumRasterUs);

  FrameStatsScreen maxBuildUs(int maxBuildUs);

  FrameStatsScreen maxRasterUs(int maxRasterUs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FrameStatsScreen(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FrameStatsScreen(...).copyWith(id: 12, name: "My name")
  /// ````
  FrameStatsScreen call({
    String screenName,
    DateTime recordedAt,
    int frameCount,
    int slowBuildCount,
    int slowRasterCount,
    int frozenCount,
    int sumBuildUs,
    int sumRasterUs,
    int maxBuildUs,
    int maxRasterUs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFrameStatsScreen.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFrameStatsScreen.copyWith.fieldName(...)`
class _$FrameStatsScreenCWProxyImpl implements _$FrameStatsScreenCWProxy {
  const _$FrameStatsScreenCWProxyImpl(this._value);

  final FrameStatsScreen _value;

  @override
  FrameStatsScreen screenName(String screenName) =>
      this(screenName: screenName);

  @override
  FrameStatsScreen recordedAt(DateTime recordedAt) =>
      this(recordedAt: recordedAt);

  @override
  FrameStatsScreen frameCount(int frameCount) => this(frameCount: frameCount);

  @override
  FrameStatsScreen slowBuildCount(int slowBuildCount) =>
      this(slowBuildCount: slowBuildCount);

  @override
  FrameStatsScreen slowRasterCount(int slowRasterCount) =>
      this(slowRasterCount: slowRasterCount);

  @override
  FrameStatsScreen frozenCount(int frozenCount) =>
      this(frozenCount: frozenCount);

  @override
  FrameStatsScreen sumBuildUs(int sumBuildUs) => this(sumBuildUs: sumBuildUs);

  @override
  FrameStatsScreen sumRasterUs(int sumRasterUs) =>
      this(sumRasterUs: sumRasterUs);

  @override
  FrameStatsScreen maxBuildUs(int maxBuildUs) => this(maxBuildUs: maxBuildUs);

  @override
  FrameStatsScreen maxRasterUs(int maxRasterUs) =>
      this(maxRasterUs: maxRasterUs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FrameStatsScreen(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FrameStatsScreen(...).copyWith(id: 12, name: "My name")
  /// ````
  FrameStatsScreen call({
    Object? screenName = const $CopyWithPlaceholder(),
    Object? recordedAt = const $CopyWithPlaceholder(),
    Object? frameCount = const $CopyWithPlaceholder(),
    Object? slowBuildCount = const $CopyWithPlaceholder(),
    Object? slowRasterCount = const $CopyWithPlaceholder(),
    Object? frozenCount = const $CopyWithPlaceholder(),
    Object? sumBuildUs = const $CopyWithPlaceholder(),
    Object? sumRasterUs = const $CopyWithPlaceholder(),
    Object? maxBuildUs = const $CopyWithPlaceholder(),
    Object? maxRasterUs = const $CopyWithPlaceholder(),
  }) {
    return FrameStatsScreen(
      screenName: screenName == const $CopyWithPlaceholder()
          ? _value.screenName
          // ignore: cast_nullable_to_non_nullable
          : screenName as String,
      recordedAt: recordedAt == const $CopyWithPlaceholder()
          ? _value.recordedAt
          // ignore: cast_nullable_to_non_nullable
          : recordedAt as DateTime,
      frameCount: frameCount == const $CopyWithPlaceholder()
          ? _value.frameCount
          // ignore: cast_nullable_to_non_nullable
          : frameCount as int,
      slowBuildCount: slowBuildCount == const $CopyWithPlaceholder()
          ? _value.slowBuildCount
          // ignore: cast_nullable_to_non_nullable
          : slowBuildCount as int,
      slowRasterCount: slowRasterCount == const $CopyWithPlaceholder()
          ? _value.slowRasterCount
          // ignore: cast_nullable_to_non_nullable
          : slowRasterCount as int,
      frozenCount: frozenCount == const $CopyWithPlaceholder()
          ? _value.frozenCount
          // ignore: cast_nullable_to_non_nullable
          : frozenCount as int,
      sumBuildUs: sumBuildUs == const $CopyWithPlaceholder()
          ? _value.sumBuildUs
          // ignore: cast_nullable_to_non_nullable
          : sumBuildUs as int,
      sumRasterUs: sumRasterUs == const $CopyWithPlaceholder()
          ? _value.sumRasterUs
          // ignore: cast_nullable_to_non_nullable
          : sumRasterUs as int,
      maxBuildUs: maxBuildUs == const $CopyWithPlaceholder()
          ? _value.maxBuildUs
          // ignore: cast_nullable_to_non_nullable
          : maxBuildUs as int,
      maxRasterUs: maxRasterUs == const $CopyWithPlaceholder()
          ? _value.maxRasterUs
          // ignore: cast_nullable_to_non_nullable
          : maxRasterUs as int,
    );
  }
}

extension $FrameStatsScreenCopyWith on FrameStatsScreen {
  /// Returns a callable class that can be used as follows: `instanceOfFrameStatsScreen.copyWith(...)` or like so:`instanceOfFrameStatsScreen.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FrameStatsScreenCWProxy get copyWith => _$FrameStatsScreenCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrameStatsScreen _$FrameStatsScreenFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FrameStatsScreen', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'screenName',
          'recordedAt',
          'frameCount',
          'slowBuildCount',
          'slowRasterCount',
          'frozenCount',
          'sumBuildUs',
          'sumRasterUs',
          'maxBuildUs',
          'maxRasterUs',
        ],
      );
      final val = FrameStatsScreen(
        screenName: $checkedConvert('screenName', (v) => v as String),
        recordedAt: $checkedConvert(
          'recordedAt',
          (v) => DateTime.parse(v as String),
        ),
        frameCount: $checkedConvert('frameCount', (v) => (v as num).toInt()),
        slowBuildCount: $checkedConvert(
          'slowBuildCount',
          (v) => (v as num).toInt(),
        ),
        slowRasterCount: $checkedConvert(
          'slowRasterCount',
          (v) => (v as num).toInt(),
        ),
        frozenCount: $checkedConvert('frozenCount', (v) => (v as num).toInt()),
        sumBuildUs: $checkedConvert('sumBuildUs', (v) => (v as num).toInt()),
        sumRasterUs: $checkedConvert('sumRasterUs', (v) => (v as num).toInt()),
        maxBuildUs: $checkedConvert('maxBuildUs', (v) => (v as num).toInt()),
        maxRasterUs: $checkedConvert('maxRasterUs', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$FrameStatsScreenToJson(FrameStatsScreen instance) =>
    <String, dynamic>{
      'screenName': instance.screenName,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'frameCount': instance.frameCount,
      'slowBuildCount': instance.slowBuildCount,
      'slowRasterCount': instance.slowRasterCount,
      'frozenCount': instance.frozenCount,
      'sumBuildUs': instance.sumBuildUs,
      'sumRasterUs': instance.sumRasterUs,
      'maxBuildUs': instance.maxBuildUs,
      'maxRasterUs': instance.maxRasterUs,
    };
