import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/word/domain/word.dart';
import 'package:teigi_app/feature/word_list/application/community_dictionary_index_list_state.dart';

Word _word({
  required String id,
  required String word,
  required String reading,
}) {
  return Word(
    id: id,
    word: word,
    reading: reading,
    initialSubGroupLabel: reading.isEmpty ? 'その他' : reading.substring(0, 1),
    postedDefinitionCount: 1,
  );
}

void main() {
  group('buildIndexedList', () {
    test('五十音 → A-Z → 数字・記号の順にセクションを並べる', () {
      final list = buildIndexedList([
        _word(id: '1', word: 'Apple', reading: 'Apple'),
        _word(id: '2', word: 'あんこ', reading: 'あんこ'),
        _word(id: '3', word: '123', reading: '123'),
        _word(id: '4', word: 'かき', reading: 'かき'),
      ]);

      expect(
        list
            .map((item) => item is String ? item : (item as Word).word)
            .toList(),
        ['あ', 'あんこ', 'か', 'かき', 'A-Z', 'Apple', '数字・記号', '123'],
      );
    });
  });
}
