import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/admob/presentation/banner_ad_widget.dart';
import 'package:teigi_app/feature/definition/application/definition_seed_store.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/repository/fetch_definition_repository.dart';
import 'package:teigi_app/feature/timeline/application/discover_timeline_state.dart';
import 'package:teigi_app/feature/timeline/domain/discover_feed_entry.dart';
import 'package:teigi_app/feature/timeline/domain/discover_feed_list_state.dart';
import 'package:teigi_app/feature/timeline/presentation/discover_timeline_list.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';

import '../../../mock/mock_data.dart';
import 'discover_timeline_list_test.mocks.dart';

/// シード済みの一覧を返す [DiscoverTimelineStateNotifier].
class _SeededDiscoverTimelineStateNotifier
    extends DiscoverTimelineStateNotifier {
  static late List<Definition> definitions;

  @override
  FutureOr<DiscoverFeedListState> build() {
    ref.read(definitionSeedStoreProvider).seedAll('test-feed', definitions);
    return DiscoverFeedListState(
      list: definitions.map(DiscoverFeedEntry.definition).toList(),
      nextCursor: null,
      hasMore: false,
    );
  }
}

@GenerateNiceMocks([
  MockSpec<FetchDefinitionRepository>(),
  MockSpec<UserProfileRepository>(),
])
void main() {
  late MockFetchDefinitionRepository mockFetchDefinitionRepository;
  late MockUserProfileRepository mockUserProfileRepository;

  setUp(() {
    mockFetchDefinitionRepository = MockFetchDefinitionRepository();
    mockUserProfileRepository = MockUserProfileRepository();
  });

  testWidgets('シード済みの定義は単体取得もプロフィール取得もせずに描画される', (tester) async {
    _SeededDiscoverTimelineStateNotifier.definitions = List.generate(
      20,
      (index) => mockDefinition.copyWith(
        id: 'definition$index',
        word: '言葉$index',
        definition: '定義$index',
        // ネットワーク画像の読み込みを避け、デフォルトアバターを使わせる。
        authorImageUrl: null,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discoverTimelineStateNotifierProvider.overrideWith(
            _SeededDiscoverTimelineStateNotifier.new,
          ),
          fetchDefinitionRepositoryProvider.overrideWithValue(
            mockFetchDefinitionRepository,
          ),
          userProfileRepositoryProvider.overrideWithValue(
            mockUserProfileRepository,
          ),
          bannerAdWidgetProvider.overrideWithValue(const SizedBox(height: 64)),
        ],
        child: const MaterialApp(
          home: Scaffold(body: DiscoverTimelineList(emptyWidget: null)),
        ),
      ),
    );
    // アバター画像のローディングが settle しないため、固定回数だけ pump する。
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // shimmer を挟まず、初回 pump の時点で本文が描画されていること。
    expect(find.text('言葉0'), findsOneWidget);
    expect(find.text('定義0'), findsOneWidget);

    // スクロールして新しい tile が可視になっても単体取得が発生しないこと。
    await tester.drag(
      find.byType(CustomScrollView),
      const Offset(0, -800),
      touchSlopY: 0,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    verifyNever(mockFetchDefinitionRepository.fetchDefinition(any));
    verifyNever(mockUserProfileRepository.fetchUserProfile(any));
  });
}
