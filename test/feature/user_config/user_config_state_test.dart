import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_config/application/user_config_state.dart';
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart';

import '../../mock/mock_data.dart';
import 'user_config_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserConfigRepository>(),
  MockSpec<Listener<AsyncValue<List<String>>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockUserConfigRepository = MockUserConfigRepository();
  final listener = MockListener();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => 'userId'),
        userConfigRepositoryProvider
            .overrideWithValue(mockUserConfigRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockUserConfigRepository);
  });

  group('definition', () {
    test('stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      when(
        mockUserConfigRepository.fetchUserConfig(any),
      ).thenAnswer((_) async => mockUserConfigDoc);

      container.listen(
        mutedUserIdListProvider,
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        mutedUserIdListProvider.future,
      );

      // * Assert
      final expected = mockUserConfigDoc.mutedUserIdList;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<List<String>>(),
        ),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        listener.call(
          const AsyncLoading<List<String>>(),
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserConfigRepository.fetchUserConfig(mockDefinitionDoc.authorId),
      ).called(1);
    });
  });
}
