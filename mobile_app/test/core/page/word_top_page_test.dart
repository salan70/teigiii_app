import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/word_top_page.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition_list/application/definition_list_state.dart';
import 'package:teigi_app/feature/definition_list/domain/definition_list_state.dart';
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart';
import 'package:teigi_app/feature/word/application/word_state.dart';
import 'package:teigi_app/feature/word/domain/word.dart';
import 'package:teigi_app/util/constant/initial_main_group.dart';

class _EmptyDefinitionList extends DefinitionListStateNotifier {
  @override
  FutureOr<DefinitionListState> build(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
    InitialSubGroup? initialSubGroup,
  }) async {
    return const DefinitionListState(
      list: [],
      nextCursor: null,
      hasMore: false,
    );
  }
}

Future<void> _pumpWordTop(WidgetTester tester, {required Word? word}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userIdProvider.overrideWithValue('user-1'),
        wordProvider('word-1').overrideWith((ref) async => word),
        definitionListStateNotifierProvider(
          DefinitionFeedType.wordTopOrderByCreatedAt,
          wordId: 'word-1',
        ).overrideWith(_EmptyDefinitionList.new),
        definitionListStateNotifierProvider(
          DefinitionFeedType.wordTopOrderByLikesCount,
          wordId: 'word-1',
        ).overrideWith(_EmptyDefinitionList.new),
      ],
      child: const MaterialApp(home: WordTopPage(wordId: 'word-1')),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('投稿0件でも言葉ヘッダーとタブを表示し、タブ下にエンプティを出す', (tester) async {
    await _pumpWordTop(
      tester,
      word: const Word(
        id: 'word-1',
        word: '自由',
        reading: 'じゆう',
        initialSubGroupLabel: 'さ行',
        postedDefinitionCount: 0,
      ),
    );

    expect(find.text('自由'), findsWidgets);
    expect(find.text('じゆう'), findsOneWidget);
    expect(find.text('0投稿'), findsOneWidget);
    expect(find.text('この言葉を定義する'), findsOneWidget);
    expect(find.text('投稿順'), findsOneWidget);
    expect(find.text('いいね数順'), findsOneWidget);
    expect(find.text('最初に定義してみませんか？'), findsOneWidget);
    expect(find.text('対象の言葉が見つかりませんでした。'), findsNothing);
  });

  testWidgets('言葉が存在しない場合は見つからない表示をする', (tester) async {
    await _pumpWordTop(tester, word: null);

    expect(find.text('対象の言葉が見つかりませんでした。'), findsOneWidget);
    expect(find.text('投稿順'), findsNothing);
  });
}
