import 'package:freezed_annotation/freezed_annotation.dart';

part 'definition_for_write.freezed.dart';

/// Definitionの新規投稿・更新時に使用するオブジェクト
@freezed
class DefinitionForWrite with _$DefinitionForWrite {
  const factory DefinitionForWrite({
    /// 更新時のみ使用する。新規投稿時はnull
    required String? id,
    required String word,
    required String wordReading,
    required bool isPublic,
    required String definition,
  }) = _DefinitionForWrite;
  const DefinitionForWrite._();

  String get _leadingSpaceErrorText => '先頭にはスペース等を使用できません';

  String? outputWordError() {
    if (word.isEmpty) {
      // 未入力の場合はエラーを出さない
      return null;
    }

    // 頭文字が空白文字かどうか
    if (word.trimLeft() != word) {
      return _leadingSpaceErrorText;
    }

    return null;
  }

  String? outputWordReadingError() {
    if (wordReading.isEmpty) {
      // 未入力の場合はエラーを出さない
      return null;
    }

    // 頭文字が空白文字かどうか
    if (wordReading.trimLeft() != wordReading) {
      return _leadingSpaceErrorText;
    }

    // 次の文字種別のみを共用する正規表現
    // スペース、ひらがな、カタカナ、アルファベット（大文字・小文字）、数字、一部記号（'ー'含む）
    final validPattern =
        RegExp(r'^[ ぁ-んァ-ンa-zA-Z0-9!#$%&()*+,\-./:;<=>?@\[\]^_`{|}~\u30FC]+$');
    if (!validPattern.hasMatch(wordReading)) {
      // 漢字が含まれているか確認
      final kanjiPattern = RegExp(r'[\u3400-\u9FBF]');
      if (kanjiPattern.hasMatch(wordReading)) {
        return '漢字は使用できません';
      }

      // 漢字以外に無効な文字が含まれている場合
      return '無効な文字が含まれています';
    }

    return null;
  }

  /// 全てのフィールド（[word], [wordReading], [definition]）が有効かどうか
  bool isValidAllFields() {
    final isValidWord = outputWordError() == null && word.isNotEmpty;
    final isValidWordReading =
        outputWordReadingError() == null && wordReading.isNotEmpty;
    final isValidDefinition = definition.isNotEmpty;

    // TODO(me): 入力数のバリデーションも追加する（output()系に追加するのもあり）

    return isValidWord && isValidWordReading && isValidDefinition;
  }

  Map<String, dynamic> toFirestoreForCreate() {
    return {
      'word': word,
      'wordReading': wordReading,
      'wordReadingInitialGroup': categorizeFirstCharacter(wordReading),
      'definition': definition,
      'likesCount': 0,
      'isPublic': isPublic,
    };
  }

  Map<String, dynamic> toFirestoreForUpdate() {
    return {
      'word': word,
      'wordReading': wordReading,
      'wordReadingInitialGroup': categorizeFirstCharacter(wordReading),
      'definition': definition,
      'isPublic': isPublic,
    };
  }

  // 文字列（Unicode）が絡んでおり繊細な問題であること、
  // データ取得時の絞り込み等で利用するため特に正確に値を保存したいことから、テストを作成する
  @visibleForTesting
  String categorizeFirstCharacter(String text) {
    final firstChar = text.substring(0, 1);

    // ひらがなの場合、そのまま返す
    if (RegExp(r'^[ぁ-ん]').hasMatch(firstChar)) {
      return firstChar;
    }
    // カタカナの場合、ひらがなに変換して返す
    else if (RegExp(r'^[ァ-ヶー]').hasMatch(firstChar)) {
      return _convertToHiragana(firstChar);
    }
    // アルファベットの場合、大文字に変換して返す
    else if (RegExp(r'^[a-zA-Z]').hasMatch(firstChar)) {
      return firstChar.toUpperCase();
    }
    // 数字の場合、「数字」を返す
    else if (RegExp(r'^[0-9]').hasMatch(firstChar)) {
      return '数字';
    }
    // それ以外の場合（記号など）、「記号」を返す
    else {
      return '記号';
    }
  }

  String _convertToHiragana(String katakana) {
    // Unicodeの範囲を利用してカタカナからひらがなに変換
    final offset = 'ァ'.codeUnitAt(0) - 'ぁ'.codeUnitAt(0);
    return String.fromCharCode(katakana.codeUnitAt(0) - offset);
  }

  bool get isEmptyAllFields =>
      word.isEmpty && wordReading.isEmpty && definition.isEmpty;
}
