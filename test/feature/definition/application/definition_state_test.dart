import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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
}
