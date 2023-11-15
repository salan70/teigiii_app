import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/constant/firestore_collections.dart';
import '../../../util/constant/initial_main_group.dart';
import '../../../util/constant/string_regex.dart';
import '../../word/domain/word.dart';

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

  factory DefinitionForWrite.empty() {
    return const DefinitionForWrite(
      id: null,
      word: '',
      wordReading: '',
      isPublic: true,
      definition: '',
    );
  }

  /// [Word]から[DefinitionForWrite]を生成する
  factory DefinitionForWrite.fromWord(Word word) {
    return  DefinitionForWrite(
      id: null,
      word: word.word,
      wordReading: word.reading,
      isPublic: true,
      definition: '',
    );
  }

  const DefinitionForWrite._();

  int get maxWordLength => 30;
  int get maxWordReadingLength => 50;
  int get maxDefinitionLength => 500;

  String get _leadingSpaceErrorText => '先頭にはスペース等を使用できません';

  String? outputWordError() {
    if (word.isEmpty) {
      // 未入力の場合はエラーを出さない
      return null;
    }

    // 最大文字数を超えているかどうか
    if (word.length > maxWordLength) {
      return '$maxWordLength文字以内で入力してください';
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

    // 最大文字数を超えているかどうか
    if (wordReading.length > maxWordReadingLength) {
      return '$maxWordReadingLength文字以内で入力してください';
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
    final isValidDefinition =
        definition.isNotEmpty && definition.length <= maxDefinitionLength;

    return isValidWord && isValidWordReading && isValidDefinition;
  }

  Map<String, dynamic> toFirestoreForCreate() {
    return {
      DefinitionsCollection.word: word,
      DefinitionsCollection.wordReading: wordReading,
      DefinitionsCollection.wordReadingInitialSubGroupLabel:
          _wordReadingInitialLabel,
      DefinitionsCollection.definition: definition,
      DefinitionsCollection.likesCount: 0,
      DefinitionsCollection.isPublic: isPublic,
      DefinitionsCollection.isEdited: false,
    };
  }

  Map<String, dynamic> toFirestoreForUpdate() {
    return {
      DefinitionsCollection.word: word,
      DefinitionsCollection.wordReading: wordReading,
      DefinitionsCollection.wordReadingInitialSubGroupLabel:
          _wordReadingInitialLabel,
      DefinitionsCollection.definition: definition,
      DefinitionsCollection.isPublic: isPublic,
      DefinitionsCollection.isEdited: true,
    };
  }

  bool get isEmptyAllFields =>
      word.isEmpty && wordReading.isEmpty && definition.isEmpty;

  String get _wordReadingInitialLabel =>
      InitialSubGroup.labelFromString(wordReading);
}
