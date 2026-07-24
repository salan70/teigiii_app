import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/word_list/application/personal_dictionary_word_navigation.dart';

void main() {
  group('personalDictionaryWordNavKind', () {
    test('投稿数0は遷移しない', () {
      expect(
        personalDictionaryWordNavKind(0),
        PersonalDictionaryWordNavKind.none,
      );
    });

    test('投稿数1は定義詳細へ', () {
      expect(
        personalDictionaryWordNavKind(1),
        PersonalDictionaryWordNavKind.detail,
      );
    });

    test('投稿数2以上は定義一覧へ', () {
      expect(
        personalDictionaryWordNavKind(2),
        PersonalDictionaryWordNavKind.list,
      );
      expect(
        personalDictionaryWordNavKind(5),
        PersonalDictionaryWordNavKind.list,
      );
    });
  });
}
