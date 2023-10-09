import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/application/definition_list_notifier.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/repository/definition_repository.dart';
import 'package:teigi_app/feature/definition/util/definition_feed_type.dart';
import 'package:teigi_app/feature/user/repository/user_repository.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';

import '../../../mock/mock_data.dart';
import 'definition_list_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DefinitionRepository>(),
  MockSpec<UserRepository>(),
  MockSpec<WordRepository>(),
  MockSpec<ChangeListener<AsyncValue<List<Definition>>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class ChangeListener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockDefinitionRepository = MockDefinitionRepository();
  final mockUserRepository = MockUserRepository();
  final mockWordRepository = MockWordRepository();
  final listener = MockChangeListener();

  tearDown(() {
    reset(mockDefinitionRepository);
    reset(mockUserRepository);
    reset(mockWordRepository);
    reset(listener);
  });

  DefinitionListNotifier init(DefinitionFeedType definitionFeedType) {
    final container = ProviderContainer(
      overrides: [
        definitionRepositoryProvider
            .overrideWithValue(mockDefinitionRepository),
        userRepositoryProvider.overrideWithValue(mockUserRepository),
        wordRepositoryProvider.overrideWithValue(mockWordRepository),
      ],
    );
    addTearDown(container.dispose);

    container.listen(
      definitionListNotifierProvider(definitionFeedType),
      listener,
      fireImmediately: true,
    );

    return container.read(
      definitionListNotifierProvider(definitionFeedType).notifier,
    );
  }

  group('build()', () {
    test('homeRecommend', () async {
      // * Arrange
      // Mock
      when(
        mockDefinitionRepository.fetchHomeRecommendDefinitionList(any, any),
      ).thenAnswer((_) async => mockDefinitionDocumentList);

      when(
        mockDefinitionRepository.isLikedByUser(any, any),
      ).thenAnswer((_) async => true);

      when(
        mockUserRepository.fetchUser(any),
      ).thenAnswer((_) async => mockUserDocument);

      when(
        mockUserRepository.fetchFollowingIdList(any),
      ).thenAnswer((_) async => ['id']);

      when(
        mockWordRepository.fetchWord(any),
      ).thenAnswer((_) async => mockWordDocument);

      final expectedDefinitionList = [
        Definition(
          id: mockDefinitionDocumentList[0].id,
          wordId: mockDefinitionDocumentList[0].wordId,
          authorId: mockDefinitionDocumentList[0].authorId,
          word: mockWordDocument.word,
          definition: mockDefinitionDocumentList[0].content,
          updatedAt: mockDefinitionDocumentList[0].updatedAt,
          authorName: mockUserDocument.name,
          authorImageUrl: mockUserDocument.profileImageUrl,
          likesCount: mockDefinitionDocumentList[0].likesCount,
          isLikedByUser: true,
        ),
      ];

      // * Act
      final definitionListNotifier = init(DefinitionFeedType.homeRecommend);
      await definitionListNotifier.future;

      // * Assert
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<List<Definition>>(),
        ),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        listener.call(
          const AsyncLoading<List<Definition>>(),
          argThat(
            isA<AsyncData<List<Definition>>>().having(
              (data) => data.requireValue,
              'value',
              expectedDefinitionList,
            ),
          ),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りに関数が呼ばれることを検証
      verify(
        mockDefinitionRepository.fetchHomeRecommendDefinitionList(
          any,
          any,
        ),
      ).called(1);

      // 想定外の関数が呼ばれないことを検証
      verifyNever(
        mockDefinitionRepository.fetchHomeFollowingDefinitionList(
          any,
          any,
        ),
      );
    });

    test('homeFollowing', () async {
      // * Arrange
      // Mock
      when(
        mockDefinitionRepository.fetchHomeFollowingDefinitionList(any, any),
      ).thenAnswer((_) async => mockDefinitionDocumentList);

      when(
        mockDefinitionRepository.isLikedByUser(any, any),
      ).thenAnswer((_) async => true);

      when(
        mockUserRepository.fetchUser(any),
      ).thenAnswer((_) async => mockUserDocument);

      when(
        mockUserRepository.fetchFollowingIdList(any),
      ).thenAnswer((_) async => ['id', 'mutedUserId']);

      when(
        mockWordRepository.fetchWord(any),
      ).thenAnswer((_) async => mockWordDocument);

      final expectedDefinitionList = [
        Definition(
          id: mockDefinitionDocumentList[0].id,
          wordId: mockDefinitionDocumentList[0].wordId,
          authorId: mockDefinitionDocumentList[0].authorId,
          word: mockWordDocument.word,
          definition: mockDefinitionDocumentList[0].content,
          updatedAt: mockDefinitionDocumentList[0].updatedAt,
          authorName: mockUserDocument.name,
          authorImageUrl: mockUserDocument.profileImageUrl,
          likesCount: mockDefinitionDocumentList[0].likesCount,
          isLikedByUser: true,
        ),
      ];

      // * Act
      final definitionListNotifier = init(DefinitionFeedType.homeFollowing);
      await definitionListNotifier.future;

      // * Assert
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<List<Definition>>(),
        ),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        listener.call(
          const AsyncLoading<List<Definition>>(),
          argThat(
            isA<AsyncData<List<Definition>>>().having(
              (data) => data.requireValue,
              'value',
              expectedDefinitionList,
            ),
          ),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りに関数が呼ばれることを検証
      verify(
        mockDefinitionRepository.fetchHomeFollowingDefinitionList(
          any,
          any,
        ),
      ).called(1);

      // 想定外の関数が呼ばれないことを検証
      verifyNever(
        mockDefinitionRepository.fetchHomeRecommendDefinitionList(
          any,
          any,
        ),
      );
    });
  });
}
