import 'package:freezed_annotation/freezed_annotation.dart';

part 'definition_for_write.freezed.dart';

/// Definitionの新規投稿・更新時に使用するオブジェクト
@freezed
class DefinitionForWrite with _$DefinitionForWrite {
  const factory DefinitionForWrite({
    required String? id,
    required String authorId,
    required String wordId,
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

  bool canPost() {
    final isValidWord = outputWordError() == null && word.isNotEmpty;
    final isValidWordReading =
        outputWordReadingError() == null && wordReading.isNotEmpty;
    final isValidDefinition = definition.isNotEmpty;

    return isValidWord && isValidWordReading && isValidDefinition;
  }
}
