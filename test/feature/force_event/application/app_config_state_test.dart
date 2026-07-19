import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/force_event/application/app_config_state.dart';
import 'package:teigi_app/feature/force_event/domain/app_config.dart';
import 'package:teigi_app/feature/force_event/repository/app_config_repository.dart';

import 'app_config_state_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppConfigRepository>()])
void main() {
  late MockAppConfigRepository mockAppConfigRepository;
  late ProviderContainer container;

  setUp(() {
    mockAppConfigRepository = MockAppConfigRepository();
    container = ProviderContainer(
      overrides: [
        appConfigRepositoryProvider.overrideWithValue(mockAppConfigRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    reset(mockAppConfigRepository);
  });

  test('起動中は AppConfig を一度だけ取得して保持する', () async {
    // * Arrange
    const expected = AppConfig(
      minAppVersionIos: '2.0.0',
      minAppVersionAndroid: '2.1.0',
      inMaintenance: false,
      maintenanceScheduledEndTime: null,
    );
    when(
      mockAppConfigRepository.fetchAppConfig(),
    ).thenAnswer((_) async => expected);

    // * Act
    final first = await container.read(appConfigProvider.future);
    final second = await container.read(appConfigProvider.future);

    // * Assert
    expect(first, expected);
    expect(second, same(first));
    verify(mockAppConfigRepository.fetchAppConfig()).called(1);
  });
}
