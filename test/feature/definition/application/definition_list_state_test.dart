import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/application/definition_list_notifier.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/repository/definition_repository.dart';
import 'package:teigi_app/feature/definition/util/definition_feed_type.dart';
import 'package:teigi_app/feature/user/repository/entity/user_document.dart';
import 'package:teigi_app/feature/user/repository/user_repository.dart';
import 'package:teigi_app/feature/word/repository/entity/word_document.dart';
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

  /// AsyncNotifierのbuild()に必要なモックのセットアップ
  ///
  /// この関数を呼ぶ前に、fetchHomeRecommendedDefinitionList()や
  /// fetchHomeFollowingDefinitionList()のモックをセットアップしておくこと
  Future<void> setupMockForBuild(
    UserDocument userDocument,
    List<String> followingIdList,
    WordDocument wordDocument, {
    required bool isLikedByUser,
  }) async {
    when(
      mockDefinitionRepository.isLikedByUser(any, any),
    ).thenAnswer((_) async => isLikedByUser);

    when(
      mockUserRepository.fetchUser(any),
    ).thenAnswer((_) async => userDocument);

    when(
      mockUserRepository.fetchFollowingIdList(any),
    ).thenAnswer((_) async => followingIdList);

    when(
      mockWordRepository.fetchWord(any),
    ).thenAnswer((_) async => wordDocument);
  }

  // * build()のテスト -------------------------------------------------------------
  group('build()', () {
    test('DefinitionFeedType.homeRecommendのケース', () async {
      // * Arrange
      // Mock
      when(
        mockDefinitionRepository.fetchHomeRecommendDefinitionList(any, any),
      ).thenAnswer((_) async => mockDefinitionDocumentList);
      await setupMockForBuild(
        mockUserDocument,
        [mockUserDocument.id],
        mockWordDocument,
        isLikedByUser: true,
      );

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

    test('DefinitionFeedType.homeFollowingのケース', () async {
      // * Arrange
      // Mock
      when(
        mockDefinitionRepository.fetchHomeFollowingDefinitionList(any, any),
      ).thenAnswer((_) async => mockDefinitionDocumentList);
      await setupMockForBuild(
        mockUserDocument,
        [mockUserDocument.id],
        mockWordDocument,
        isLikedByUser: true,
      );

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

  // * tapLike()のテスト -----------------------------------------------------------
  group('tapLike()', () {
    test('いいね登録のケース: isLikedByUserとlikesCountが更新されることを確認', () async {
      // * Arrange
      // Mock
      when(
        mockDefinitionRepository.fetchHomeFollowingDefinitionList(any, any),
      ).thenAnswer((_) async => mockDefinitionDocumentList);
      await setupMockForBuild(
        mockUserDocument,
        [mockUserDocument.id],
        mockWordDocument,
        isLikedByUser: false, // falseにすることで、いいね登録のケースを再現
      );

      // definitionListNotifier.build()を完了させる
      final definitionListNotifier = init(DefinitionFeedType.homeFollowing);
      await definitionListNotifier.future;
      // build()時にlistenerがcallされるため、ここでverify
      verify(listener.call(null, const AsyncLoading<List<Definition>>()));
      verify(listener.call(const AsyncLoading<List<Definition>>(), any));

      final baseDefinition = Definition(
        id: mockDefinitionDocumentList[0].id,
        wordId: mockDefinitionDocumentList[0].wordId,
        authorId: mockDefinitionDocumentList[0].authorId,
        word: mockWordDocument.word,
        definition: mockDefinitionDocumentList[0].content,
        updatedAt: mockDefinitionDocumentList[0].updatedAt,
        authorName: mockUserDocument.name,
        authorImageUrl: mockUserDocument.profileImageUrl,
        likesCount: mockDefinitionDocumentList[0].likesCount,
        isLikedByUser: false,
      );
      final baseList = [
        baseDefinition,
      ];
      final updatedList = [
        baseDefinition.copyWith(
          likesCount: baseDefinition.likesCount + 1, // 検証対象
          isLikedByUser: true, // 検証対象
        ),
      ];

      // * Act
      final definition = definitionListNotifier.state.value![0];
      await definitionListNotifier.tapLike(definition);

      // * Assert
      // 想定通りにstateが更新されていることを検証
      verify(
        listener.call(
          // いいね登録前のstate
          argThat(
            isA<AsyncData<List<Definition>>>().having(
              (data) => data.requireValue,
              'value',
              baseList,
            ),
          ),
          // いいね登録後のstate
          argThat(
            isA<AsyncData<List<Definition>>>().having(
              (data) => data.requireValue,
              'value',
              updatedList,
            ),
          ),
        ),
      );
      verifyNoMoreInteractions(listener);

      // 想定通りに関数が呼ばれることを検証
      verify(mockDefinitionRepository.likeDefinition(any, any)).called(1);
      // 想定外の関数が呼ばれないことを検証
      verifyNever(mockDefinitionRepository.unlikeDefinition(any, any));
    });

    test('いいね解除のケース: isLikedByUserとlikesCountが更新されることを確認', () async {
      // * Arrange
      // Mock
      when(
        mockDefinitionRepository.fetchHomeFollowingDefinitionList(any, any),
      ).thenAnswer((_) async => mockDefinitionDocumentList);
      await setupMockForBuild(
        mockUserDocument,
        [mockUserDocument.id],
        mockWordDocument,
        isLikedByUser: true, // trueにすることで、いいね解除のケースを再現
      );

      // definitionListNotifier.build()を完了させる
      final definitionListNotifier = init(DefinitionFeedType.homeFollowing);
      await definitionListNotifier.future;
      // build()時にlistenerがcallされるため、ここでverify
      verify(listener.call(null, const AsyncLoading<List<Definition>>()));
      verify(listener.call(const AsyncLoading<List<Definition>>(), any));

      final baseDefinition = Definition(
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
      );
      final baseList = [
        baseDefinition,
      ];
      final updatedList = [
        baseDefinition.copyWith(
          likesCount: baseDefinition.likesCount - 1, // 検証対象
          isLikedByUser: false, // 検証対象
        ),
      ];

      // * Act
      final definition = definitionListNotifier.state.value![0];
      await definitionListNotifier.tapLike(definition);

      // * Assert
      // 想定通りにstateが更新されていることを検証
      verify(
        listener.call(
          // いいね登録前のstate
          argThat(
            isA<AsyncData<List<Definition>>>().having(
              (data) => data.requireValue,
              'value',
              baseList,
            ),
          ),
          // いいね登録後のstate
          argThat(
            isA<AsyncData<List<Definition>>>().having(
              (data) => data.requireValue,
              'value',
              updatedList,
            ),
          ),
        ),
      );
      verifyNoMoreInteractions(listener);

      // 想定通りに関数が呼ばれることを検証
      verify(mockDefinitionRepository.unlikeDefinition(any, any)).called(1);
      // 想定外の関数が呼ばれないことを検証
      verifyNever(mockDefinitionRepository.likeDefinition(any, any));
    });

    test('エラーがスローされた際にstateにAsyncErrorが入ることを確認', () async {
      // * Arrange
      // Mock
      when(
        mockDefinitionRepository.fetchHomeFollowingDefinitionList(any, any),
      ).thenAnswer((_) async => mockDefinitionDocumentList);
      await setupMockForBuild(
        mockUserDocument,
        [mockUserDocument.id],
        mockWordDocument,
        isLikedByUser: false, // falseにすることで、いいね登録のケースを再現
      );
      // いいね登録時にエラーをスローするように設定
      final exception = Exception('errorやで');
      when(
        mockDefinitionRepository.likeDefinition(any, any),
      ).thenThrow(exception);

      // definitionListNotifier.build()を完了させる
      final definitionListNotifier = init(DefinitionFeedType.homeFollowing);
      await definitionListNotifier.future;
      // build()時にlistenerがcallされるため、ここでverify
      verify(listener.call(null, const AsyncLoading<List<Definition>>()));
      verify(listener.call(const AsyncLoading<List<Definition>>(), any));

      // * Act
      final definition = definitionListNotifier.state.value![0];
      await definitionListNotifier.tapLike(definition);

      // * Assert
      verify(
        listener.call(
          any,
          // エラーがスローされた際、stateにAsyncErrorが入ることを検証
          argThat(
            isA<AsyncError<List<Definition>>>().having(
              (data) => data.error,
              'error',
              exception,
            ),
          ),
        ),
      );
      verifyNoMoreInteractions(listener);
    });
  });
}
