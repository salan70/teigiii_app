import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/telemetry/frame_stats_client.dart';
import 'package:teigi_app/core/telemetry/screen_frame_stats.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'frame_stats_client_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TelemetryApi>()])
void main() {
  late MockTelemetryApi telemetryApi;
  late List<String> warnings;

  final device = FrameStatsDevice(
    appVersion: '2.0.0',
    buildNumber: 12,
    flavor: FrameStatsDeviceFlavorEnum.prod,
    platform: FrameStatsDevicePlatformEnum.ios,
    osVersion: 'iOS 26.0',
    deviceModel: 'iPhone17,1',
    refreshRateHz: 120,
  );

  setUp(() {
    telemetryApi = MockTelemetryApi();
    warnings = [];
    when(
      telemetryApi.v1TelemetryFramesPost(
        frameStatsRequest: anyNamed('frameStatsRequest'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/v1/telemetry/frames'),
        data: FrameStatsAcceptedResponse(accepted: 1, disabled: false),
      ),
    );
  });

  FrameStatsClient buildClient() => FrameStatsClient(
        telemetryApi,
        logWarning: warnings.add,
      );

  ScreenFrameStats screen(String name) => ScreenFrameStats(
        screenName: name,
        frameCount: 1,
        slowBuildCount: 0,
        slowRasterCount: 0,
        frozenCount: 0,
        sumBuildUs: 1000,
        sumRasterUs: 1000,
        maxBuildUs: 1000,
        maxRasterUs: 1000,
      );

  test('screens が上限を超えると切り詰めて警告する', () async {
    final stats = List.generate(
      FrameStatsClient.maxScreensPerRequest + 3,
      (i) => screen('Screen$i'),
    );

    await buildClient().send(
      sessionId: 'session-1',
      device: device,
      stats: stats,
      recordedAt: DateTime.utc(2026, 7, 27),
    );

    final captured = verify(
      telemetryApi.v1TelemetryFramesPost(
        frameStatsRequest: captureAnyNamed('frameStatsRequest'),
      ),
    ).captured.single as FrameStatsRequest;

    expect(captured.screens, hasLength(FrameStatsClient.maxScreensPerRequest));
    expect(warnings, hasLength(1));
    expect(warnings.single, contains('count: ${stats.length}'));
    expect(
      warnings.single,
      contains('max: ${FrameStatsClient.maxScreensPerRequest}'),
    );
  });

  test('screens が上限以内なら警告しない', () async {
    await buildClient().send(
      sessionId: 'session-1',
      device: device,
      stats: [screen('HomeRoute')],
      recordedAt: DateTime.utc(2026, 7, 27),
    );

    expect(warnings, isEmpty);
  });
}
