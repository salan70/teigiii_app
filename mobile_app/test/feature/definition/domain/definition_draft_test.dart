import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/definition/domain/definition_draft.dart';

void main() {
  const empty = DefinitionDraft(
    id: 'draft-id',
    wordId: null,
    word: '',
    wordReading: '',
    isPublic: true,
    definition: '',
    isPersisted: false,
  );

  test('言葉・よみ・本文のどれか一つでも入力されていれば保存対象になる', () {
    expect(empty.hasAnyInput, isFalse);
    expect(empty.copyWith(word: '言葉').hasAnyInput, isTrue);
    expect(empty.copyWith(wordReading: 'ことば').hasAnyInput, isTrue);
    expect(empty.copyWith(definition: '本文').hasAnyInput, isTrue);
  });

  test('投稿には言葉・よみ・本文の全項目が有効である必要がある', () {
    expect(empty.canFinalize, isFalse);
    expect(
      empty
          .copyWith(word: '言葉', wordReading: 'ことば', definition: '本文')
          .canFinalize,
      isTrue,
    );
  });
}
