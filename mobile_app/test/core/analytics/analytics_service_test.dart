import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/analytics/analytics_client.dart';
import 'package:teigi_app/core/analytics/analytics_event.dart';
import 'package:teigi_app/core/analytics/analytics_service.dart';

import 'analytics_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AnalyticsClient>()])
void main() {
  late MockAnalyticsClient mockClient;
  late ProviderContainer container;

  setUp(() {
    mockClient = MockAnalyticsClient();
    container = ProviderContainer(
      overrides: [analyticsClientProvider.overrideWithValue(mockClient)],
    );
    addTearDown(container.dispose);
  });

  tearDown(() => reset(mockClient));

  group('AnalyticsService', () {
    test('logEvent は client にイベント名とパラメータを渡す', () async {
      final service = container.read(analyticsServiceProvider);

      await service.logEvent(
        AnalyticsEvent.appLaunched,
        parameters: {AnalyticsParam.flavor: 'dev'},
      );

      verify(
        mockClient.logEvent(
          AnalyticsEvent.appLaunched,
          parameters: {AnalyticsParam.flavor: 'dev'},
        ),
      ).called(1);
    });

    test('logScreenView は client に screenName を渡す', () async {
      final service = container.read(analyticsServiceProvider);

      await service.logScreenView(screenName: 'HomeRoute');

      verify(mockClient.logScreenView(screenName: 'HomeRoute')).called(1);
    });

    test('setUserId は client に uid を渡す', () async {
      final service = container.read(analyticsServiceProvider);

      await service.setUserId('uid-1');

      verify(mockClient.setUserId('uid-1')).called(1);
    });

    test('setUserId(null) でユーザー ID をクリアできる', () async {
      final service = container.read(analyticsServiceProvider);

      await service.setUserId(null);

      verify(mockClient.setUserId(null)).called(1);
    });
  });
}
