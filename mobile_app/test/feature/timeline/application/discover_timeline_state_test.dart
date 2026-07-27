import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/application/definition_seed_store.dart';
import 'package:teigi_app/feature/definition/application/definition_state.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/repository/fetch_definition_repository.dart';
import 'package:teigi_app/feature/timeline/application/discover_timeline_state.dart';
import 'package:teigi_app/feature/timeline/domain/discover_feed_list_state.dart';
import 'package:teigi_app/feature/timeline/repository/discover_timeline_repository.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../mock/mock_data.dart';
import 'discover_timeline_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DiscoverTimelineRepository>(),
  MockSpec<FetchDefinitionRepository>(),
  MockSpec<UserProfileRepository>(),
])
void main() {
  final mockDiscoverTimelineRepository = MockDiscoverTimelineRepository();
  final mockFetchDefinitionRepository = MockFetchDefinitionRepository();
  final mockUserProfileRepository = MockUserProfileRepository();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        discoverTimelineRepositoryProvider.overrideWithValue(
          mockDiscoverTimelineRepository,
        ),
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
    reset(mockDiscoverTimelineRepository);
    reset(mockFetchDefinitionRepository);
    reset(mockUserProfileRepository);
  });

  final wordRegisteredActivity = WordRegisteredActivity(
    type: WordRegisteredActivityTypeEnum.wordRegistered,
    occurredAt: DateTime.utc(2026, 7, 18),
    word: WordSummary(id: 'word2', word: '言葉', reading: 'ことば'),
  );

  final firstDefinition = mockDefinition.copyWith(id: 'definition1');
  final secondDefinition = mockDefinition.copyWith(id: 'definition2');

  group('DiscoverTimelineStateNotifier', () {
    test('build 後、取得した定義がシードストアに投入される', () async {
      // * Arrange
      when(
        mockDiscoverTimelineRepository.fetchDiscoverTimeline(null),
      ).thenAnswer(
        (_) async => DiscoverFeedListState(
          list: [firstDefinition, wordRegisteredActivity],
          nextCursor: 'cursor1',
          hasMore: true,
        ),
      );

      // * Act
      await container.read(discoverTimelineStateNotifierProvider.future);

      // * Assert
      final store = container.read(definitionSeedStoreProvider);
      expect(store.read(firstDefinition.id), firstDefinition);
    });

    test('fetchMore 後、追加取得した定義もシードストアに投入される', () async {
      // * Arrange
      when(
        mockDiscoverTimelineRepository.fetchDiscoverTimeline(null),
      ).thenAnswer(
        (_) async => DiscoverFeedListState(
          list: [firstDefinition],
          nextCursor: 'cursor1',
          hasMore: true,
        ),
      );
      when(
        mockDiscoverTimelineRepository.fetchDiscoverTimeline('cursor1'),
      ).thenAnswer(
        (_) async => DiscoverFeedListState(
          list: [secondDefinition, wordRegisteredActivity],
          nextCursor: null,
          hasMore: false,
        ),
      );
      await container.read(discoverTimelineStateNotifierProvider.future);

      // * Act
      await container
          .read(discoverTimelineStateNotifierProvider.notifier)
          .fetchMore();

      // * Assert
      final store = container.read(definitionSeedStoreProvider);
      expect(store.read(firstDefinition.id), firstDefinition);
      expect(store.read(secondDefinition.id), secondDefinition);

      final state = container
          .read(discoverTimelineStateNotifierProvider)
          .value!;
      expect(state.list.whereType<Definition>().length, 2);
      expect(state.hasMore, isFalse);
    });

    test('同一 ID を再取得した場合、購読中の definitionProvider も新しい値になる', () async {
      // * Arrange
      final oldDefinition = firstDefinition.copyWith(
        definition: '古い本文',
        likesCount: 1,
        isLikedByUser: false,
      );
      final newDefinition = firstDefinition.copyWith(
        definition: '新しい本文',
        likesCount: 9,
        isLikedByUser: true,
      );
      when(
        mockDiscoverTimelineRepository.fetchDiscoverTimeline(null),
      ).thenAnswer(
        (_) async => DiscoverFeedListState(
          list: [oldDefinition],
          nextCursor: null,
          hasMore: false,
        ),
      );
      await container.read(discoverTimelineStateNotifierProvider.future);
      final before = await container.read(
        definitionProvider(oldDefinition.id).future,
      );
      expect(before.definition, '古い本文');
      expect(before.likesCount, 1);

      when(
        mockDiscoverTimelineRepository.fetchDiscoverTimeline(null),
      ).thenAnswer(
        (_) async => DiscoverFeedListState(
          list: [newDefinition],
          nextCursor: null,
          hasMore: false,
        ),
      );

      // * Act
      container.invalidate(discoverTimelineStateNotifierProvider);
      await container.read(discoverTimelineStateNotifierProvider.future);
      final after = await container.read(
        definitionProvider(oldDefinition.id).future,
      );

      // * Assert
      expect(after.definition, '新しい本文');
      expect(after.likesCount, 9);
      expect(after.isLikedByUser, isTrue);
      verifyNever(mockFetchDefinitionRepository.fetchDefinition(any));
    });

    test('refresh 後に消えた ID のシードは破棄され単体取得に戻る', () async {
      // * Arrange
      when(
        mockDiscoverTimelineRepository.fetchDiscoverTimeline(null),
      ).thenAnswer(
        (_) async => DiscoverFeedListState(
          list: [firstDefinition, secondDefinition],
          nextCursor: null,
          hasMore: false,
        ),
      );
      await container.read(discoverTimelineStateNotifierProvider.future);
      expect(
        container.read(definitionSeedStoreProvider).read(secondDefinition.id),
        secondDefinition,
      );

      when(
        mockDiscoverTimelineRepository.fetchDiscoverTimeline(null),
      ).thenAnswer(
        (_) async => DiscoverFeedListState(
          list: [firstDefinition],
          nextCursor: null,
          hasMore: false,
        ),
      );
      when(
        mockFetchDefinitionRepository.fetchDefinition(secondDefinition.id),
      ).thenAnswer((_) async => secondDefinition.copyWith(likesCount: 42));
      when(
        mockUserProfileRepository.fetchUserProfile(secondDefinition.authorId),
      ).thenAnswer((_) async => mockUserProfile);

      // * Act
      container.invalidate(discoverTimelineStateNotifierProvider);
      await container.read(discoverTimelineStateNotifierProvider.future);

      // * Assert
      expect(
        container.read(definitionSeedStoreProvider).read(secondDefinition.id),
        isNull,
      );
      expect(
        container.read(definitionSeedStoreProvider).read(firstDefinition.id),
        firstDefinition,
      );

      final fetched = await container.read(
        definitionProvider(secondDefinition.id).future,
      );
      expect(fetched.likesCount, 42);
      verify(
        mockFetchDefinitionRepository.fetchDefinition(secondDefinition.id),
      ).called(1);
    });
  });
}
