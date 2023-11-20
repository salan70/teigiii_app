import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/extension/string_extension.dart';

void main() {
  group('katakanaToHiragana()', () {
    test('全てのカタカナ', () {
      // * Arrange
      var allKatakana = 'アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン';
      // 濁音、半濁音
      allKatakana += 'ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ';
      // 小書き, ヴ
      allKatakana += 'ァィゥェォッャュョヴ';
      // 特殊
      allKatakana += 'ヷヸヹヺ';

      var allHiragana = 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん';
      allHiragana += 'がぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ';
      allHiragana += 'ぁぃぅぇぉっゃゅょゔ';
      allHiragana += 'わゐゑを';

      final katakanaArray = allKatakana.split('');
      final hiraganaArray = allHiragana.split('');

      for (var i = 0; i < katakanaArray.length; i++) {
        // * Act
        final actual = katakanaArray[i].katakanaToHiragana();

        // * Assert
        final expected = hiraganaArray[i];
        expect(actual, expected);
      }
    });

    test('2文字以上', () {
      // * Arrange
      const hiragana = 'サケ';

      // * Act & Assert
      expect(
        () => hiragana.katakanaToHiragana(),
        throwsFormatException,
      );
    });

    test('空文字', () {
      // * Arrange
      const hiragana = '';

      // * Act & Assert
      expect(
        () => hiragana.katakanaToHiragana(),
        throwsFormatException,
      );
    });

    test('スペース', () {
      // * Arrange
      const hiragana = ' ';

      // * Act & Assert
      expect(
        () => hiragana.katakanaToHiragana(),
        throwsArgumentError,
      );
    });

    test('ひらがな', () {
      // * Arrange
      const hiragana = 'あ';

      // * Act & Assert
      expect(
        () => hiragana.katakanaToHiragana(),
        throwsArgumentError,
      );
    });

    test('数字', () {
      // * Arrange
      const hiragana = '1';

      // * Act & Assert
      expect(
        () => hiragana.katakanaToHiragana(),
        throwsArgumentError,
      );
    });

    test('半角カタカナ', () {
      // * Arrange
      const hiragana = 'ｱ';

      // * Act & Assert
      expect(
        () => hiragana.katakanaToHiragana(),
        throwsArgumentError,
      );
    });
  });

  group('trimEnd()', () {
    test('末尾の空白を削除する', () {
      // * Act & Assert
      expect('Hello World   '.trimEnd(), 'Hello World');
      expect('Some text\n\n'.trimEnd(), 'Some text');
      expect('  A  '.trimEnd(), '  A');
      expect('NoWhitespace'.trimEnd(), 'NoWhitespace');
    });

    test('先頭の空白はそのままにする', () {
      // * Act & Assert
      expect('  Hello World'.trimEnd(), '  Hello World');
    });

    test('空文字列の場合は空文字列のままにする', () {
      // * Act & Assert
      expect(''.trimEnd(), '');
    });

    test('文字列に空白がない場合はそのままにする', () {
      // * Act & Assert
      expect('HelloWorld'.trimEnd(), 'HelloWorld');
    });
  });
}
