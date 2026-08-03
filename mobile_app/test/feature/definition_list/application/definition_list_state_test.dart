import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition/application/definition_seed_store.dart';
import 'package:teigi_app/feature/definition/application/definition_state.dart';
import 'package:teigi_app/feature/definition/repository/fetch_definition_repository.dart';
import 'package:teigi_app/feature/definition_list/application/definition_list_state.dart';
import 'package:teigi_app/feature/definition_list/domain/definition_list_state.dart';
import 'package:teigi_app/feature/definition_list/repository/definition_list_repository.dart';
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';

import '../../../mock/mock_data.dart';
import 'definition_list_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DefinitionListRepository>(),
  MockSpec<FetchDefinitionRepository>(),
  MockSpec<UserProfileRepository>(),
])
void main() {
  final repository = MockDefinitionListRepository();
  final fetchDefinitionRepository = MockFetchDefinitionRepository();
  final userProfileRepository = MockUserProfileRepository();
  var currentUserId = 'user-1';
  late ProviderContainer container;

  setUp(() {
    currentUserId = 'user-1';
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => currentUserId),
        definitionListRepositoryProvider.overrideWithValue(repository),
        fetchDefinitionRepositoryProvider.overrideWithValue(
          fetchDefinitionRepository,
        ),
        userProfileRepositoryProvider.overrideWithValue(userProfileRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(repository);
    reset(fetchDefinitionRepository);
    reset(userProfileRepository);
  });

  test('初回取得は null cursor を渡す', () async {
    when(repository.fetchForHomeRecommend(null)).thenAnswer(
      (_) async => DefinitionListState(
        list: [definitionOf('definition-1')],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = definitionListStateNotifierProvider(
      DefinitionFeedType.homeRecommend,
    );

    final state = await container.read(provider.future);

    expect(state.list, [definitionOf('definition-1')]);
    verify(repository.fetchForHomeRecommend(null)).called(1);
  });

  test('fetchMore は nextCursor を渡して結果を連結する', () async {
    when(repository.fetchForHomeFollowing(null)).thenAnswer(
      (_) async => DefinitionListState(
        list: [definitionOf('definition-1')],
        nextCursor: 'cursor-1',
        hasMore: true,
      ),
    );
    when(repository.fetchForHomeFollowing('cursor-1')).thenAnswer(
      (_) async => DefinitionListState(
        list: [definitionOf('definition-2')],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = definitionListStateNotifierProvider(
      DefinitionFeedType.homeFollowing,
    );
    await container.read(provider.future);

    await container.read(provider.notifier).fetchMore();

    expect(
      container.read(provider).value,
      DefinitionListState(
        list: [definitionOf('definition-1'), definitionOf('definition-2')],
        nextCursor: null,
        hasMore: false,
      ),
    );
    verify(repository.fetchForHomeFollowing('cursor-1')).called(1);
  });

  test('hasMore が false の場合は追加取得しない', () async {
    when(repository.fetchForHomeRecommend(null)).thenAnswer(
      (_) async => DefinitionListState(
        list: [definitionOf('definition-1')],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = definitionListStateNotifierProvider(
      DefinitionFeedType.homeRecommend,
    );
    await container.read(provider.future);

    await container.read(provider.notifier).fetchMore();

    verify(repository.fetchForHomeRecommend(null)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('アカウントが切り替わると初回 cursor から再取得する', () async {
    when(repository.fetchForHomeRecommend(null)).thenAnswer(
      (_) async => DefinitionListState(
        list: [definitionOf(currentUserId)],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = definitionListStateNotifierProvider(
      DefinitionFeedType.homeRecommend,
    );

    expect(
      (await container.read(
        provider.future,
      )).list.map((definition) => definition.id),
      ['user-1'],
    );
    currentUserId = 'user-2';
    container.invalidate(userIdProvider);

    expect(
      (await container.read(
        provider.future,
      )).list.map((definition) => definition.id),
      ['user-2'],
    );
    verify(repository.fetchForHomeRecommend(null)).called(2);
  });

  test('fetchMore 失敗時は AsyncError に前回の一覧を保持する', () async {
    final initialState = DefinitionListState(
      list: [definitionOf('definition-1')],
      nextCursor: 'cursor-1',
      hasMore: true,
    );
    final exception = Exception('fetch failed');
    when(
      repository.fetchForHomeRecommend(null),
    ).thenAnswer((_) async => initialState);
    when(repository.fetchForHomeRecommend('cursor-1')).thenThrow(exception);
    final provider = definitionListStateNotifierProvider(
      DefinitionFeedType.homeRecommend,
    );
    await container.read(provider.future);

    await container.read(provider.notifier).fetchMore();

    final result = container.read(provider);
    expect(result, isA<AsyncError<DefinitionListState>>());
    expect(result.error, same(exception));
    expect(result.value, initialState);
  });

  group('シード投入（N+1 の解消）', () {
    test('一覧に含まれる定義はシードされ、tile 側で単体取得が発生しない', () async {
      // * Arrange
      when(repository.fetchForHomeFollowing(null)).thenAnswer(
        (_) async => DefinitionListState(
          list: [definitionOf('definition-1'), definitionOf('definition-2')],
          nextCursor: null,
          hasMore: false,
        ),
      );
      final provider = definitionListStateNotifierProvider(
        DefinitionFeedType.homeFollowing,
      );

      // * Act
      await container.read(provider.future);
      final definition = await container.read(
        definitionProvider('definition-1').future,
      );

      // * Assert
      expect(definition.id, 'definition-1');
      verifyNever(fetchDefinitionRepository.fetchDefinition(any));
      verifyNever(userProfileRepository.fetchUserProfile(any));
    });

    test('refresh でフィードから消えた定義のシードは破棄される', () async {
      // * Arrange
      when(repository.fetchForHomeFollowing(null)).thenAnswer(
        (_) async => DefinitionListState(
          list: [definitionOf('definition-1'), definitionOf('definition-2')],
          nextCursor: null,
          hasMore: false,
        ),
      );
      final provider = definitionListStateNotifierProvider(
        DefinitionFeedType.homeFollowing,
      );
      await container.read(provider.future);

      when(repository.fetchForHomeFollowing(null)).thenAnswer(
        (_) async => DefinitionListState(
          list: [definitionOf('definition-1')],
          nextCursor: null,
          hasMore: false,
        ),
      );

      // * Act
      container.invalidate(provider);
      await container.read(provider.future);

      // * Assert
      final store = container.read(definitionSeedStoreProvider);
      expect(store.read('definition-1'), isNotNull);
      expect(store.read('definition-2'), isNull);
    });

    test('別フィードの refresh では、このフィードのシードが消えない', () async {
      // * Arrange
      when(repository.fetchForHomeFollowing(null)).thenAnswer(
        (_) async => DefinitionListState(
          list: [definitionOf('following-1')],
          nextCursor: null,
          hasMore: false,
        ),
      );
      when(repository.fetchForHomeRecommend(null)).thenAnswer(
        (_) async => DefinitionListState(
          list: [definitionOf('recommend-1')],
          nextCursor: null,
          hasMore: false,
        ),
      );
      final followingProvider = definitionListStateNotifierProvider(
        DefinitionFeedType.homeFollowing,
      );
      final recommendProvider = definitionListStateNotifierProvider(
        DefinitionFeedType.homeRecommend,
      );
      await container.read(followingProvider.future);
      await container.read(recommendProvider.future);

      // * Act
      container.invalidate(recommendProvider);
      await container.read(recommendProvider.future);

      // * Assert
      final store = container.read(definitionSeedStoreProvider);
      expect(store.read('following-1'), isNotNull);
      expect(store.read('recommend-1'), isNotNull);
    });
  });
}
