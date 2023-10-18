import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/application/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition/domain/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition/repository/definition_repository.dart';
import 'package:teigi_app/feature/definition/util/definition_feed_type.dart';
import 'package:teigi_app/feature/user/repository/user_repository.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';

import '../../../mock/mock_data.dart';
import 'definition_id_list_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DefinitionRepository>(),
  MockSpec<UserRepository>(),
  MockSpec<WordRepository>(),
  MockSpec<Listener<AsyncValue<DefinitionIdListState>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockDefinitionRepository = MockDefinitionRepository();
  final mockUserRepository = MockUserRepository();
  final listener = MockListener();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        definitionRepositoryProvider
            .overrideWithValue(mockDefinitionRepository),
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockDefinitionRepository);
    reset(mockUserRepository);
  });
  group('definitionIdList', () {
    test('homeRecommend: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      when(
        mockUserRepository.fetchUser(any),
      ).thenAnswer((_) async => mockUserDoc);
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
      verify(mockUserRepository.fetchUser(any)).called(1);
      verify(
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdListFirst(
          mockUserDoc.mutedUserIdList,
        ),
      ).called(1);
    });

    test('homeFollowing: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      final mockFollowingUserIdList = [
        'userId1',
        'userId2',
        ...mockUserDoc.mutedUserIdList,
      ];

      when(mockUserRepository.fetchFollowingIdList(any)).thenAnswer(
        (_) async => mockFollowingUserIdList,
      );
      when(
        mockUserRepository.fetchUser(any),
      ).thenAnswer((_) async => mockUserDoc);
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
      verify(mockUserRepository.fetchUser(any)).called(1);
      // TODO(me): mutedUserIdListを除外したuserIdListを引数に渡していることを検証
      // 現状は、currentUserIdを関数内でハードコーディングしている影響で未検証
      verify(
        mockDefinitionRepository.fetchHomeFollowingDefinitionIdListFirst(any),
      ).called(1);
    });
  });
}
