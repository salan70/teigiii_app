import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/timeline/application/timeline_state.dart';
import 'package:teigi_app/feature/timeline/domain/timeline.dart';
import 'package:teigi_app/feature/timeline/repository/timeline_repository.dart';

import 'timeline_state_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TimelineRepository>()])
void main() {
  test('discover は nextCursor で取得した union を順序どおり連結する', () async {
    final repository = MockTimelineRepository();
    when(repository.fetchDiscover()).thenAnswer(
      (_) async => const TimelinePage(
        items: [TimelineDefinitionItem('definition-1')],
        nextCursor: 'next',
      ),
    );
    when(repository.fetchDiscover(cursor: 'next')).thenAnswer(
      (_) async => const TimelinePage(
        items: [
          TimelineWordRegisteredItem(
            wordId: 'word-1',
            word: '余白',
            reading: 'よはく',
          ),
        ],
        nextCursor: null,
      ),
    );
    final container = ProviderContainer(
      overrides: [timelineRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(discoverTimelineProvider.future);
    await container.read(discoverTimelineProvider.notifier).fetchMore();

    final page = container.read(discoverTimelineProvider).requireValue;
    expect(page.items, const [
      TimelineDefinitionItem('definition-1'),
      TimelineWordRegisteredItem(wordId: 'word-1', word: '余白', reading: 'よはく'),
    ]);
    expect(page.hasMore, isFalse);
  });
}
