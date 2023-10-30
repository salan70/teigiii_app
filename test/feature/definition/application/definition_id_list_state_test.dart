import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition/application/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition/domain/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition/repository/definition_repository.dart';
import 'package:teigi_app/feature/definition/util/definition_feed_type.dart';
import 'package:teigi_app/feature/user_config/application/user_config_state.dart';
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/repository/user_follow_repository.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';

import '../../../mock/mock_data.dart';
import 'definition_id_list_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DefinitionRepository>(),
  MockSpec<UserProfileRepository>(),
  MockSpec<UserConfigRepository>(),
  MockSpec<UserFollowRepository>(),
  MockSpec<WordRepository>(),
  MockSpec<Listener<AsyncValue<DefinitionIdListState>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockDefinitionRepository = MockDefinitionRepository();
  final mockUserProfileRepository = MockUserProfileRepository();
  final mockUserFollowRepository = MockUserFollowRepository();
  final mockUserConfigRepository = MockUserConfigRepository();
  final listener = MockListener();

  const userId = 'userId';
  final mockFollowingUserIdList = [
    'userId1',
    'userId2',
    ...mockUserConfigDoc.mutedUserIdList,
  ];

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => userId),
        followingIdListProvider(userId).overrideWith((ref) => mockFollowingUserIdList),
        definitionRepositoryProvider
            .overrideWithValue(mockDefinitionRepository),
        userProfileRepositoryProvider
            .overrideWithValue(mockUserProfileRepository),
        userConfigRepositoryProvider
            .overrideWithValue(mockUserConfigRepository),
        userFollowRepositoryProvider
            .overrideWithValue(mockUserFollowRepository),
        mutedUserIdListProvider
            .overrideWith((ref) => mockUserConfigDoc.mutedUserIdList),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockDefinitionRepository);
    reset(mockUserProfileRepository);
    reset(mockUserFollowRepository);
    reset(mockUserConfigRepository);
  });
  group('build()', () {
    test('homeRecommend: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      final mockDefinitionIdList = [mockDefinitionDoc.id];
      when(
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdListFirst(any),
      ).thenAnswer(
        (_) async => DefinitionIdListState(
          definitionIdList: mockDefinitionIdList,
          lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
          hasMore: false,
        ),
      );

      container.listen(
        definitionIdListStateNotifierProvider(DefinitionFeedType.homeRecommend),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        definitionIdListStateNotifierProvider(DefinitionFeedType.homeRecommend)
            .future,
      );

      // * Assert
      final expected = DefinitionIdListState(
        definitionIdList: mockDefinitionIdList,
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: false,
      );
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<DefinitionIdListState>(),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          const AsyncLoading<DefinitionIdListState>(),
          // fetchHomeRecommendDefinitionIdListの戻り値がそのまま格納されていることを検証
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdListFirst(
          mockUserConfigDoc.mutedUserIdList,
        ),
      ).called(1);
    });

    test('homeFollowing: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      when(
        mockUserProfileRepository.fetchUserProfile(any),
      ).thenAnswer((_) async => mockUserProfileDoc);
      final mockDefinitionIdList = [mockDefinitionDoc.id];
      when(
        mockDefinitionRepository.fetchHomeFollowingDefinitionIdListFirst(any),
      ).thenAnswer(
        (_) async => DefinitionIdListState(
          definitionIdList: mockDefinitionIdList,
          lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
          hasMore: false,
        ),
      );

      container.listen(
        definitionIdListStateNotifierProvider(DefinitionFeedType.homeFollowing),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        definitionIdListStateNotifierProvider(DefinitionFeedType.homeFollowing)
            .future,
      );

      // * Assert
      final expected = DefinitionIdListState(
        definitionIdList: mockDefinitionIdList,
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: false,
      );
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<DefinitionIdListState>(),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          const AsyncLoading<DefinitionIdListState>(),
          // fetchHomeRecommendDefinitionIdListの戻り値がそのまま格納されていることを検証
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      // TODO(me): mutedUserIdListを除外したuserIdListを引数に渡していることを検証
      verify(
        mockDefinitionRepository.fetchHomeFollowingDefinitionIdListFirst(any),
      ).called(1);
    });
  });

  group('fetchMore()', () {
    test('homeRecommend: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      final mockDefinitionIdListState = DefinitionIdListState(
        definitionIdList: [mockDefinitionDoc.id],
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: true,
      );
      when(
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdListFirst(any),
      ).thenAnswer(
        (_) async => mockDefinitionIdListState,
      );
      final mockDefinitionIdList = [mockDefinitionDoc.id];
      when(
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdListMore(
          any,
          any,
        ),
      ).thenAnswer(
        (_) async => DefinitionIdListState(
          definitionIdList: mockDefinitionIdList,
          lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
          hasMore: false,
        ),
      );

      container.listen(
        definitionIdListStateNotifierProvider(DefinitionFeedType.homeRecommend),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));
      // build()
      await container.read(
        definitionIdListStateNotifierProvider(DefinitionFeedType.homeRecommend)
            .future,
      );
      // build()時にlistenerが発火するため、ここで一旦verify
      verifyInOrder([
        listener.call(any, any),
        listener.call(any, any),
      ]);

      // * Act
      await container
          .read(
            definitionIdListStateNotifierProvider(
              DefinitionFeedType.homeRecommend,
            ).notifier,
          )
          .fetchMore();

      // * Assert
      final expected = DefinitionIdListState(
        // build()時に取得したdefinitionIdListに、fetchMore()で取得したdefinitionIdLisが追加される
        definitionIdList: mockDefinitionIdList + mockDefinitionIdList,
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: false,
      );
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          AsyncValue.data(mockDefinitionIdListState),
          argThat(
            isA<AsyncData<DefinitionIdListState>>()
                // loading中であることを検証
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', mockDefinitionIdListState),
          ),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          argThat(
            isA<AsyncData<DefinitionIdListState>>()
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', mockDefinitionIdListState),
          ),
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdListMore(
          mockUserConfigDoc.mutedUserIdList,
          any,
        ),
      ).called(1);
    });

    test('homeFollowing: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      final mockDefinitionIdListState = DefinitionIdListState(
        definitionIdList: [mockDefinitionDoc.id],
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: true,
      );
      when(
        mockDefinitionRepository.fetchHomeFollowingDefinitionIdListFirst(any),
      ).thenAnswer(
        (_) async => mockDefinitionIdListState,
      );
      final mockDefinitionIdList = [mockDefinitionDoc.id];
      when(
        mockDefinitionRepository.fetchHomeFollowingDefinitionIdListMore(
          any,
          any,
        ),
      ).thenAnswer(
        (_) async => DefinitionIdListState(
          definitionIdList: mockDefinitionIdList,
          lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
          hasMore: false,
        ),
      );

      container.listen(
        definitionIdListStateNotifierProvider(DefinitionFeedType.homeFollowing),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));
      // build()
      await container.read(
        definitionIdListStateNotifierProvider(DefinitionFeedType.homeFollowing)
            .future,
      );
      // build()時にlistenerが発火するため、ここで一旦verify
      verifyInOrder([
        listener.call(any, any),
        listener.call(any, any),
      ]);

      // * Act
      await container
          .read(
            definitionIdListStateNotifierProvider(
              DefinitionFeedType.homeFollowing,
            ).notifier,
          )
          .fetchMore();

      // * Assert
      final expected = DefinitionIdListState(
        // build()時に取得したdefinitionIdListに、fetchMore()で取得したdefinitionIdLisが追加される
        definitionIdList: mockDefinitionIdList + mockDefinitionIdList,
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: false,
      );
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          AsyncValue.data(mockDefinitionIdListState),
          argThat(
            isA<AsyncData<DefinitionIdListState>>()
                // loading中であることを検証
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', mockDefinitionIdListState),
          ),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          argThat(
            isA<AsyncData<DefinitionIdListState>>()
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', mockDefinitionIdListState),
          ),
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockDefinitionRepository.fetchHomeFollowingDefinitionIdListMore(
          any,
          any,
        ),
      ).called(1);
    });

    test('hasMoreがfalse', () async {
      // * Arrange
      // Mockの設定
      final mockDefinitionIdListState = DefinitionIdListState(
        definitionIdList: [mockDefinitionDoc.id],
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: false,
      );
      when(
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdListFirst(any),
      ).thenAnswer(
        (_) async => mockDefinitionIdListState,
      );

      container.listen(
        definitionIdListStateNotifierProvider(
          DefinitionFeedType.homeRecommend,
        ),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));
      // build()
      await container.read(
        definitionIdListStateNotifierProvider(
          DefinitionFeedType.homeRecommend,
        ).future,
      );
      // build()時にlistenerが発火するため、ここで一旦verify
      verifyInOrder([
        listener.call(any, any),
        listener.call(any, any),
      ]);

      // * Act
      await container
          .read(
            definitionIdListStateNotifierProvider(
              DefinitionFeedType.homeRecommend,
            ).notifier,
          )
          .fetchMore();

      // * Assert
      // stateの検証
      // build()以降、listenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通り、repositoryの関数が呼ばれていないか検証
      verifyNever(
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdListMore(
          any,
          any,
        ),
      );
      verifyNever(
        mockDefinitionRepository.fetchHomeFollowingDefinitionIdListMore(
          any,
          any,
        ),
      );
    });

    // TODO(me): 「ローディング中の場合、何もしない」ことを検証するテスト書く

    test('例外発生', () async {
      // * Arrange
      // Mockの設定
      final mockDefinitionIdListState = DefinitionIdListState(
        definitionIdList: [mockDefinitionDoc.id],
        lastReadQueryDocumentSnapshot: mockQueryDocumentSnapshot,
        hasMore: true,
      );
      when(
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdListFirst(any),
      ).thenAnswer(
        (_) async => mockDefinitionIdListState,
      );
      final testException =
          Exception('fetchHomeRecommendDefinitionIdListMore()で例外発生！！！');
      when(
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdListMore(
          any,
          any,
        ),
      ).thenThrow(testException);

      container.listen(
        definitionIdListStateNotifierProvider(
          DefinitionFeedType.homeRecommend,
        ),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));
      // build()
      await container.read(
        definitionIdListStateNotifierProvider(
          DefinitionFeedType.homeRecommend,
        ).future,
      );
      // build()時にlistenerが発火するため、ここで一旦verify
      verifyInOrder([
        listener.call(any, any),
        listener.call(any, any),
      ]);

      // * Act
      await container
          .read(
            definitionIdListStateNotifierProvider(
              DefinitionFeedType.homeRecommend,
            ).notifier,
          )
          .fetchMore();

      // * Assert
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          AsyncValue.data(mockDefinitionIdListState),
          argThat(
            isA<AsyncData<DefinitionIdListState>>()
                // loading中であることを検証
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', mockDefinitionIdListState),
          ),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          argThat(
            isA<AsyncData<DefinitionIdListState>>()
                .having(
                  (d) => d.isLoading,
                  'isLoading',
                  true,
                )
                .having((d) => d.value, 'value', mockDefinitionIdListState),
          ),
          // AsyncErrorが格納されていることを検証
          argThat(
            isA<AsyncError<DefinitionIdListState>>()
                .having(
                  (d) => d.error,
                  'error',
                  testException,
                )
                // 元々のstateの値がvalueに格納されていることを検証
                .having((d) => d.value, 'value', mockDefinitionIdListState),
          ),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // TODO(me): snackBarを表示させる関数が呼ばれていることを検証する
    });
  });
}
