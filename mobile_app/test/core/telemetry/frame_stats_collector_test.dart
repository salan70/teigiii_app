import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/telemetry/frame_stats_collector.dart';
import 'package:teigi_app/core/telemetry/perf_telemetry_device.dart';

/// 指定の build / raster 時間を持つ [FrameTiming] を作る。
FrameTiming _timing({
  Duration build = const Duration(milliseconds: 1),
  Duration raster = const Duration(milliseconds: 1),
  Duration totalSpan = const Duration(milliseconds: 8),
}) {
  const vsyncStart = 0;
  const buildStart = vsyncStart;
  final buildFinish = buildStart + build.inMicroseconds;
  final rasterStart = buildFinish;
  final rasterFinish = vsyncStart + totalSpan.inMicroseconds;

  return FrameTiming(
    vsyncStart: vsyncStart,
    buildStart: buildStart,
    buildFinish: buildFinish,
    rasterStart: rasterStart,
    rasterFinish: rasterFinish > rasterStart + raster.inMicroseconds
        ? rasterFinish
        : rasterStart + raster.inMicroseconds,
    rasterFinishWallTime: rasterFinish,
  );
}

/// [count] 枚のフレームを生成したことにする。
void _produce(FrameStatsCollector collector, int count) {
  for (var i = 0; i < count; i++) {
    collector.onFrameProduced();
  }
}

