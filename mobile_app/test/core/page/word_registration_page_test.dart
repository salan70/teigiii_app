import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/word_registration_page.dart';
import 'package:teigi_app/feature/community_dictionary/domain/community_dictionary.dart';
import 'package:teigi_app/feature/word/domain/word.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';
import 'package:teigi_app/feature/word_list/domain/word_list_state.dart';
import 'package:teigi_app/feature/word_list/repository/fetch_word_list_repository.dart';

class _FetchWordListRepositoryStub implements FetchWordListRepository {
  _FetchWordListRepositoryStub({this.words = const []});

  final List<Word> words;

  @override
  Future<WordListState> fetchCommunityWordList({
    required CommunityWordFilter filter,
    required String query,
    required String? cursor,
  }) async => WordListState(list: words, nextCursor: null, hasMore: false);

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

class _WordRepositoryStub implements WordRepository {
  @override
  Future<Word> create({required String word, required String reading}) async =>
      Word(
        id: 'word-1',
        word: word,
        reading: reading,
        initialSubGroupLabel: 'よ',
        postedDefinitionCount: 0,
      );

  @override
  Future<Word?> fetchWordById(String wordId) => throw UnimplementedError();

  @override
  Future<void> save(String wordId) => throw UnimplementedError();

  @override
  Future<void> unsave(String wordId) => throw UnimplementedError();

  @override
  Future<Word> update({
    required String wordId,
    required String word,
    required String reading,
  }) => throw UnimplementedError();
}

void main() {
  testWidgets('表記の入力中に既存語の候補を表示する', (tester) async {
    final candidateRepository = _FetchWordListRepositoryStub(
      words: const [
        Word(
          id: 'existing',
          word: '余白',
          reading: 'よはく',
          initialSubGroupLabel: 'よ',
          postedDefinitionCount: 1,
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fetchWordListRepositoryProvider.overrideWithValue(
            candidateRepository,
          ),
        ],
        child: const MaterialApp(home: WordRegistrationPage()),
      ),
    );

    await tester.enterText(find.widgetWithText(TextField, '表記'), '余白');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('既存の候補'), findsOneWidget);
    expect(find.widgetWithText(ListTile, '余白'), findsOneWidget);
    expect(find.text('よはく'), findsOneWidget);
  });

  testWidgets('言葉登録後は定義作成と完了の二択を表示する', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wordRepositoryProvider.overrideWithValue(_WordRepositoryStub()),
          fetchWordListRepositoryProvider.overrideWithValue(
            _FetchWordListRepositoryStub(),
          ),
        ],
        child: const MaterialApp(home: WordRegistrationPage()),
      ),
    );

    await tester.enterText(find.widgetWithText(TextField, '表記'), '余白');
    await tester.enterText(find.widgetWithText(TextField, 'よみ'), 'よはく');
    await tester.tap(find.widgetWithText(ElevatedButton, '登録'));
    await tester.pumpAndSettle();

    expect(find.text('「余白」を登録しました。'), findsOneWidget);
    expect(find.text('続けて定義を書く'), findsOneWidget);
    expect(find.text('完了'), findsOneWidget);
  });
}
