import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/page/home_page.dart';
import 'package:teigi_app/feature/definition_list/domain/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition_list/repository/definition_id_list_repository.dart';
import 'package:teigi_app/feature/timeline/domain/timeline.dart';
import 'package:teigi_app/feature/timeline/presentation/discover_timeline.dart';
import 'package:teigi_app/feature/timeline/repository/timeline_repository.dart';
import 'package:teigi_app/feature/timeline/repository/timeline_tab_repository.dart';

import 'home_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TimelineRepository>(),
  MockSpec<TimelineTabRepository>(),
  MockSpec<DefinitionIdListRepository>(),
])
void main() {
  const emptyDefinitions = DefinitionIdListState(
    list: [],
    nextCursor: null,
    hasMore: false,
  );

  testWidgets('見つけるは言葉登録者を表示せず言葉を表示する', (tester) async {
    final repository = MockTimelineRepository();
    when(repository.fetchDiscover()).thenAnswer(
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
    await tester.pumpWidget(
      ProviderScope(
        overrides: [timelineRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: DiscoverTimelineView())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('余白'), findsOneWidget);
    expect(find.text('よはく\n言葉が登録されました'), findsOneWidget);
    expect(find.textContaining('登録者'), findsNothing);
  });

  testWidgets('見つけるの取得失敗は一覧領域で再読み込みできる', (tester) async {
    final repository = MockTimelineRepository();
    when(repository.fetchDiscover()).thenThrow(Exception('network error'));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [timelineRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: DiscoverTimelineView())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('再読み込み'), findsOneWidget);
  });

  testWidgets('見つけるは pull-to-refresh で先頭から再取得する', (tester) async {
    final repository = MockTimelineRepository();
    var callCount = 0;
    when(repository.fetchDiscover()).thenAnswer((_) async {
      callCount++;
      return TimelinePage(
        items: [
          TimelineWordRegisteredItem(
            wordId: 'word-$callCount',
            word: callCount == 1 ? '余白' : '自由',
            reading: callCount == 1 ? 'よはく' : 'じゆう',
          ),
        ],
        nextCursor: null,
      );
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [timelineRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: DiscoverTimelineView())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, 500));
    await tester.pumpAndSettle();

    expect(callCount, 2);
    expect(find.text('自由'), findsOneWidget);
  });

  testWidgets('最後のタブを復元し両タブ共通の定義作成 FAB を表示する', (tester) async {
    final timeline = MockTimelineRepository();
    final tabs = MockTimelineTabRepository();
    final definitions = MockDefinitionIdListRepository();
    when(
      timeline.fetchDiscover(),
    ).thenAnswer((_) async => const TimelinePage(items: [], nextCursor: null));
    when(tabs.load()).thenAnswer((_) async => 1);
    when(tabs.save(any)).thenAnswer((_) async {});
    when(
      definitions.fetchForHomeFollowing(null),
    ).thenAnswer((_) async => emptyDefinitions);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timelineRepositoryProvider.overrideWithValue(timeline),
          timelineTabRepositoryProvider.overrideWithValue(tabs),
          definitionIdListRepositoryProvider.overrideWithValue(definitions),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pumpAndSettle();

    final tabBar = tester.widget<TabBar>(find.byType(TabBar));
    expect(tabBar.controller!.index, 1);
    expect(find.text('定義を書く'), findsOneWidget);

    await tester.tap(find.text('見つける'));
    await tester.pumpAndSettle();
    verify(tabs.save(0)).called(greaterThanOrEqualTo(1));
    expect(find.text('定義を書く'), findsOneWidget);
  });
}
