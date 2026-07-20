import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../definition/domain/definition_draft.dart';
import '../domain/personal_dictionary.dart';
import '../repository/personal_dictionary_repository.dart';

part 'personal_dictionary_state.g.dart';

@riverpod
Future<PersonalDictionaryOverview> personalDictionaryOverview(
  PersonalDictionaryOverviewRef ref,
) => ref.watch(personalDictionaryRepositoryProvider).fetchOverview();

@riverpod
class DefinedWordList extends _$DefinedWordList {
  @override
  Future<PagedItems<DefinedWord>> build() =>
      ref.read(personalDictionaryRepositoryProvider).fetchDefinedWords();

  Future<void> fetchMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || state.isLoading) {
      return;
    }
    state = const AsyncLoading<PagedItems<DefinedWord>>().copyWithPrevious(
      state,
    );
    try {
      final next = await ref
          .read(personalDictionaryRepositoryProvider)
          .fetchDefinedWords(cursor: current.nextCursor);
      state = AsyncData(current.append(next));
    } on Object catch (error, stackTrace) {
      state = AsyncError<PagedItems<DefinedWord>>(
        error,
        stackTrace,
      ).copyWithPrevious(state);
    }
  }
}

@riverpod
class DefinitionDraftList extends _$DefinitionDraftList {
  @override
  Future<PagedItems<DefinitionDraft>> build() =>
      ref.read(personalDictionaryRepositoryProvider).fetchDrafts();

  Future<void> fetchMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || state.isLoading) {
      return;
    }
    state = const AsyncLoading<PagedItems<DefinitionDraft>>().copyWithPrevious(
      state,
    );
    try {
      final next = await ref
          .read(personalDictionaryRepositoryProvider)
          .fetchDrafts(cursor: current.nextCursor);
      state = AsyncData(current.append(next));
    } on Object catch (error, stackTrace) {
      state = AsyncError<PagedItems<DefinitionDraft>>(
        error,
        stackTrace,
      ).copyWithPrevious(state);
    }
  }

  Future<void> delete(String id) async {
    await ref.read(personalDictionaryRepositoryProvider).deleteDraft(id);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(
        PagedItems(
          items: current.items.where((draft) => draft.id != id).toList(),
          nextCursor: current.nextCursor,
        ),
      );
    }
    ref.invalidate(personalDictionaryOverviewProvider);
  }
}

@riverpod
class SavedWordList extends _$SavedWordList {
  @override
  Future<PagedItems<SavedWord>> build() =>
      ref.read(personalDictionaryRepositoryProvider).fetchSavedWords();

  Future<void> fetchMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || state.isLoading) {
      return;
    }
    state = const AsyncLoading<PagedItems<SavedWord>>().copyWithPrevious(state);
    try {
      final next = await ref
          .read(personalDictionaryRepositoryProvider)
          .fetchSavedWords(cursor: current.nextCursor);
      state = AsyncData(current.append(next));
    } on Object catch (error, stackTrace) {
      state = AsyncError<PagedItems<SavedWord>>(
        error,
        stackTrace,
      ).copyWithPrevious(state);
    }
  }
}
