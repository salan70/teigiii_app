import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/common_provider/toast_controller.dart';
import 'package:teigi_app/feature/user_profile/application/user_id_list_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_id_list_state.dart';
import 'package:teigi_app/feature/user_profile/repository/user_follow_repository.dart';
import 'package:teigi_app/feature/user_profile/util/user_list_type.dart';

import '../../../mock/mock_data.dart';
import 'user_id_list_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserFollowRepository>(),
  MockSpec<Listener<AsyncValue<UserIdListState>>>(),
])
class MockToastController extends Notifier<void>
    with Mock
    implements ToastController {}

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockUserFollowRepository = MockUserFollowRepository();
  final listener = MockListener();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userFollowRepositoryProvider
            .overrideWithValue(mockUserFollowRepository),
        toastControllerProvider.overrideWith(
          MockToastController.new,
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockUserFollowRepository);
  });
  group('build()', () {
    test('following: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      when(
        mockUserFollowRepository.fetchFollowingIdList(any, any),
      ).thenAnswer((_) async => mockUserIdListState);
      const targetUserId = 'targetUserId';
      container.listen(
        userIdListStateNotifierProvider(
          UserListType.following,
          targetUserId: targetUserId,
          targetDefinitionId: null,
        ),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        userIdListStateNotifierProvider(
          UserListType.following,
          targetUserId: targetUserId,
          targetDefinitionId: null,
        ).future,
      );

      // * Assert
      final expected = mockUserIdListState;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<UserIdListState>(),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          const AsyncLoading<UserIdListState>(),
          // fetchHomeRecommendDefinitionIdListの戻り値がそのまま格納されていることを検証
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserFollowRepository.fetchFollowingIdList(
          targetUserId,
          null,
        ),
      ).called(1);
    });

    test('follower: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      when(
        mockUserFollowRepository.fetchFollowerIdList(any, any),
      ).thenAnswer((_) async => mockUserIdListState);

      const targetUserId = 'targetUserId';
      container.listen(
        userIdListStateNotifierProvider(
          UserListType.follower,
          targetUserId: targetUserId,
          targetDefinitionId: null,
        ),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        userIdListStateNotifierProvider(
          UserListType.follower,
          targetUserId: targetUserId,
          targetDefinitionId: null,
        ).future,
      );

      // * Assert
      final expected = mockUserIdListState;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<UserIdListState>(),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          const AsyncLoading<UserIdListState>(),
          // fetchHomeRecommendDefinitionIdListの戻り値がそのまま格納されていることを検証
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserFollowRepository.fetchFollowerIdList(
          targetUserId,
          null,
        ),
      ).called(1);
    });
  });

  group('fetchMore()', () {
    test('following: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      final firstState = UserIdListState(
        list: ['user1'],
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: true,
      );
      when(
        mockUserFollowRepository.fetchFollowingIdList(any, null),
      ).thenAnswer((_) async => firstState);

      final secondState = UserIdListState(
        list: ['user2'],
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: false,
      );
      when(
        mockUserFollowRepository.fetchFollowingIdList(
          any,
          firstState.lastReadQueryDocumentSnapshot,
        ),
      ).thenAnswer((_) async => secondState);

      const targetUserId = 'targetUserId';
      final userIdListProvider = userIdListStateNotifierProvider(
        UserListType.following,
        targetUserId: targetUserId,
        targetDefinitionId: null,
      );
      container.listen(
        userIdListProvider,
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));
      // build()
      await container.read(
        userIdListProvider.future,
      );
      // build()時にlistenerが発火するため、ここで一旦verify
      verifyInOrder([
        listener.call(any, any),
        listener.call(any, any),
      ]);

      // * Act
      await container.read(userIdListProvider.notifier).fetchMore();

      // * Assert
      final expected = UserIdListState(
        // build()時に取得したdefinitionIdListに、fetchMore()で取得したdefinitionIdLisが追加される
        list: firstState.list + secondState.list,
        lastReadQueryDocumentSnapshot:
            secondState.lastReadQueryDocumentSnapshot,
        hasMore: secondState.hasMore,
      );
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          AsyncValue.data(firstState),
          argThat(
            isA<AsyncData<UserIdListState>>()
                // loading中であることを検証
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', firstState),
          ),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          argThat(
            isA<AsyncData<UserIdListState>>()
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', firstState),
          ),
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserFollowRepository.fetchFollowingIdList(
          targetUserId,
          firstState.lastReadQueryDocumentSnapshot,
        ),
      ).called(1);
    });

    test('follower: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      final firstState = UserIdListState(
        list: ['user1'],
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: true,
      );
      when(
        mockUserFollowRepository.fetchFollowerIdList(any, null),
      ).thenAnswer((_) async => firstState);

      final secondState = UserIdListState(
        list: ['user2'],
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: false,
      );
      when(
        mockUserFollowRepository.fetchFollowerIdList(
          any,
          firstState.lastReadQueryDocumentSnapshot,
        ),
      ).thenAnswer((_) async => secondState);

      const targetUserId = 'targetUserId';
      final userIdListProvider = userIdListStateNotifierProvider(
        UserListType.follower,
        targetUserId: targetUserId,
        targetDefinitionId: null,
      );
      container.listen(
        userIdListProvider,
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));
      // build()
      await container.read(
        userIdListProvider.future,
      );
      // build()時にlistenerが発火するため、ここで一旦verify
      verifyInOrder([
        listener.call(any, any),
        listener.call(any, any),
      ]);

      // * Act
      await container.read(userIdListProvider.notifier).fetchMore();

      // * Assert
      final expected = UserIdListState(
        // build()時に取得したdefinitionIdListに、fetchMore()で取得したdefinitionIdLisが追加される
        list: firstState.list + secondState.list,
        lastReadQueryDocumentSnapshot:
            secondState.lastReadQueryDocumentSnapshot,
        hasMore: secondState.hasMore,
      );
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          AsyncValue.data(firstState),
          argThat(
            isA<AsyncData<UserIdListState>>()
                // loading中であることを検証
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', firstState),
          ),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          argThat(
            isA<AsyncData<UserIdListState>>()
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', firstState),
          ),
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserFollowRepository.fetchFollowerIdList(
          targetUserId,
          firstState.lastReadQueryDocumentSnapshot,
        ),
      ).called(1);
    });

    test('hasMoreがfalse', () async {
      // * Arrange
      // Mockの設定
      when(
        mockUserFollowRepository.fetchFollowingIdList(any, null),
      ).thenAnswer((_) async => mockUserIdListState.copyWith(hasMore: false));

      final userIdListProvider = userIdListStateNotifierProvider(
        UserListType.following,
        targetUserId: 'targetUserId',
        targetDefinitionId: null,
      );
      container.listen(
        userIdListProvider,
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));
      // build()
      await container.read(
        userIdListProvider.future,
      );
      // build()時にlistenerが発火するため、ここで一旦verify
      verifyInOrder([
        listener.call(any, any),
        listener.call(any, any),
      ]);

      // * Act
      await container.read(userIdListProvider.notifier).fetchMore();

      // * Assert
      // stateの検証
      // build()以降、listenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通り、repositoryの関数が1回のみ呼ばれているか検証
      verify(
        mockUserFollowRepository.fetchFollowingIdList(any, any),
      ).called(1);
    });

    // TODO(me): 「ローディング中の場合、何もしない」ことを検証するテスト書く

    test('例外発生', () async {
      // * Arrange
      // Mockの設定
      final firstState = UserIdListState(
        list: ['user1'],
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: true,
      );
      when(
        mockUserFollowRepository.fetchFollowingIdList(any, null),
      ).thenAnswer((_) async => firstState);
      final testException = Exception('fetchFollowingIdListFirst()で例外発生！！！');
      when(
        mockUserFollowRepository.fetchFollowingIdList(
          any,
          firstState.lastReadQueryDocumentSnapshot,
        ),
      ).thenThrow(testException);

      final userIdListProvider = userIdListStateNotifierProvider(
        UserListType.following,
        targetUserId: 'targetUserId',
        targetDefinitionId: null,
      );
      container.listen(
        userIdListProvider,
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));
      // build()
      await container.read(userIdListProvider.future);
      // build()時にlistenerが発火するため、ここで一旦verify
      verifyInOrder([
        listener.call(any, any),
        listener.call(any, any),
      ]);

      // * Act
      await container.read(userIdListProvider.notifier).fetchMore();

      // * Assert
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          AsyncValue.data(firstState),
          argThat(
            isA<AsyncData<UserIdListState>>()
                // loading中であることを検証
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', firstState),
          ),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          argThat(
            isA<AsyncData<UserIdListState>>()
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', firstState),
          ),
          // AsyncErrorが格納されていることを検証
          argThat(
            isA<AsyncError<UserIdListState>>()
                .having(
                  (d) => d.error,
                  'error',
                  testException,
                )
                // 元々のstateの値がvalueに格納されていることを検証
                .having((d) => d.value, 'value', firstState),
          ),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // TODO(me): toastを表示させる関数が呼ばれていることを検証する
    });
  });
}
