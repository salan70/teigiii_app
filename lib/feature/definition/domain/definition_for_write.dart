import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/constant/firestore_collections.dart';
import '../../../util/constant/initial_main_group.dart';
import '../../../util/constant/string_regex.dart';

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

    // 文字が無効かどうか確認
    if (!combinedRegex.hasMatch(wordReading)) {
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
      DefinitionsCollection.word: word,
      DefinitionsCollection.wordReadingInitialSubGroupLabel:
          _wordReadingInitialLabel,
      DefinitionsCollection.definition: definition,
      DefinitionsCollection.likesCount: 0,
      DefinitionsCollection.isPublic: isPublic,
    };
  }

  Map<String, dynamic> toFirestoreForUpdate() {
    return {
      DefinitionsCollection.word: word,
      DefinitionsCollection.wordReadingInitialSubGroupLabel:
          _wordReadingInitialLabel,
      DefinitionsCollection.definition: definition,
      DefinitionsCollection.isPublic: isPublic,
    };
  }

  bool get isEmptyAllFields =>
      word.isEmpty && wordReading.isEmpty && definition.isEmpty;

  String get _wordReadingInitialLabel =>
      InitialSubGroup.labelFromString(wordReading);
}
