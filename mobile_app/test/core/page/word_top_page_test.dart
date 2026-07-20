import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/word_top_page.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition_list/domain/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition_list/repository/definition_id_list_repository.dart';
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart';
import 'package:teigi_app/feature/word/application/word_state.dart';
import 'package:teigi_app/feature/word/domain/word.dart';

class _DefinitionIdListRepositoryStub implements DefinitionIdListRepository {
  static const empty = DefinitionIdListState(
    list: [],
    nextCursor: null,
    hasMore: false,
  );

  @override
  Future<DefinitionIdListState> fetchForWordMine(
    String wordId,
    String? cursor,
  ) async => empty;

  @override
  Future<DefinitionIdListState> fetchForWordOthers(
    WordTopOrderByType orderByType,
    String wordId,
    String? cursor,
  ) async => empty;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _testApp({bool isSaved = false, bool isEditable = true}) {
  final repository = _DefinitionIdListRepositoryStub();

  return ProviderScope(
    overrides: [
      userIdProvider.overrideWithValue('current-user'),
      wordProvider('word-1').overrideWith(
        (ref) async => Word(
          id: 'word-1',
          word: '自由',
          reading: 'じゆう',
          initialSubGroupLabel: 'さ行',
          postedDefinitionCount: 0,
          isSavedByMe: isSaved,
          isEditableByMe: isEditable,
        ),
      ),
      definitionIdListRepositoryProvider.overrideWithValue(repository),
    ],
    child: const MaterialApp(home: WordTopPage(wordId: 'word-1')),
  );
}

void main() {
  testWidgets('言葉ページは自分と他者の定義を分離して表示する', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump();

    expect(find.text('自由'), findsWidgets);
    expect(find.text('じゆう'), findsOneWidget);
    expect(find.text('この言葉を定義する'), findsOneWidget);
    expect(find.byKey(const Key('word-save-button')), findsOneWidget);
    expect(find.text('あなたの定義'), findsOneWidget);
    expect(find.text('みんなの定義'), findsOneWidget);
    expect(find.text('まだ定義がありません'), findsOneWidget);
    expect(find.text('新着順'), findsOneWidget);
    expect(find.text('リアクション順'), findsOneWidget);
  });

  testWidgets('保存済みの言葉は保存解除として表示する', (tester) async {
    await tester.pumpWidget(_testApp(isSaved: true));
    await tester.pump();
    await tester.pump();

    expect(find.byTooltip('保存を解除'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
  });

  testWidgets('修正可能な場合は言葉の修正メニューを表示する', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byKey(const Key('word-actions-button')));
    await tester.pumpAndSettle();
    expect(find.text('言葉を修正'), findsOneWidget);
    expect(find.text('通報'), findsOneWidget);
  });

  testWidgets('修正不可の場合は修正提案メニューを表示する', (tester) async {
    await tester.pumpWidget(_testApp(isEditable: false));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.byKey(const Key('word-actions-button')));
    await tester.pumpAndSettle();
    expect(find.text('言葉を修正'), findsNothing);
    expect(find.text('修正を提案'), findsOneWidget);
    expect(find.text('通報'), findsOneWidget);
  });
}
