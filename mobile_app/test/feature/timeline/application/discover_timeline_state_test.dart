import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/application/definition_seed_store.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/timeline/application/discover_timeline_state.dart';
import 'package:teigi_app/feature/timeline/domain/discover_feed_list_state.dart';
import 'package:teigi_app/feature/timeline/repository/discover_timeline_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../mock/mock_data.dart';
import 'discover_timeline_state_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DiscoverTimelineRepository>()])
void main() {
  final mockDiscoverTimelineRepository = MockDiscoverTimelineRepository();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        discoverTimelineRepositoryProvider.overrideWithValue(
          mockDiscoverTimelineRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() => reset(mockDiscoverTimelineRepository));

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
  });
}
