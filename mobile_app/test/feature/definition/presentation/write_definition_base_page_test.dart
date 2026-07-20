import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/definition/domain/definition_for_write.dart';
import 'package:teigi_app/feature/definition/presentation/write_definition_base_page.dart';

void main() {
  Future<void> pumpPage(
    WidgetTester tester,
    DefinitionForWrite definitionForWrite,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: WriteDefinitionBasePage(
            definitionForWrite: definitionForWrite,
            onWordChanged: (_) {},
            onWordReadingChanged: (_) {},
            onPublicChanged: (_) {},
            onDefinitionChanged: (_) {},
            isChanged: false,
            appBarActionWidget: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  const baseDefinition = DefinitionForWrite(
    id: null,
    authorId: 'user1',
    word: '二日目のカレー',
    wordReading: 'ふつかめのかれー',
    isPublic: true,
    definition: '作ってから一晩経ったカレー。',
  );

  testWidgets('新規投稿では言葉・よみを編集できる', (tester) async {
    await pumpPage(tester, baseDefinition);

    final fields = tester.widgetList<EditableText>(find.byType(EditableText));

    expect(fields.elementAt(0).readOnly, isFalse);
    expect(fields.elementAt(1).readOnly, isFalse);
    expect(fields.elementAt(2).readOnly, isFalse);
  });

  testWidgets('既存定義の編集では言葉・よみだけ読み取り専用になる', (tester) async {
    await pumpPage(tester, baseDefinition.copyWith(id: 'definition1'));

    final fields = tester.widgetList<EditableText>(find.byType(EditableText));

    expect(fields.elementAt(0).readOnly, isTrue);
    expect(fields.elementAt(1).readOnly, isTrue);
    expect(fields.elementAt(2).readOnly, isFalse);
  });
}
