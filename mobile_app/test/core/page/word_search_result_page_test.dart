import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/word_search_result_page.dart';
import 'package:teigi_app/feature/word_list/application/word_list_state_by_search_word.dart';
import 'package:teigi_app/feature/word_list/domain/word_list_state.dart';

class _EmptySearchResult extends WordListStateBySearchWordNotifier {
  @override
  FutureOr<WordListState> build(String searchWord) async {
    return const WordListState(list: [], nextCursor: null, hasMore: false);
  }
}

void main() {
  testWidgets('検索ゼロ件のとき検索語プリフィル付き登録 CTA を出す', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wordListStateBySearchWordNotifierProvider(
            'よはく',
          ).overrideWith(_EmptySearchResult.new),
        ],
        child: const MaterialApp(home: WordSearchResultPage(searchWord: 'よはく')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('「よはく」を登録'), findsOneWidget);
  });
}
