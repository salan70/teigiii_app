import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/application/definition_state.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/repository/definition_repository.dart';
import 'package:teigi_app/feature/definition/util/definition_feed_type.dart';
import 'package:teigi_app/feature/user/repository/user_repository.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';

import '../../../mock/mock_data.dart';
import 'definition_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DefinitionRepository>(),
  MockSpec<UserRepository>(),
  MockSpec<WordRepository>(),
])
class MockDefinitionListener
    with Mock
    implements Listener<AsyncValue<Definition>> {}

class MockDefinitionIdListListener
    with Mock
    implements Listener<AsyncValue<List<String>>> {}

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockDefinitionRepository = MockDefinitionRepository();
  final mockUserRepository = MockUserRepository();
  final mockWordRepository = MockWordRepository();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        definitionRepositoryProvider
            .overrideWithValue(mockDefinitionRepository),
        userRepositoryProvider.overrideWithValue(mockUserRepository),
        wordRepositoryProvider.overrideWithValue(mockWordRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockDefinitionRepository);
    reset(mockUserRepository);
    reset(mockWordRepository);
  });

  group('definition', () {
    test('stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      when(
        mockDefinitionRepository.fetchDefinition(any),
      ).thenAnswer((_) async => mockDefinitionDoc);
      when(
        mockWordRepository.fetchWord(any),
      ).thenAnswer((_) async => mockWordDoc);
      when(
        mockUserRepository.fetchUser(any),
      ).thenAnswer((_) async => mockUserDoc);
      const isLikedByUser = true;
      when(
        mockDefinitionRepository.isLikedByUser(any, any),
      ).thenAnswer((_) async => isLikedByUser);

      final listener = MockDefinitionListener();
      container.listen(
        definitionProvider(mockDefinitionDoc.id),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        definitionProvider(mockDefinitionDoc.id).future,
      );

      // * Assert
      final expected = Definition(
        id: mockDefinitionDoc.id,
        wordId: mockDefinitionDoc.wordId,
        authorId: mockDefinitionDoc.authorId,
        word: mockWordDoc.word,
        definition: mockDefinitionDoc.content,
        updatedAt: mockDefinitionDoc.updatedAt,
        authorName: mockUserDoc.name,
        authorImageUrl: mockUserDoc.profileImageUrl,
        likesCount: mockDefinitionDoc.likesCount,
        isLikedByUser: isLikedByUser,
      );
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<Definition>(),
        ),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        listener.call(
          const AsyncLoading<Definition>(),
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockDefinitionRepository.fetchDefinition(mockDefinitionDoc.id),
      ).called(1);
      verify(
        mockWordRepository.fetchWord(mockDefinitionDoc.wordId),
      ).called(1);
      verify(
        mockUserRepository.fetchUser(mockDefinitionDoc.authorId),
      ).called(1);
      verify(
        mockDefinitionRepository.isLikedByUser(
          any,
          mockDefinitionDoc.id,
        ),
      ).called(1);
    });
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
        mockDefinitionRepository.fetchHomeRecommendDefinitionIdList(any),
      ).thenAnswer((_) async => mockDefinitionIdList);

      final listener = MockDefinitionIdListListener();
      container.listen(
        definitionIdListProvider(DefinitionFeedType.homeRecommend),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        definitionIdListProvider(DefinitionFeedType.homeRecommend).future,
      );

      // * Assert
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<List<String>>(),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          const AsyncLoading<List<String>>(),
          // fetchHomeRecommendDefinitionIdListの戻り値がそのまま格納されていることを検証
          AsyncValue.data(mockDefinitionIdList),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(mockUserRepository.fetchUser(any)).called(1);
      verify(
        mockDefinitionRepository
            .fetchHomeRecommendDefinitionIdList(mockUserDoc.mutedUserIdList),
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
        mockDefinitionRepository.fetchHomeFollowingDefinitionList(any),
      ).thenAnswer((_) async => mockDefinitionIdList);

      final listener = MockDefinitionIdListListener();
      container.listen(
        definitionIdListProvider(DefinitionFeedType.homeFollowing),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        definitionIdListProvider(DefinitionFeedType.homeFollowing).future,
      );

      // * Assert
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<List<String>>(),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          const AsyncLoading<List<String>>(),
          // fetchHomeRecommendDefinitionIdListの戻り値がそのまま格納されていることを検証
          AsyncValue.data(mockDefinitionIdList),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(mockUserRepository.fetchUser(any)).called(1);
      // TODO(me): mutedUserIdListを除外したuserIdListを引数に渡していることを検証
      // 現状は、currentUserIdを関数内でハードコーディングしている影響で未検証
      verify(
        mockDefinitionRepository
            .fetchHomeFollowingDefinitionList(any),
      ).called(1);
    });
  });
}
