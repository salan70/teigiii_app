import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/dictionary_individual_page.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/personal_dictionary/application/personal_dictionary_state.dart';
import 'package:teigi_app/feature/personal_dictionary/domain/personal_dictionary.dart';

void main() {
  Future<void> pumpOverview(
    WidgetTester tester,
    PersonalDictionaryOverview overview,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userIdProvider.overrideWithValue(null),
          personalDictionaryOverviewProvider.overrideWith(
            (ref) async => overview,
          ),
        ],
        child: const MaterialApp(
          home: DictionaryIndividualPage(
            targetUserId: 'user-id',
            isTopRoute: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('overview 取得中は loading を表示する', (tester) async {
    final completer = Completer<PersonalDictionaryOverview>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userIdProvider.overrideWithValue(null),
          personalDictionaryOverviewProvider.overrideWith(
            (ref) => completer.future,
          ),
        ],
        child: const MaterialApp(
          home: DictionaryIndividualPage(
            targetUserId: 'user-id',
            isTopRoute: true,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
  });

  testWidgets('空のあなたの辞書は検索を要求せず最初の定義作成へ導く', (tester) async {
    await pumpOverview(tester, const PersonalDictionaryOverview.empty());

    expect(find.text('あなたの辞書'), findsOneWidget);
    expect(find.text('最初の定義を書く'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('data 状態は3件数と最近の定義見出しを表示する', (tester) async {
    await pumpOverview(
      tester,
      const PersonalDictionaryOverview(
        definedWordCount: 2,
        draftCount: 3,
        savedWordCount: 4,
        recentDefinitions: [],
      ),
    );

    expect(find.text('定義済みの言葉'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('下書き'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('保存した言葉'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('最近更新した定義'), findsOneWidget);
    expect(find.text('定義を書く'), findsOneWidget);
  });

  testWidgets('overview 取得失敗時は再読み込みを表示する', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userIdProvider.overrideWithValue(null),
          personalDictionaryOverviewProvider.overrideWith(
            (ref) async => throw Exception('network error'),
          ),
        ],
        child: const MaterialApp(
          home: DictionaryIndividualPage(
            targetUserId: 'user-id',
            isTopRoute: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('エラーが発生しました。'), findsOneWidget);
    expect(find.text('再読み込み'), findsOneWidget);
  });
}
