import 'package:flutter/foundation.dart';

/// 1 画面ぶんのフレーム集計。
///
/// 分布・パーセンタイルは持たない。パーセンタイルは端末ごとに算出しても
/// 母集団のパーセンタイルにならず、後からバージョン別・端末別に再集計できない。
/// カウンタなら SUM して割るだけで任意の切り口の比率が出せる。
@immutable
class ScreenFrameStats {
  const ScreenFrameStats({
    required this.screenName,
    required this.frameCount,
    required this.slowBuildCount,
    required this.slowRasterCount,
    required this.frozenCount,
    required this.sumBuildUs,
    required this.sumRasterUs,
    required this.maxBuildUs,
    required this.maxRasterUs,
  });

  final String screenName;
  final int frameCount;

  /// buildDuration が端末のフレーム予算を超えた回数。
  final int slowBuildCount;

  /// rasterDuration が端末のフレーム予算を超えた回数。
  final int slowRasterCount;

  /// totalSpan が [frozenFrameThreshold] を超えた回数。
  final int frozenCount;

  final int sumBuildUs;
  final int sumRasterUs;
  final int maxBuildUs;
  final int maxRasterUs;

  /// 同一画面の集計を合算する。
  ///
  /// 1 セッション中に同じ画面を複数回訪れると区間が分かれるため、
  /// 送信時に画面名でまとめて行数を減らす。カウンタなので単純加算でよい。
  ScreenFrameStats merge(ScreenFrameStats other) {
    assert(
      other.screenName == screenName,
      '異なる画面の集計は合算できない: $screenName / ${other.screenName}',
    );
    return ScreenFrameStats(
      screenName: screenName,
      frameCount: frameCount + other.frameCount,
      slowBuildCount: slowBuildCount + other.slowBuildCount,
      slowRasterCount: slowRasterCount + other.slowRasterCount,
      frozenCount: frozenCount + other.frozenCount,
      sumBuildUs: sumBuildUs + other.sumBuildUs,
      sumRasterUs: sumRasterUs + other.sumRasterUs,
      maxBuildUs: maxBuildUs > other.maxBuildUs ? maxBuildUs : other.maxBuildUs,
      maxRasterUs: maxRasterUs > other.maxRasterUs
          ? maxRasterUs
          : other.maxRasterUs,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ScreenFrameStats &&
      other.screenName == screenName &&
      other.frameCount == frameCount &&
      other.slowBuildCount == slowBuildCount &&
      other.slowRasterCount == slowRasterCount &&
      other.frozenCount == frozenCount &&
      other.sumBuildUs == sumBuildUs &&
      other.sumRasterUs == sumRasterUs &&
      other.maxBuildUs == maxBuildUs &&
      other.maxRasterUs == maxRasterUs;

  @override
  int get hashCode => Object.hash(
    screenName,
    frameCount,
    slowBuildCount,
    slowRasterCount,
    frozenCount,
    sumBuildUs,
    sumRasterUs,
    maxBuildUs,
    maxRasterUs,
  );

  @override
  String toString() =>
      'ScreenFrameStats($screenName, frames: $frameCount, '
      'slowBuild: $slowBuildCount, slowRaster: $slowRasterCount, '
      'frozen: $frozenCount)';
}
