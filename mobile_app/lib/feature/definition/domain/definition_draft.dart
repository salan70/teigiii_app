import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart' as api;

import 'definition_for_write.dart';

part 'definition_draft.freezed.dart';

/// 投稿前の入力を、確定済み定義とは独立して保持する Draft。
@freezed
class DefinitionDraft with _$DefinitionDraft {
  const factory DefinitionDraft({
    required String id,
    required String? wordId,
    required String word,
    required String wordReading,
    required bool isPublic,
    required String definition,
    required bool isPersisted,
  }) = _DefinitionDraft;

  factory DefinitionDraft.empty(String id) => DefinitionDraft(
    id: id,
    wordId: null,
    word: '',
    wordReading: '',
    isPublic: true,
    definition: '',
    isPersisted: false,
  );

  factory DefinitionDraft.fromInitial(String id, DefinitionForWrite initial) =>
      DefinitionDraft(
        id: id,
        wordId: initial.wordId,
        word: initial.word,
        wordReading: initial.wordReading,
        isPublic: initial.isPublic,
        definition: initial.definition,
        isPersisted: false,
      );

  factory DefinitionDraft.fromResponse(api.DefinitionDraftResponse response) =>
      DefinitionDraft(
        id: response.id,
        wordId: response.wordId,
        word: response.word,
        wordReading: response.reading,
        isPublic: response.visibility == api.DefinitionVisibility.public,
        definition: response.body,
        isPersisted: true,
      );

  const DefinitionDraft._();

  DefinitionForWrite get fields => DefinitionForWrite(
    wordId: wordId,
    id: null,
    authorId: '',
    word: word,
    wordReading: wordReading,
    isPublic: isPublic,
    definition: definition,
  );

  bool get hasAnyInput =>
      word.isNotEmpty || wordReading.isNotEmpty || definition.isNotEmpty;

  bool get canFinalize => fields.isValidAllFields();
}
