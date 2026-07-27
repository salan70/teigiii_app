import 'dart:ui';

import 'screen_frame_stats.dart';

/// フリーズと見なす totalSpan の閾値。
///
/// Flutter / Firebase の慣例に合わせて 700ms とする。
const frozenFrameThreshold = Duration(milliseconds: 700);

/// 保持する画面区間の上限。
///
/// 超過した場合は最も古い区間から捨てる。バックグラウンドで
/// FrameTiming が届かないまま画面遷移が続いた場合の上限。
const _maxSegments = 64;

/// フレーム計測を画面ごとに集計する。
///
/// ## 遅延バッチと画面遷移境界の対応付け（契約）
///
/// `SchedulerBinding.addTimingsCallback` の配信は release ビルドで
/// **約 1 秒ごとのバッチ**であり、コールバック実行時点の「現在の画面」に
/// 加算すると、遷移前に生成されたフレームが遷移後の画面に計上される。
/// また `FrameTiming` のタイムスタンプは `DateTime` と epoch が一致しないため、
/// wall-clock と突き合わせても解決できない。
///
/// そこで本クラスは **フレームの生成順序**で対応付ける:
///
/// - [onFrameProduced] を毎フレーム同期的に呼び、生成済みフレーム数
///   （[_producedFrames]）をリアルタイムに数える
/// - 画面が変わったら [onScreenChanged] を呼び、その時点の
///   [_producedFrames] を区間の境界として記録する
/// - [onTimings] で受け取った `FrameTiming` は到着順に 1 つずつ
///   [_reportedFrames] を進め、その序数が属する区間へ加算する
///
/// `FrameTiming` は生成されたフレームごとに生成順で 1 件ずつ報告されるため、
/// 序数は生成時点の区間と一致する。したがってバッチ配信が何秒遅れても、
/// 連続遷移・タブ切替・遷移直後の background のいずれでも
/// **旧画面のフレームが新画面へ混入しない**。
///
/// @doc doc/specs/app-performance-telemetry.md#遅延バッチと画面遷移境界の対応付け-契約
class FrameStatsCollector {
  FrameStatsCollector({required this.frameBudget});

  /// 端末のリフレッシュレートから算出したフレーム予算。
  ///
  /// 120Hz 端末の予算は 8.3ms であり、60Hz 固定で判定すると
  /// 端末間で slow の定義が崩れる。
  final Duration frameBudget;

  final _segments = <_ScreenSegment>[];

  /// 生成済みフレーム数（リアルタイム）。
  int _producedFrames = 0;

  /// 集計済みフレーム数（FrameTiming の到着順）。
  int _reportedFrames = 0;

  /// フレームを 1 枚生成したことを記録する。
  void onFrameProduced() => _producedFrames++;

  /// 表示中の画面が変わったことを記録する。
  ///
  /// 同じ画面名が連続した場合は区間を分けない。
  void onScreenChanged(String screenName) {
    final current = _segments.isEmpty ? null : _segments.last;
    if (current != null && current.screenName == screenName) {
      return;
    }

    current?.endOrdinal = _producedFrames;
    _segments.add(
      _ScreenSegment(screenName: screenName, startOrdinal: _producedFrames),
    );

    while (_segments.length > _maxSegments) {
      _segments.removeAt(0);
    }
  }

  /// [FrameTiming] のバッチを集計する。
  void onTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      _reportedFrames++;
      _segmentFor(_reportedFrames)?.add(timing, frameBudget);
    }
  }

  /// 序数 [ordinal] のフレームが属する区間を返す。
  ///
  /// 区間は `startOrdinal < ordinal <= endOrdinal` で判定する。
  /// 画面が一度も設定されていない場合や、上限超過で捨てた古い区間の
  /// フレームは null（計上しない）。
  _ScreenSegment? _segmentFor(int ordinal) {
    for (final segment in _segments) {
      final end = segment.endOrdinal;
      if (ordinal > segment.startOrdinal && (end == null || ordinal <= end)) {
        return segment;
      }
    }
    return null;
  }

  /// 集計結果を画面名ごとにまとめて取り出し、カウンタを 0 に戻す。
  ///
  /// 送信済みの区間を残すと二重計上になるため、取り出しと同時にリセットする。
  /// 現在の区間は継続するため破棄しない。
  List<ScreenFrameStats> drain() {
    final merged = <String, ScreenFrameStats>{};
    for (final segment in _segments) {
      if (segment.frameCount == 0) {
        continue;
      }
      final stats = segment.toStats();
      final existing = merged[stats.screenName];
      merged[stats.screenName] = existing == null
          ? stats
          : existing.merge(stats);
      segment.reset();
    }

    // 集計を終えた過去の区間は不要。現在の区間だけ残す。
    _segments.removeWhere(
      (segment) => segment.endOrdinal != null && segment.frameCount == 0,
    );

    return merged.values.toList();
  }
}

class _ScreenSegment {
  _ScreenSegment({required this.screenName, required this.startOrdinal});

  final String screenName;

  /// この区間に属する最初のフレームの序数 - 1。
  final int startOrdinal;

  /// この区間に属する最後のフレームの序数。区間が継続中の場合は null。
  int? endOrdinal;

  int frameCount = 0;
  int slowBuildCount = 0;
  int slowRasterCount = 0;
  int frozenCount = 0;
  int sumBuildUs = 0;
  int sumRasterUs = 0;
  int maxBuildUs = 0;
  int maxRasterUs = 0;

  void add(FrameTiming timing, Duration frameBudget) {
    final buildUs = timing.buildDuration.inMicroseconds;
    final rasterUs = timing.rasterDuration.inMicroseconds;

    frameCount++;
    if (timing.buildDuration > frameBudget) {
      slowBuildCount++;
    }
    if (timing.rasterDuration > frameBudget) {
      slowRasterCount++;
    }
    if (timing.totalSpan > frozenFrameThreshold) {
      frozenCount++;
    }
    sumBuildUs += buildUs;
    sumRasterUs += rasterUs;
    if (buildUs > maxBuildUs) {
      maxBuildUs = buildUs;
    }
    if (rasterUs > maxRasterUs) {
      maxRasterUs = rasterUs;
    }
  }

  ScreenFrameStats toStats() => ScreenFrameStats(
    screenName: screenName,
    frameCount: frameCount,
    slowBuildCount: slowBuildCount,
    slowRasterCount: slowRasterCount,
    frozenCount: frozenCount,
    sumBuildUs: sumBuildUs,
    sumRasterUs: sumRasterUs,
    maxBuildUs: maxBuildUs,
    maxRasterUs: maxRasterUs,
  );

  void reset() {
    frameCount = 0;
    slowBuildCount = 0;
    slowRasterCount = 0;
    frozenCount = 0;
    sumBuildUs = 0;
    sumRasterUs = 0;
    maxBuildUs = 0;
    maxRasterUs = 0;
  }
}
