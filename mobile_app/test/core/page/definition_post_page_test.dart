import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/page/definition_post_page.dart';
import 'package:teigi_app/feature/definition/application/definition_draft_editor.dart';
import 'package:teigi_app/feature/definition/domain/definition_draft.dart';
import 'package:teigi_app/feature/definition/repository/definition_draft_repository.dart';
import 'package:teigi_app/feature/definition/util/after_post_navigation_type.dart';
import 'package:teigi_app/feature/introduction/repository/definition_guide_repository.dart';

import '../../feature/definition/application/definition_draft_editor_test.mocks.dart';

void main() {
  final repository = MockDefinitionDraftRepository();
  final guideRepository = _DefinitionGuideRepositoryStub();

  Future<void> pumpPage(WidgetTester tester, {String? draftId}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          definitionDraftIdProvider.overrideWithValue(
            '00000000-0000-4000-8000-000000000001',
          ),
          definitionDraftRepositoryProvider.overrideWithValue(repository),
          definitionGuideRepositoryProvider.overrideWithValue(guideRepository),
        ],
        child: MaterialApp(
          home: DefinitionPostPage(
            draftId: draftId,
            initialDefinitionForWrite: null,
            autoFocusForm: null,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    reset(repository);
    guideRepository
      ..show = false
      ..marked = false;
  });

  testWidgets('最初の定義作成では公開範囲と下書き保存を説明する', (tester) async {
    guideRepository.show = true;

    await pumpPage(tester);

    expect(find.textContaining('全体に公開／非公開'), findsOneWidget);
    expect(find.textContaining('下書きを保存'), findsWidgets);
    expect(guideRepository.marked, isTrue);
  });

  testWidgets('作成成功後の既定遷移先は定義詳細', (tester) async {
    await pumpPage(tester);

    final page = tester.widget<DefinitionPostPage>(
      find.byType(DefinitionPostPage),
    );
    expect(page.afterPostNavigation, AfterPostNavigationType.toDetail);
  });

  testWidgets('バックグラウンド移行時に一項目だけの Draft を保存する', (tester) async {
    when(repository.save(any)).thenAnswer(
      (invocation) async =>
          (invocation.positionalArguments.single as DefinitionDraft).copyWith(
            isPersisted: true,
          ),
    );
    await pumpPage(tester);
    await tester.enterText(find.byType(TextFormField).at(2), '本文だけ');

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pumpAndSettle();

    final saved =
        verify(repository.save(captureAny)).captured.single as DefinitionDraft;
    expect(saved.definition, '本文だけ');
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  });

  testWidgets('バックグラウンド保存失敗は復帰時に再試行を提示する', (tester) async {
    when(repository.save(any)).thenThrow(Exception('network error'));
    await pumpPage(tester);
    await tester.enterText(find.byType(TextFormField).at(0), '言葉');

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pumpAndSettle();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(find.text('下書きを保存できませんでした。'), findsOneWidget);
    expect(find.text('再試行'), findsOneWidget);
  });

  testWidgets('離脱時の保存失敗は画面を維持して選択肢を提示する', (tester) async {
    when(repository.save(any)).thenThrow(Exception('network error'));
    await pumpPage(tester);
    await tester.enterText(find.byType(TextFormField).at(0), '言葉');

    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(DefinitionPostPage), findsOneWidget);
    expect(find.text('下書きを保存できませんでした。'), findsOneWidget);
    expect(find.text('編集に戻る'), findsOneWidget);
    expect(find.text('変更を破棄'), findsOneWidget);
    expect(find.text('再試行'), findsOneWidget);
  });

  testWidgets('既存 Draft を空にして離脱すると削除確認を表示する', (tester) async {
    const draftId = '00000000-0000-4000-8000-000000000002';
    when(repository.get(draftId)).thenAnswer(
      (_) async => const DefinitionDraft(
        id: draftId,
        wordId: null,
        word: '言葉',
        wordReading: '',
        isPublic: true,
        definition: '',
        isPersisted: true,
      ),
    );
    await pumpPage(tester, draftId: draftId);
    await tester.enterText(find.byType(TextFormField).at(0), '');

    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();

    expect(find.text('空になった下書きを削除しますか？'), findsOneWidget);
    expect(find.text('キャンセル'), findsOneWidget);
    expect(find.text('削除'), findsOneWidget);
  });
}

class _DefinitionGuideRepositoryStub implements DefinitionGuideRepository {
  bool show = false;
  bool marked = false;

  @override
  Future<bool> shouldShow() async => show;

  @override
  Future<void> markAsShown() async => marked = true;
}
