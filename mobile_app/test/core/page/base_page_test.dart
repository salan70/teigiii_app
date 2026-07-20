import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/page/dictionary_everyone_page.dart';
import 'package:teigi_app/core/page/dictionary_individual_page.dart';
import 'package:teigi_app/core/page/home_page.dart';
import 'package:teigi_app/core/router/app_router.dart';
import 'package:teigi_app/core/router/auth_guard.dart';
import 'package:teigi_app/core/router/first_launch_guard.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/community_dictionary/domain/community_dictionary.dart';
import 'package:teigi_app/feature/definition_list/domain/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition_list/repository/definition_id_list_repository.dart';
import 'package:teigi_app/feature/personal_dictionary/application/personal_dictionary_state.dart';
import 'package:teigi_app/feature/personal_dictionary/domain/personal_dictionary.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';
import 'package:teigi_app/feature/word_list/domain/word_list_state.dart';
import 'package:teigi_app/feature/word_list/repository/fetch_word_list_repository.dart';

import '../../mock/mock_data.dart';
import 'base_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DefinitionIdListRepository>(),
  MockSpec<UserProfileRepository>(),
])
class _PassAuthGuard extends AuthGuard {
  _PassAuthGuard(super.ref);

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    resolver.next();
  }
}

class _PassFirstLaunchGuard extends FirstLaunchGuard {
  _PassFirstLaunchGuard(super.ref);

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    resolver.next();
  }
}

class _EmptyWordListRepository implements FetchWordListRepository {
  @override
  Future<WordListState> fetchCommunityWordList({
    required CommunityWordFilter filter,
    required String query,
    required String? cursor,
  }) async => const WordListState(list: [], nextCursor: null, hasMore: false);

  @override
  Future<WordListState> fetchWordListStateByInitial(
    String initial,
    String? cursor,
  ) => throw UnimplementedError();

  @override
  Future<WordListState> fetchWordListStateBySearchWord(
    String searchWord,
    String? cursor,
  ) => throw UnimplementedError();
}

({
  MockDefinitionIdListRepository definitionIdList,
  MockUserProfileRepository userProfile,
})
_testRepositories() {
  final definitionIdListRepository = MockDefinitionIdListRepository();
  final userProfileRepository = MockUserProfileRepository();
  const emptyDefinitionList = DefinitionIdListState(
    list: [],
    nextCursor: null,
    hasMore: false,
  );
  when(
    definitionIdListRepository.fetchForHomeRecommend(null),
  ).thenAnswer((_) async => emptyDefinitionList);
  when(
    definitionIdListRepository.fetchForHomeFollowing(null),
  ).thenAnswer((_) async => emptyDefinitionList);
  when(userProfileRepository.fetchUserProfile('current-user')).thenAnswer(
    (_) async => mockUserProfile.copyWith(id: 'current-user', avatarUrl: null),
  );

  return (
    definitionIdList: definitionIdListRepository,
    userProfile: userProfileRepository,
  );
}

Widget _testApp() {
  final repositories = _testRepositories();
  return ProviderScope(
    overrides: [
      authGuardProvider.overrideWith(_PassAuthGuard.new),
      firstLaunchGuardProvider.overrideWith(_PassFirstLaunchGuard.new),
      userIdProvider.overrideWithValue('current-user'),
      personalDictionaryOverviewProvider.overrideWith(
        (ref) async => const PersonalDictionaryOverview.empty(),
      ),
      definitionIdListRepositoryProvider.overrideWithValue(
        repositories.definitionIdList,
      ),
      userProfileRepositoryProvider.overrideWithValue(repositories.userProfile),
    ],
    child: Consumer(
      builder: (context, ref, child) {
        return MaterialApp.router(
          routerConfig: ref.watch(appRouterProvider).config(),
        );
      },
    ),
  );
}

Widget _testTimeline() {
  final repositories = _testRepositories();
  return ProviderScope(
    overrides: [
      userIdProvider.overrideWithValue('current-user'),
      personalDictionaryOverviewProvider.overrideWith(
        (ref) async => const PersonalDictionaryOverview.empty(),
      ),
      definitionIdListRepositoryProvider.overrideWithValue(
        repositories.definitionIdList,
      ),
      userProfileRepositoryProvider.overrideWithValue(repositories.userProfile),
    ],
    child: const MaterialApp(home: HomePage()),
  );
}

Widget _testPersonalDictionary() {
  final repositories = _testRepositories();
  return ProviderScope(
    overrides: [
      userIdProvider.overrideWithValue('current-user'),
      personalDictionaryOverviewProvider.overrideWith(
        (ref) async => const PersonalDictionaryOverview.empty(),
      ),
      userProfileRepositoryProvider.overrideWithValue(repositories.userProfile),
    ],
    child: const MaterialApp(
      home: DictionaryIndividualPage(
        targetUserId: 'current-user',
        isTopRoute: true,
      ),
    ),
  );
}

Future<void> _disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 10 && finder.evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 10));
  }
}

void main() {
  testWidgets('最上位ナビゲーションはあなたの辞書を先頭に3領域を表示する', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump();

    final navigationBar = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );

    expect(navigationBar.items.map((item) => item.label), [
      'あなたの辞書',
      'みんなの辞書',
      'タイムライン',
    ]);
    expect(navigationBar.currentIndex, 0);
    final personalDictionaryTitle = find.descendant(
      of: find.byType(AppBar),
      matching: find.text('あなたの辞書'),
    );
    await _pumpUntilFound(tester, personalDictionaryTitle);
    expect(personalDictionaryTitle, findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('あなたの辞書は検索とアカウント導線を表示する', (tester) async {
    await tester.pumpWidget(_testPersonalDictionary());
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('global-search-button')), findsOneWidget);
    expect(find.byKey(const Key('account-menu-button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('account-menu-button')));
    await tester.pump();
    expect(find.text('公開プロフィール'), findsOneWidget);
    expect(find.text('プロフィール編集'), findsOneWidget);
    expect(find.text('設定'), findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('検索導線は共通検索画面へ遷移する', (tester) async {
    await tester.pumpWidget(_testApp());
    await _pumpUntilFound(
      tester,
      find.byKey(const Key('global-search-button')),
    );

    await tester.tap(find.byKey(const Key('global-search-button')));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('検索'), findsOneWidget);
    expect(find.text('言葉またはユーザーを検索'), findsOneWidget);

    tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar)).onTap!(
      0,
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('言葉またはユーザーを検索'), findsNothing);
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('あなたの辞書'),
      ),
      findsOneWidget,
    );

    await _disposeApp(tester);
  });

  testWidgets('タイムラインは見つけるとフォロー中を表示する', (tester) async {
    await tester.pumpWidget(_testTimeline());
    await tester.pump();

    expect(find.text('見つける'), findsOneWidget);
    expect(find.text('フォロー中'), findsOneWidget);
    expect(find.byKey(const Key('global-search-button')), findsOneWidget);
    expect(find.byKey(const Key('account-menu-button')), findsNothing);

    await _disposeApp(tester);
  });

  testWidgets('みんなの辞書は検索と言葉登録をヘッダーに表示する', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fetchWordListRepositoryProvider.overrideWithValue(
            _EmptyWordListRepository(),
          ),
        ],
        child: const MaterialApp(home: DictionaryEveryonePage()),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('global-search-button')), findsOneWidget);
    expect(find.text('言葉を登録'), findsOneWidget);
    expect(find.byKey(const Key('account-menu-button')), findsNothing);

    await _disposeApp(tester);
  });
}
