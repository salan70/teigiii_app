import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/analytics/analytics_event.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_config/application/user_config_service.dart';
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart';

import '../../mock/fake_analytics.dart';
import 'user_config_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserConfigRepository>()])
void main() {
  final mockUserConfigRepository = MockUserConfigRepository();
  late ProviderContainer container;
  late FakeAnalyticsClient fakeAnalytics;

  setUp(() {
    fakeAnalytics = FakeAnalyticsClient();
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => 'userId'),
        userConfigRepositoryProvider.overrideWithValue(
          mockUserConfigRepository,
        ),
        ...analyticsTestOverrides(fakeAnalytics),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() => reset(mockUserConfigRepository));

  test('muteUser 成功時に user_muted を送る', () async {
    await container.read(userConfigServiceProvider).muteUser('target');

    verify(mockUserConfigRepository.appendMutedUserIdList('target')).called(1);
    expect(fakeAnalytics.loggedEvents.single.name, AnalyticsEvent.userMuted);
  });

  test('unmuteUser 成功時に user_unmuted を送る', () async {
    await container.read(userConfigServiceProvider).unmuteUser('target');

    verify(mockUserConfigRepository.removeMutedUserIdList('target')).called(1);
    expect(fakeAnalytics.loggedEvents.single.name, AnalyticsEvent.userUnmuted);
  });
}
