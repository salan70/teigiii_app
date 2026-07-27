import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/telemetry/frame_stats_client.dart';
import 'package:teigi_app/core/telemetry/perf_telemetry_service.dart';
import 'package:teigi_app/core/telemetry/screen_frame_stats.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'perf_telemetry_service_test.mocks.dart';

final _device = FrameStatsDevice(
  appVersion: '2.0.0',
  buildNumber: 12,
  flavor: FrameStatsDeviceFlavorEnum.prod,
  platform: FrameStatsDevicePlatformEnum.ios,
  osVersion: 'iOS 26.0',
  deviceModel: 'iPhone17,1',
  refreshRateHz: 120,
);

FrameTiming _timing() => FrameTiming(
  vsyncStart: 0,
  buildStart: 0,
  buildFinish: Duration.microsecondsPerMillisecond,
  rasterStart: Duration.microsecondsPerMillisecond,
  rasterFinish: 2 * Duration.microsecondsPerMillisecond,
  rasterFinishWallTime: 2 * Duration.microsecondsPerMillisecond,
);

@GenerateNiceMocks([MockSpec<FrameStatsClient>()])
void main() {
  late MockFrameStatsClient client;

  setUp(() => client = MockFrameStatsClient());

  PerfTelemetryService buildService({required bool isEnabled}) {
    final service = PerfTelemetryService(
      client: client,
      resolveDevice: () async => _device,
      isEnabled: () => isEnabled,
      refreshRateHz: 60,
      sessionId: 'session-1',
      // テストは debug 実行のため、計測可否を明示的に有効化する。
      measurable: true,
    );
    addTearDown(service.dispose);
    return service;
  }

  /// 集計器へ [count] フレームぶん流し込む。
  void feed(PerfTelemetryService service, String screenName, int count) {
    service.handleScreenChanged(screenName);
    for (var i = 0; i < count; i++) {
      service.collector.onFrameProduced();
    }
    service.collector.onTimings(List.generate(count, (_) => _timing()));
  }

  test('flush で集計を送信する', () async {
    // * Arrange
    final service = buildService(isEnabled: true);
    feed(service, 'HomeRoute', 3);

    // * Act
    await service.flush();

    // * Assert
    final captured =
        verify(
              client.send(
                sessionId: 'session-1',
                device: anyNamed('device'),
                stats: captureAnyNamed('stats'),
                recordedAt: anyNamed('recordedAt'),
              ),
            ).captured.single
            as List<ScreenFrameStats>;
    expect(captured.single.screenName, 'HomeRoute');
    expect(captured.single.frameCount, 3);
  });

  test('集計が空なら送信しない', () async {
    // * Arrange
    final service = buildService(isEnabled: true);

    // * Act
    await service.flush();

    // * Assert
    verifyNever(
      client.send(
        sessionId: anyNamed('sessionId'),
        device: anyNamed('device'),
        stats: anyNamed('stats'),
        recordedAt: anyNamed('recordedAt'),
      ),
    );
  });

  test('クライアント側フラグが false なら送信せず、バッファも溜めない', () async {
    // * Arrange
    final service = buildService(isEnabled: false);
    feed(service, 'HomeRoute', 3);

    // * Act
    await service.flush();

    // * Assert
    verifyNever(
      client.send(
        sessionId: anyNamed('sessionId'),
        device: anyNamed('device'),
        stats: anyNamed('stats'),
        recordedAt: anyNamed('recordedAt'),
      ),
    );
    // drain 済みなので、有効に戻しても前回ぶんは再送されない。
    expect(service.collector.drain(), isEmpty);
  });

  test('送信に失敗しても例外を伝播させない', () async {
    // * Arrange
    final service = buildService(isEnabled: true);
    feed(service, 'HomeRoute', 1);
    when(
      client.send(
        sessionId: anyNamed('sessionId'),
        device: anyNamed('device'),
        stats: anyNamed('stats'),
        recordedAt: anyNamed('recordedAt'),
      ),
    ).thenThrow(Exception('network error'));

    // * Act & Assert
    await expectLater(service.flush(), completes);
  });

  test('debug ビルド相当（measurable が false）では計測も送信もしない', () async {
    // * Arrange
    final service = PerfTelemetryService(
      client: client,
      resolveDevice: () async => _device,
      isEnabled: () => true,
      refreshRateHz: 60,
      sessionId: 'session-1',
      measurable: false,
    );
    addTearDown(service.dispose);

    // * Act
    service.handleScreenChanged('HomeRoute');
    service.collector.onFrameProduced();
    service.collector.onTimings([_timing()]);
    await service.flush();

    // * Assert
    // handleScreenChanged が無視されるため、区間がなく集計もされない。
    expect(service.collector.drain(), isEmpty);
    verifyNever(
      client.send(
        sessionId: anyNamed('sessionId'),
        device: anyNamed('device'),
        stats: anyNamed('stats'),
        recordedAt: anyNamed('recordedAt'),
      ),
    );
  });
}
