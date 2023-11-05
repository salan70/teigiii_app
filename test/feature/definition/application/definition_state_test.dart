import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition/application/definition_state.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/repository/definition_repository.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';

import '../../../mock/mock_data.dart';
import 'definition_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DefinitionRepository>(),
  MockSpec<UserProfileRepository>(),
  MockSpec<WordRepository>(),
  MockSpec<Listener<AsyncValue<Definition>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockDefinitionRepository = MockDefinitionRepository();
  final mockUserProfileRepository = MockUserProfileRepository();
  final mockWordRepository = MockWordRepository();
  final listener = MockListener();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => 'userId'),
        definitionRepositoryProvider
            .overrideWithValue(mockDefinitionRepository),
        userProfileRepositoryProvider
            .overrideWithValue(mockUserProfileRepository),
        wordRepositoryProvider.overrideWithValue(mockWordRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockDefinitionRepository);
    reset(mockUserProfileRepository);
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
        mockWordRepository.fetchWordById(any),
      ).thenAnswer((_) async => mockWordDoc);
      when(
        mockUserProfileRepository.fetchUserProfile(any),
      ).thenAnswer((_) async => mockUserProfileDoc);
      const isLikedByUser = true;
      when(
        mockDefinitionRepository.isLikedByUser(any, any),
      ).thenAnswer((_) async => isLikedByUser);

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
        word: mockWordDoc.word,
        wordReading: mockWordDoc.reading,
        authorId: mockDefinitionDoc.authorId,
        authorName: mockUserProfileDoc.name,
        authorImageUrl: mockUserProfileDoc.profileImageUrl,
        definition: mockDefinitionDoc.definition,
        isPublic: mockDefinitionDoc.isPublic,
        likesCount: mockDefinitionDoc.likesCount,
        isLikedByUser: isLikedByUser,
        createdAt: mockDefinitionDoc.createdAt,
        updatedAt: mockDefinitionDoc.updatedAt,
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
        mockWordRepository.fetchWordById(mockDefinitionDoc.wordId),
      ).called(1);
      verify(
        mockUserProfileRepository.fetchUserProfile(mockDefinitionDoc.authorId),
      ).called(1);
      verify(
        mockDefinitionRepository.isLikedByUser(
          any,
          mockDefinitionDoc.id,
        ),
      ).called(1);
    });
  });
}
