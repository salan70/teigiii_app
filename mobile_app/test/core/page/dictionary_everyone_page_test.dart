import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/dictionary_everyone_page.dart';
import 'package:teigi_app/feature/community_dictionary/application/community_word_list.dart';
import 'package:teigi_app/feature/community_dictionary/domain/community_dictionary.dart';
import 'package:teigi_app/feature/word/domain/word.dart';
import 'package:teigi_app/feature/word_list/domain/word_list_state.dart';
import 'package:teigi_app/feature/word_list/repository/fetch_word_list_repository.dart';

class _FetchWordListRepositoryStub implements FetchWordListRepository {
  final calls =
      <({CommunityWordFilter filter, String query, String? cursor})>[];
  Exception? error;

  static const first = Word(
    id: 'word-1',
    word: '愛',
    reading: 'あい',
    initialSubGroupLabel: 'あ',
    postedDefinitionCount: 2,
  );

  @override
  Future<WordListState> fetchCommunityWordList({
    required CommunityWordFilter filter,
    required String query,
    required String? cursor,
  }) async {
    calls.add((filter: filter, query: query, cursor: cursor));
    if (error case final error?) {
      throw error;
    }
    return WordListState(
      list: cursor == null
          ? const [first]
          : const [
              Word(
                id: 'word-2',
                word: '家',
                reading: 'いえ',
                initialSubGroupLabel: 'い',
                postedDefinitionCount: 0,
              ),
            ],
      nextCursor: cursor == null ? 'next' : null,
      hasMore: cursor == null,
    );
  }

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

void main() {
  testWidgets('読み見出し付きの連続一覧を表示する', (tester) async {
    final repository = _FetchWordListRepositoryStub();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fetchWordListRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: DictionaryEveryonePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('あ'), findsOneWidget);
    expect(find.text('愛'), findsOneWidget);
    expect(find.text('2定義'), findsOneWidget);
  });

  testWidgets('画面内検索は入力停止から300 ms後に適用する', (tester) async {
    final repository = _FetchWordListRepositoryStub();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fetchWordListRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: DictionaryEveryonePage()),
      ),
    );
    await tester.pumpAndSettle();
    repository.calls.clear();

    await tester.enterText(find.byType(TextField), 'よは');
    await tester.pump(const Duration(milliseconds: 299));
    expect(repository.calls, isEmpty);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(repository.calls.single.query, 'よは');
  });

  testWidgets('filter変更は cursor を捨てて先頭から取得する', (tester) async {
    final repository = _FetchWordListRepositoryStub();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fetchWordListRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: DictionaryEveryonePage()),
      ),
    );
    await tester.pumpAndSettle();
    repository.calls.clear();

    await tester.tap(find.text('定義あり'));
    await tester.pumpAndSettle();

    expect(repository.calls.single.filter, CommunityWordFilter.defined);
    expect(repository.calls.single.cursor, isNull);
  });

  test('paginationは nextCursor の結果を既存一覧に連結する', () async {
    final repository = _FetchWordListRepositoryStub();
    final container = ProviderContainer(
      overrides: [
        fetchWordListRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    final provider = communityWordListProvider(CommunityWordFilter.all, '');

    await container.read(provider.future);
    await container.read(provider.notifier).fetchMore();

    final result = container.read(provider).requireValue;
    expect(result.list.map((word) => word.id), ['word-1', 'word-2']);
    expect(repository.calls.last.cursor, 'next');
  });

  testWidgets('error 状態はヘッダー操作を残して一覧領域に表示する', (tester) async {
    final repository = _FetchWordListRepositoryStub()
      ..error = Exception('network error');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fetchWordListRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: DictionaryEveryonePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('言葉を登録'), findsOneWidget);
    expect(find.text('再読み込み'), findsOneWidget);
  });
}
