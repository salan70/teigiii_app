import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_config/application/user_config_state.dart';
import 'package:teigi_app/feature/user_config/repository/package_info_repository.dart';
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart';

import '../../mock/mock_data.dart';
import 'user_config_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserConfigRepository>(),
  MockSpec<PackageInfoRepository>(),
])
class MockMutedUserIdListListener extends Mock
    implements Listener<AsyncValue<List<String>>> {}

class MockAppVersionListener extends Mock
    implements Listener<AsyncValue<String>> {}

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockUserConfigRepository = MockUserConfigRepository();
  final mockPackageInfoRepository = MockPackageInfoRepository();
  final mutedUserIdListListener = MockMutedUserIdListListener();
  final appVersionListener = MockAppVersionListener();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => 'userId'),
        userConfigRepositoryProvider
            .overrideWithValue(mockUserConfigRepository),
        packageInfoRepositoryProvider
            .overrideWithValue(mockPackageInfoRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockUserConfigRepository);
  });

  group('mutedUserIdList', () {
    test('stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      when(
        mockUserConfigRepository.fetchUserConfig(any),
      ).thenAnswer((_) async => mockUserConfigDoc);

      container.listen(
        mutedUserIdListProvider,
        mutedUserIdListListener,
        fireImmediately: true,
      );
      addTearDown(() => reset(mutedUserIdListListener));

      // * Act
      await container.read(
        mutedUserIdListProvider.future,
      );

      // * Assert
      final expected = mockUserConfigDoc.mutedUserIdList;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        mutedUserIdListListener.call(
          null,
          const AsyncLoading<List<String>>(),
        ),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        mutedUserIdListListener.call(
          const AsyncLoading<List<String>>(),
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(mutedUserIdListListener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserConfigRepository.fetchUserConfig(mockDefinitionDoc.authorId),
      ).called(1);
    });
  });

  group('appVersion', () {
    test('stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      const mockAppVersion = '1.0.0';
      when(
        mockPackageInfoRepository.fetchAppVersion(),
      ).thenAnswer((_) async => mockAppVersion);

      container.listen(
        appVersionProvider,
        appVersionListener,
        fireImmediately: true,
      );
      addTearDown(() => reset(appVersionListener));

      // * Act
      await container.read(
        appVersionProvider.future,
      );

      // * Assert
      const expected = mockAppVersion;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        appVersionListener.call(
          null,
          const AsyncLoading<String>(),
        ),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        appVersionListener.call(
          const AsyncLoading<String>(),
          const AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(appVersionListener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockPackageInfoRepository.fetchAppVersion(),
      ).called(1);
    });
  });
}