void main() {
  /// 60Hz 相当（予算 16.6ms）。
  FrameStatsCollector build60Hz() =>
      FrameStatsCollector(frameBudget: frameBudgetOf(60));

  group('画面遷移境界の対応付け', () {
    test('遅延して届いたフレームは、生成時点の画面へ計上される', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');
      _produce(collector, 3);
      collector.onScreenChanged('WordTopRoute');
      _produce(collector, 2);

      // * Act
      // 5 フレームぶんの FrameTiming が遷移後にまとめて届く。
      collector.onTimings(List.generate(5, (_) => _timing()));

      // * Assert
      final stats = collector.drain();
      expect(stats.length, 2);
      expect(
        stats.firstWhere((s) => s.screenName == 'HomeRoute').frameCount,
        3,
      );
      expect(
        stats.firstWhere((s) => s.screenName == 'WordTopRoute').frameCount,
        2,
      );
    });

    test('1 秒未満での連続遷移でも、各画面に正しく振り分けられる', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('A');
      _produce(collector, 1);
      collector.onScreenChanged('B');
      _produce(collector, 1);
      collector.onScreenChanged('C');
      _produce(collector, 1);

      // * Act
      // 3 画面ぶんが 1 バッチで届く。
      collector.onTimings(List.generate(3, (_) => _timing()));

      // * Assert
      final stats = collector.drain();
      expect(
        {for (final s in stats) s.screenName: s.frameCount},
        {'A': 1, 'B': 1, 'C': 1},
      );
    });

    test('タブ切替で同じ画面へ戻った場合、集計は画面名でまとめられる', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');
      _produce(collector, 2);
      collector.onScreenChanged('DictionaryEveryoneRoute');
      _produce(collector, 1);
      collector.onScreenChanged('HomeRoute');
      _produce(collector, 3);

      // * Act
      collector.onTimings(List.generate(6, (_) => _timing()));

      // * Assert
      final stats = collector.drain();
      expect(stats.length, 2);
      expect(
        stats.firstWhere((s) => s.screenName == 'HomeRoute').frameCount,
        5,
      );
      expect(
        stats
            .firstWhere((s) => s.screenName == 'DictionaryEveryoneRoute')
            .frameCount,
        1,
      );
    });

    test('遷移直後に background へ回っても、旧画面の集計が新画面へ混入しない', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');
      _produce(collector, 4);
      // 遷移直後に background。新画面のフレームは 1 枚も生成されていない。
      collector.onScreenChanged('SettingRoute');

      // * Act
      // 旧画面ぶんの FrameTiming だけが遅れて届く。
      collector.onTimings(List.generate(4, (_) => _timing()));

      // * Assert
      final stats = collector.drain();
      expect(stats.length, 1);
      expect(stats.single.screenName, 'HomeRoute');
      expect(stats.single.frameCount, 4);
    });

    test('遷移後、timings 到着前の drain でも旧画面のフレームを欠落させない', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');
      _produce(collector, 4);
      collector.onScreenChanged('SettingRoute');

      // * Act — timer / onPause が timings より先に drain する。
      expect(collector.drain(), isEmpty);
      collector.onTimings(List.generate(4, (_) => _timing()));

      // * Assert
      final stats = collector.drain();
      expect(stats.length, 1);
      expect(stats.single.screenName, 'HomeRoute');
      expect(stats.single.frameCount, 4);
    });

    test('途中まで timings が届いた後の drain でも残りのフレームを欠落させない', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');
      _produce(collector, 4);
      collector
        ..onScreenChanged('SettingRoute')
        ..onTimings(List.generate(2, (_) => _timing()));

      // * Act
      expect(collector.drain().single.frameCount, 2);
      collector.onTimings(List.generate(2, (_) => _timing()));

      // * Assert
      final stats = collector.drain();
      expect(stats.length, 1);
      expect(stats.single.screenName, 'HomeRoute');
      expect(stats.single.frameCount, 2);
    });

    test('画面が未設定の間に生成されたフレームは計上しない', () {
      // * Arrange
      final collector = build60Hz();
      _produce(collector, 2);

      // * Act
      collector.onTimings(List.generate(2, (_) => _timing()));

      // * Assert
      expect(collector.drain(), isEmpty);
    });

    test('同じ画面名が連続した場合は区間を分けない', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');
      _produce(collector, 1);
      collector.onScreenChanged('HomeRoute');
      _produce(collector, 1);

      // * Act
      collector.onTimings(List.generate(2, (_) => _timing()));

      // * Assert
      final stats = collector.drain();
      expect(stats.single.frameCount, 2);
    });
  });

  group('ジャンク判定', () {
    test('予算は端末のリフレッシュレートから算出する', () {
      // * Arrange
      // 10ms の build は 60Hz（16.6ms）では slow でないが、120Hz（8.3ms）では slow。
      final collector60 = build60Hz()..onScreenChanged('HomeRoute');
      final collector120 = FrameStatsCollector(frameBudget: frameBudgetOf(120))
        ..onScreenChanged('HomeRoute');
      for (final collector in [collector60, collector120]) {
        _produce(collector, 1);
      }

      // * Act
      final timing = _timing(build: const Duration(milliseconds: 10));
      collector60.onTimings([timing]);
      collector120.onTimings([timing]);

      // * Assert
      expect(collector60.drain().single.slowBuildCount, 0);
      expect(collector120.drain().single.slowBuildCount, 1);
    });

    test('build と raster を別々に数える', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');
      _produce(collector, 2);

      // * Act
      collector.onTimings([
        _timing(build: const Duration(milliseconds: 30)),
        _timing(raster: const Duration(milliseconds: 30)),
      ]);

      // * Assert
      final stats = collector.drain().single;
      expect(stats.slowBuildCount, 1);
      expect(stats.slowRasterCount, 1);
    });

    test('totalSpan が 700ms を超えたフレームを frozen として数える', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');
      _produce(collector, 2);

      // * Act
      collector.onTimings([
        _timing(totalSpan: const Duration(milliseconds: 701)),
        _timing(totalSpan: const Duration(milliseconds: 700)),
      ]);

      // * Assert
      expect(collector.drain().single.frozenCount, 1);
    });

    test('sum と max を記録する', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');
      _produce(collector, 2);

      // * Act
      collector.onTimings([
        _timing(build: const Duration(milliseconds: 4)),
        _timing(build: const Duration(milliseconds: 6)),
      ]);

      // * Assert
      final stats = collector.drain().single;
      expect(stats.sumBuildUs, 10 * Duration.microsecondsPerMillisecond);
      expect(stats.maxBuildUs, 6 * Duration.microsecondsPerMillisecond);
    });
  });

  group('drain', () {
    test('取り出した集計は二重計上されない', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');
      _produce(collector, 1);
      collector.onTimings([_timing()]);
      expect(collector.drain().single.frameCount, 1);

      // * Act
      _produce(collector, 2);
      collector.onTimings([_timing(), _timing()]);

      // * Assert
      expect(collector.drain().single.frameCount, 2);
    });

    test('未集計のフレームがなければ空を返す', () {
      // * Arrange
      final collector = build60Hz()..onScreenChanged('HomeRoute');

      // * Act & Assert
      expect(collector.drain(), isEmpty);
    });
  });
}
