import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/constant/initial_main_group.dart';

void main() {
  group('labelFromString()', () {
    test('全てのひらがな', () {
      // * Arrange
      var allHiragana =
          'あいうえお かきくけこ さしすせそ たちつてと なにぬねの はひふへほ まみむめも やゆよ らりるれろ わをん';
      // 濁音、半濁音
      allHiragana += 'がぎぐげご ざじずぜぞ だぢづでど ばびぶべぼ ぱぴぷぺぽ';
      // 小書き, ヴ
      allHiragana += 'ぁぃぅぇぉ っ ゃゅょ ゔ';
      // 特殊
      allHiragana += 'わゐゑを';

      var allExpected =
          'あいうえお かきくけこ さしすせそ たちつてと なにぬねの はひふへほ まみむめも やゆよ らりるれろ わをん';
      // 濁音、半濁音（清音になる）
      allExpected += 'かきくけこ さしすせそ たちつてと はひふへほ はひふへほ';
      // 小書き, ヴ（清音になる）
      allExpected += 'あいうえお つ やゆよ う';
      // 特殊（清音になる）
      allExpected += 'わいえを';

      final hiraganaList = allHiragana.replaceAll(RegExp(r'\s+'), '').split('');
      final expectedList = allExpected.replaceAll(RegExp(r'\s+'), '').split('');

      for (var i = 0; i < hiraganaList.length; i++) {
        // * Act
        final actual = InitialSubGroup.fromString(hiraganaList[i]).label;

        // * Assert
        final expected = expectedList[i];
        expect(actual, expected);
      }
    });

    test('全てのカタカナ', () {
      // * Arrange
      var allKatakana =
          'アイウエオ カキクケコ サシスセソ タチツテト ナニヌネノ ハヒフヘホ マミムメモ ヤユヨ ラリルレロ ワヲン';
      // 濁音、半濁音
      allKatakana += 'ガギグゲゴ ザジズゼゾ ダヂヅデド バビブベボ パピプペポ';
      // 小書き, ヴ
      allKatakana += 'ァィゥェォ ッ ャュョ ヴ';
      // 特殊
      allKatakana += 'ヷヸヹヺ';

      var allExpected =
          'あいうえお かきくけこ さしすせそ たちつてと なにぬねの はひふへほ まみむめも やゆよ らりるれろ わをん';
      // 濁音、半濁音（清音になる）
      allExpected += 'かきくけこ さしすせそ たちつてと はひふへほ はひふへほ';
      // 小書き, ヴ（清音になる）
      allExpected += 'あいうえお つ やゆよ う';
      // 特殊（清音になる）
      allExpected += 'わいえを';

      final katakanaList = allKatakana.replaceAll(RegExp(r'\s+'), '').split('');
      final expectedList = allExpected.replaceAll(RegExp(r'\s+'), '').split('');

      for (var i = 0; i < katakanaList.length; i++) {
        // * Act
        final actual = InitialSubGroup.fromString(katakanaList[i]).label;

        // * Assert
        final expected = expectedList[i];
        expect(actual, expected);
      }
    });

    test('全てのアルファベット', () {
      // * Arrange
      var allAlphabet = 'abcdefghijklmnopqrstuvwxyz';
      allAlphabet += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

      var allExpected = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      allExpected += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

      final alphabetList = allAlphabet.split('');
      final expectedList = allExpected.split('');

      for (var i = 0; i < alphabetList.length; i++) {
        // * Act
        final actual = InitialSubGroup.fromString(alphabetList[i]).label;

        // * Assert
        final expected = expectedList[i];
        expect(actual, expected);
      }
    });

    test('全ての数字', () {
      // * Arrange
      const allNumber = '0123456789';
      final numberList = allNumber.split('');

      for (var i = 0; i < numberList.length; i++) {
        // * Act
        final actual = InitialSubGroup.fromString(numberList[i]).label;

        // * Assert
        expect(actual, InitialSubGroup.number.label);
      }
    });

    test('[basicSymbolRegex]にマッチする記号', () {
      // * Arrange
      const allSymbol = '!#\$%&()*+,-./:;<=>?@[]^_`{|}~（）「」『』ー';
      final symbolList = allSymbol.split('');

      for (var i = 0; i < symbolList.length; i++) {
        // * Act
        final actual = InitialSubGroup.fromString(symbolList[i]).label;

        // * Assert
        expect(actual, InitialSubGroup.basicSymbol.label);
      }
    });

    test('その他', () {
      // * Arrange
      const allOther = ' ｡｢｣､･ｰ２Ａｱ😆';
      final otherList = allOther.split('');

      for (var i = 0; i < otherList.length; i++) {
        // * Act
        final actual = InitialSubGroup.fromString(otherList[i]).label;

        // * Assert
        expect(actual, InitialSubGroup.other.label);
      }
    });

    test('2文字', () {
      // * Arrange & Act
      final actual = InitialSubGroup.fromString('とり').label;

      // * Assert
      expect(actual, InitialSubGroup.to.label);
    });

    test('空文字', () {
      // * Arrange & Act
      final actual = InitialSubGroup.fromString('').label;

      // * Assert
      expect(actual, InitialSubGroup.other.label);
    });
  });
}
