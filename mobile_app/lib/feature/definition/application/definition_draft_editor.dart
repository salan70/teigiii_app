import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../definition_list/appication/definition_id_list_state.dart';
import '../../personal_dictionary/application/personal_dictionary_state.dart';
import '../../word/application/word_state.dart';
import '../../word_list/application/word_list_state_by_initial.dart';
import '../../word_list/application/word_list_state_by_search_word.dart';
import '../domain/definition_draft.dart';
import '../domain/definition_for_write.dart';
import '../repository/definition_draft_repository.dart';

part 'definition_draft_editor.g.dart';

@riverpod
String definitionDraftId(DefinitionDraftIdRef ref) => const Uuid().v4();

/// 一画面の入力を Draft として保持し、部分保存と確定を直列化する。
@riverpod
class DefinitionDraftEditor extends _$DefinitionDraftEditor {
  int _revision = 0;

  @override
  FutureOr<DefinitionDraft> build(
    String? draftId,
    DefinitionForWrite? initialDefinitionForWrite,
  ) async {
    if (draftId != null) {
      return ref.read(definitionDraftRepositoryProvider).get(draftId);
    }
    final id = ref.read(definitionDraftIdProvider);
    final initial = initialDefinitionForWrite;
    return initial == null
        ? DefinitionDraft.empty(id)
        : DefinitionDraft.fromInitial(id, initial);
  }

  void changeWord(String word) =>
      _change((draft) => draft.copyWith(word: word));

  void changeWordReading(String reading) =>
      _change((draft) => draft.copyWith(wordReading: reading));

  void changePublicState({required bool isPublic}) =>
      _change((draft) => draft.copyWith(isPublic: isPublic));

  void changeDefinition(String definition) =>
      _change((draft) => draft.copyWith(definition: definition));

  void _change(DefinitionDraft Function(DefinitionDraft draft) update) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    _revision += 1;
    state = AsyncData(update(current));
  }

  bool get isChanged => _revision > 0;

  Future<bool> save() async {
    while (true) {
      final snapshot = state.requireValue;
      if (!snapshot.hasAnyInput) {
        return false;
      }
      final revision = _revision;
      final saved = await ref
          .read(definitionDraftRepositoryProvider)
          .save(snapshot);
      final latest = state.requireValue;
      if (revision == _revision) {
        state = AsyncData(saved);
        return true;
      }

      // 保存中の追加入力は上書きせず、最新内容を続けて保存する。
      state = AsyncData(latest.copyWith(isPersisted: true));
    }
  }

  Future<void> delete() async {
    final draft = state.requireValue;
    if (draft.isPersisted) {
      await ref.read(definitionDraftRepositoryProvider).delete(draft.id);
      ref
        ..invalidate(definitionDraftListProvider)
        ..invalidate(personalDictionaryOverviewProvider);
    }
  }

  Future<String> finalize({bool confirmReadingMismatch = false}) async {
    final draft = state.requireValue;
    if (!draft.canFinalize) {
      throw StateError('Draft is incomplete');
    }
    await save();
    final definitionId = await ref
        .read(definitionDraftRepositoryProvider)
        .finalize(draft.id, confirmReadingMismatch: confirmReadingMismatch);

    ref
      ..invalidate(definitionIdListStateNotifierProvider)
      ..invalidate(definedWordListProvider)
      ..invalidate(definitionDraftListProvider)
      ..invalidate(personalDictionaryOverviewProvider)
      ..invalidate(wordListStateByInitialNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider)
      ..invalidate(wordProvider);
    return definitionId;
  }
}
