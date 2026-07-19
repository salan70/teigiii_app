import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/definition/domain/definition_for_write.dart';

void main() {
  const baseDefinitionForWrite = DefinitionForWrite(
    id: '1',
    authorId: 'userId',
    word: 'word',
    wordReading: 'wordReading',
    isPublic: true,
    definition: 'definition',
  );

  const leadingSpaceErrorText = '先頭にはスペース等を使用できません';

  group('outputWordError()', () {
    test('空', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(word: '');

      // * Act
      final actual = definition.outputWordError();

      // * Assert
      expect(actual, isNull);
    });

    test('漢数字 + 漢字 + ひらがな + カタカナ', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(word: '二日目のカレー');

      // * Act
      final actual = definition.outputWordError();

      // * Assert
      expect(actual, isNull);
    });

    test('途中にスペース', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(word: '二日目の カレー');

      // * Act
      final actual = definition.outputWordError();

      // * Assert
      expect(actual, isNull);
    });

    test('最大文字を超えている', () {
      // * Arrange
      final word = 'あ' * (baseDefinitionForWrite.maxWordLength + 1);
      final definition = baseDefinitionForWrite.copyWith(word: word);

      // * Act
      final actual = definition.outputWordError();

      // * Assert
      expect(
        actual,
        '${baseDefinitionForWrite.maxWordLength}文字以内で入力してください',
      );
    });

    test('スペースのみ（先頭がスペース）', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(word: ' ');

      // * Act
      final actual = definition.outputWordError();

      // * Assert
      expect(actual, leadingSpaceErrorText);
    });

    test('改行のみ（先頭が改行）', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(word: '\n');

      // * Act
      final actual = definition.outputWordError();

      // * Assert
      expect(actual, leadingSpaceErrorText);
    });
  });

  group('outputWordReadingError', () {
    test('空', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(wordReading: '');

      // * Act
      final actual = definition.outputWordReadingError();

      // * Assert
      expect(actual, isNull);
    });

    test('ひらがな + カタカナ + アラビア数字 + 大文字アルファベット + 小文字アルファベット + ?', () {
      // * Arrange
      final definition =
          baseDefinitionForWrite.copyWith(wordReading: 'ひらがなカタカナ0Aa?');

      // * Act
      final actual = definition.outputWordReadingError();

      // * Assert
      expect(actual, isNull);
    });

    test('途中にスペース', () {
      // * Arrange
      final definition =
          baseDefinitionForWrite.copyWith(wordReading: 'ふつかめの かれー');

      // * Act
      final actual = definition.outputWordReadingError();

      // * Assert
      expect(actual, isNull);
    });

    test('漢字が含まれている', () {
      // * Arrange
      final definition =
          baseDefinitionForWrite.copyWith(wordReading: '二日目の かれー');

      // * Act
      final actual = definition.outputWordReadingError();

      // * Assert
      expect(actual, '漢字は使用できません');
    });

    test('最大文字を超えている', () {
      // * Arrange
      final wordReading =
          'あ' * (baseDefinitionForWrite.maxWordReadingLength + 1);
      final definition =
          baseDefinitionForWrite.copyWith(wordReading: wordReading);

      // * Act
      final actual = definition.outputWordReadingError();

      // * Assert
      expect(
        actual,
        '${baseDefinitionForWrite.maxWordReadingLength}文字以内で入力してください',
      );
    });

    test('無効な記号が含まれている', () {
      // * Arrange
      final definition =
          baseDefinitionForWrite.copyWith(wordReading: 'ふつかめの かれー💓');

      // * Act
      final actual = definition.outputWordReadingError();

      // * Assert
      expect(actual, '無効な文字が含まれています');
    });

    test('スペースのみ（先頭がスペース）', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(wordReading: ' ');

      // * Act
      final actual = definition.outputWordReadingError();

      // * Assert
      expect(actual, leadingSpaceErrorText);
    });

    test('改行のみ（先頭が改行）', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(wordReading: '\n');

      // * Act
      final actual = definition.outputWordReadingError();

      // * Assert
      expect(actual, leadingSpaceErrorText);
    });
  });

  group('canPost()', () {
    test('全フィールドが有効', () {
      // * Arrange
      // * Act
      final canPost = baseDefinitionForWrite.isValidAllFields();

      // * Assert
      expect(canPost, isTrue);
    });

    test('wordが空', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(word: '');

      // * Act
      final canPost = definition.isValidAllFields();

      // * Assert
      expect(canPost, isFalse);
    });

    test('wordにエラーあり', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(word: ' word');

      // * Act
      final canPost = definition.isValidAllFields();

      // * Assert
      expect(canPost, isFalse);
    });

    test('wordReadingが空', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(wordReading: '');

      // * Act
      final canPost = definition.isValidAllFields();

      // * Assert
      expect(canPost, isFalse);
    });

    test('wordReadingにエラーあり', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(wordReading: '無効文字');

      // * Act
      final canPost = definition.isValidAllFields();

      // * Assert
      expect(canPost, isFalse);
    });

    test('definitionが空', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(definition: '');

      // * Act
      final canPost = definition.isValidAllFields();

      // * Assert
      expect(canPost, isFalse);
    });

    test('definitionが最大文字数を超えている', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(
        definition: 'あ' * (baseDefinitionForWrite.maxDefinitionLength + 1),
      );

      // * Act
      final canPost = definition.isValidAllFields();

      // * Assert
      expect(canPost, isFalse);
    });

    test('全フィールドが無効', () {
      // * Arrange
      final definition = baseDefinitionForWrite.copyWith(
        word: ' word',
        wordReading: '無効文字',
        definition: '',
      );

      // * Act
      final canPost = definition.isValidAllFields();

      // * Assert
      expect(canPost, isFalse);
    });
  });

  group('isEmptyAllFields', () {
    test('すべてのフィールドが空', () {
      // * Arrange
      final definitionForWrite = baseDefinitionForWrite.copyWith(
        word: '',
        wordReading: '',
        definition: '',
      );

      // * Act
      final actual = definitionForWrite.isEmptyAllFields;

      // * Assert
      expect(actual, isTrue);
    });

    test('wordが空でない', () {
      // * Arrange
      final definitionForWrite = baseDefinitionForWrite.copyWith(
        word: 'タコライス',
        wordReading: '',
        definition: '',
      );

      // * Act
      final actual = definitionForWrite.isEmptyAllFields;

      // * Assert
      expect(actual, isFalse);
    });

    test('wordReadingが空でない', () {
      // * Arrange
      final definitionForWrite = baseDefinitionForWrite.copyWith(
        word: '',
        wordReading: 'たこらいす',
        definition: '',
      );

      // * Act
      final actual = definitionForWrite.isEmptyAllFields;

      // * Assert
      expect(actual, isFalse);
    });

    test('definitionが空でない', () {
      // * Arrange
      final definitionForWrite = baseDefinitionForWrite.copyWith(
        word: '',
        wordReading: '',
        definition: '沖縄の名物料理',
      );

      // * Act
      final actual = definitionForWrite.isEmptyAllFields;

      // * Assert
      expect(actual, isFalse);
    });

    test('複数のフィールドが空でない場合はfalseを返す', () {
      // * Arrange
      final definitionForWrite = baseDefinitionForWrite.copyWith(
        word: 'タコライス',
        wordReading: 'たこらいす',
        definition: '',
      );

      // * Act
      final actual = definitionForWrite.isEmptyAllFields;

      // * Assert
      expect(actual, isFalse);
    });
  });
}
