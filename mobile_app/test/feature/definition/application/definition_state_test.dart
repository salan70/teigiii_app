import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/application/definition_seed_store.dart';
import 'package:teigi_app/feature/definition/application/definition_state.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/repository/fetch_definition_repository.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';

import '../../../mock/mock_data.dart';
import 'definition_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FetchDefinitionRepository>(),
  MockSpec<UserProfileRepository>(),
  MockSpec<Listener<AsyncValue<Definition>>>(),
])
// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
  // ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockFetchDefinitionRepository = MockFetchDefinitionRepository();
  final mockUserProfileRepository = MockUserProfileRepository();
  final listener = MockListener();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userProfileProvider(
          mockUserProfile.id,
        ).overrideWith((ref) => mockUserProfile),
        fetchDefinitionRepositoryProvider.overrideWithValue(
          mockFetchDefinitionRepository,
        ),
        userProfileRepositoryProvider.overrideWithValue(
          mockUserProfileRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockFetchDefinitionRepository);
    reset(mockUserProfileRepository);
  });

  group('definition', () {
    test('stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      when(mockFetchDefinitionRepository.fetchDefinition(any)).thenAnswer(
        (_) async => mockDefinition.copyWith(
          authorId: mockUserProfile.id,
          authorName: 'API response name',
          authorImageUrl: 'https://api.example.com/stale-avatar',
          isLikedByUser: true,
        ),
      );

      container.listen(
        definitionProvider(mockDefinition.id),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(definitionProvider(mockDefinition.id).future);

      // * Assert
      final expected = mockDefinition.copyWith(
        authorId: mockUserProfile.id,
        authorName: mockUserProfile.name,
        authorImageUrl: mockUserProfile.avatarUrl,
        isLikedByUser: true,
      );
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(null, const AsyncLoading<Definition>()),
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
        mockFetchDefinitionRepository.fetchDefinition(mockDefinition.id),
      ).called(1);
    });
  });

  group('definition（シード経路）', () {
    /// 実際の運用と同じく `userProfileProvider` を override しない container。
    /// シード経路でプロフィール取得が走らないことを検証するために使う。
    ProviderContainer buildContainer() {
      final container = ProviderContainer(
        overrides: [
          fetchDefinitionRepositoryProvider.overrideWithValue(
            mockFetchDefinitionRepository,
          ),
          userProfileRepositoryProvider.overrideWithValue(
            mockUserProfileRepository,
          ),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('シード済みの場合、定義取得もプロフィール取得も行わない', () async {
      // * Arrange
      final seededContainer = buildContainer();
      final seeded = mockDefinition.copyWith(
        authorName: 'feed name',
        authorImageUrl: 'https://api.example.com/feed-avatar',
      );
      seededContainer.read(definitionSeedStoreProvider).seedAll('test-feed', [
        seeded,
      ]);

      // * Act
      final actual = await seededContainer.read(
        definitionProvider(seeded.id).future,
      );

      // * Assert
      expect(actual, seeded);
      verifyNever(mockFetchDefinitionRepository.fetchDefinition(any));
      verifyNever(mockUserProfileRepository.fetchUserProfile(any));
    });

    test('未シードの場合は従来どおり取得する', () async {
      // * Arrange
      final seededContainer = buildContainer();
      when(
        mockFetchDefinitionRepository.fetchDefinition(any),
      ).thenAnswer((_) async => mockDefinition);
      when(
        mockUserProfileRepository.fetchUserProfile(any),
      ).thenAnswer((_) async => mockUserProfile);

      // * Act
      await seededContainer.read(definitionProvider(mockDefinition.id).future);

      // * Assert
      verify(
        mockFetchDefinitionRepository.fetchDefinition(mockDefinition.id),
      ).called(1);
      verify(
        mockUserProfileRepository.fetchUserProfile(mockDefinition.authorId),
      ).called(1);
    });

    test('refreshDefinition 後はシードが破棄され再取得される', () async {
      // * Arrange
      final seededContainer = buildContainer();
      seededContainer.read(definitionSeedStoreProvider).seedAll('test-feed', [
        mockDefinition,
      ]);
      when(
        mockFetchDefinitionRepository.fetchDefinition(any),
      ).thenAnswer((_) async => mockDefinition.copyWith(likesCount: 10));
      when(
        mockUserProfileRepository.fetchUserProfile(any),
      ).thenAnswer((_) async => mockUserProfile);
      await seededContainer.read(definitionProvider(mockDefinition.id).future);
      verifyNever(mockFetchDefinitionRepository.fetchDefinition(any));

      // * Act
      seededContainer
          .read(refreshDefinitionTestRefProvider)
          .refreshDefinition(mockDefinition.id);
      final actual = await seededContainer.read(
        definitionProvider(mockDefinition.id).future,
      );

      // * Assert
      expect(actual.likesCount, 10);
      expect(
        seededContainer
            .read(definitionSeedStoreProvider)
            .read(mockDefinition.id),
        isNull,
      );
      verify(
        mockFetchDefinitionRepository.fetchDefinition(mockDefinition.id),
      ).called(1);
    });
  });
}

/// `refreshDefinition`（`Ref` 拡張）をテストから呼ぶための [Ref] 提供 provider。
final refreshDefinitionTestRefProvider = Provider<Ref>((ref) => ref);
