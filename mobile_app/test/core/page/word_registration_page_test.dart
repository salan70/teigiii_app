import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:teigi_app/core/page/word_registration_page.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';

/// 既存語チェックの結果だけを差し替えるリポジトリ。
class _FakeWordRepository implements WordRepository {
  _FakeWordRepository({this.existingWordId, this.completer});

  /// [findPublicWordId] が返す言葉の ID。
  final String? existingWordId;

  /// 完了をテスト側で制御したい場合に渡す。
  final Completer<void>? completer;

  @override
  Future<String?> findPublicWordId({
    required String word,
    required String reading,
  }) async {
    if (completer != null) {
      await completer!.future;
    }
    return existingWordId;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  Future<void> pumpPage(
    WidgetTester tester, {
    String? initialWord,
    String? existingWordId,
    Completer<void>? completer,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wordRepositoryProvider.overrideWithValue(
            _FakeWordRepository(
              existingWordId: existingWordId,
              completer: completer,
            ),
          ),
        ],
        child: MaterialApp(
          home: WordRegistrationPage(initialWord: initialWord),
        ),
      ),
    );
  }

  /// チップの表示状態。非表示でも領域は確保されるため [Visibility] を見る。
  Visibility chipVisibility(WidgetTester tester) => tester.widget<Visibility>(
    find.ancestor(of: find.byType(DsChip), matching: find.byType(Visibility)),
  );

  /// 表記とよみを入力し、既存語チェックが走るまで待つ。
  Future<void> enterWordAndReading(WidgetTester tester) async {
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.first, '余白');
    await tester.enterText(fields.last, 'よはく');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
  }

  VoidCallback? registerButtonCallback(WidgetTester tester) =>
      tester.widget<DsAppBarAction>(find.byType(DsAppBarAction)).onPressed;

  testWidgets('initialWord があるとき表記欄にプリフィルする', (tester) async {
    await pumpPage(tester, initialWord: '余白');

    expect(find.text('余白'), findsOneWidget);
  });

  testWidgets('initialWord が無いとき表記欄は空', (tester) async {
    await pumpPage(tester);

    final field = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(field.controller?.text ?? field.initialValue ?? '', isEmpty);
  });

  testWidgets('定義追加画面と同じ見た目の骨格を持つ', (tester) async {
    await pumpPage(tester);

    // × で閉じる
    expect(find.byIcon(CupertinoIcons.xmark), findsOneWidget);

    // AppBar 右の登録アクション（下部 FilledButton ではない）
    expect(find.text('登録'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);

    // 定義追加と同系統のラベル・ボーダーなし
    expect(find.text('登録する言葉'), findsOneWidget);
    expect(find.text('言葉のよみ'), findsOneWidget);
    expect(find.byType(DsTextField), findsNWidgets(2));

    // 完了後ダイアログ用の文言は置かない（トースト＋pop）
    expect(find.text('続けて定義を書く'), findsNothing);
    expect(find.text('完了'), findsNothing);

    final decorators = tester.widgetList<InputDecorator>(
      find.byType(InputDecorator),
    );
    expect(decorators.length, greaterThanOrEqualTo(2));
    for (final decorator in decorators.take(2)) {
      expect(decorator.decoration.border, InputBorder.none);
    }
  });

  testWidgets('公開済みの既存語を検出するとチップを出して登録を止める', (tester) async {
    await pumpPage(tester, existingWordId: 'word-1');

    expect(chipVisibility(tester).visible, isFalse);

    await enterWordAndReading(tester);

    expect(chipVisibility(tester).visible, isTrue);
    expect(find.text('この言葉は登録済みです'), findsOneWidget);
    expect(registerButtonCallback(tester), isNull);
  });

  testWidgets('既存語が無ければチップを出さず登録できる', (tester) async {
    await pumpPage(tester);

    await enterWordAndReading(tester);

    expect(chipVisibility(tester).visible, isFalse);
    expect(registerButtonCallback(tester), isNotNull);
  });

  testWidgets('チップの有無で入力欄の位置がずれない', (tester) async {
    await pumpPage(tester, existingWordId: 'word-1');
    final before = tester
        .getTopLeft(find.byType(DsTextField).last)
        .dy;

    await enterWordAndReading(tester);

    expect(chipVisibility(tester).visible, isTrue);
    expect(tester.getTopLeft(find.byType(DsTextField).last).dy, before);
  });

  testWidgets('チップはよみ欄の下に置く', (tester) async {
    await pumpPage(tester, existingWordId: 'word-1');

    await enterWordAndReading(tester);

    final readingBottom = tester
        .getBottomLeft(find.byType(DsTextField).last)
        .dy;
    expect(
      tester.getTopLeft(find.byType(DsChip)).dy,
      greaterThanOrEqualTo(readingBottom),
    );
  });

  testWidgets('既存語チェックが返るまで登録できない', (tester) async {
    final completer = Completer<void>();
    await pumpPage(tester, existingWordId: 'word-1', completer: completer);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.first, '余白');
    await tester.enterText(fields.last, 'よはく');

    // debounce 待ちの間は前の入力の結果しかない
    expect(registerButtonCallback(tester), isNull);

    await tester.pump(const Duration(milliseconds: 500));
    // 問い合わせ中も結果が無いので登録させない
    expect(registerButtonCallback(tester), isNull);

    completer.complete();
    await tester.pump();
    await tester.pump();

    // 既存語が見つかったので、結果が出ても登録は不可のまま
    expect(chipVisibility(tester).visible, isTrue);
    expect(registerButtonCallback(tester), isNull);
  });

  testWidgets('既存語チェックが返り、該当なしなら登録できる', (tester) async {
    final completer = Completer<void>();
    await pumpPage(tester, completer: completer);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.first, '余白');
    await tester.enterText(fields.last, 'よはく');
    await tester.pump(const Duration(milliseconds: 500));

    expect(registerButtonCallback(tester), isNull);

    completer.complete();
    await tester.pump();
    await tester.pump();

    expect(registerButtonCallback(tester), isNotNull);
  });
}
