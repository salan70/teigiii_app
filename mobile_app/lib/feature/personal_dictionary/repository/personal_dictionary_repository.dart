import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../definition/domain/definition_draft.dart';
import '../../definition/repository/definition_draft_repository.dart';
import '../domain/personal_dictionary.dart';

part 'personal_dictionary_repository.g.dart';

@riverpod
PersonalDictionaryRepository personalDictionaryRepository(
  PersonalDictionaryRepositoryRef ref,
) => PersonalDictionaryRepository(
  ref.watch(teigiiiApiProvider).getMeApi(),
  ref.watch(definitionDraftRepositoryProvider),
);

/// あなたの辞書の概要と各管理一覧を取得する API 境界。
///
/// @doc doc/specs/mobile-app-functional-spec.md#6-あなたの辞書
class PersonalDictionaryRepository {
  PersonalDictionaryRepository(this._meApi, this._draftRepository);

  final MeApi _meApi;
  final DefinitionDraftRepository _draftRepository;

  Future<PersonalDictionaryOverview> fetchOverview() async {
    try {
      final data = (await _meApi.v1MeDictionaryOverviewGet()).data!;
      return PersonalDictionaryOverview(
        definedWordCount: data.definedWordCount,
        draftCount: data.draftCount,
        savedWordCount: data.savedWordCount,
        recentDefinitions: data.recentDefinitions
            .map(
              (definition) => RecentDefinition(
                id: definition.id,
                word: definition.word.word,
                body: definition.body,
                isPublic: definition.status == DefinitionStatus.public,
              ),
            )
            .toList(),
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<PagedItems<DefinedWord>> fetchDefinedWords({
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final data = (await _meApi.v1MeDefinedWordsGet(
        cursor: cursor,
        limit: limit,
      )).data!;
      return PagedItems(
        items: data.items
            .map(
              (item) => DefinedWord(
                id: item.word.id,
                word: item.word.word,
                reading: item.word.reading,
                publicCount: item.publicCount,
                privateCount: item.privateCount,
              ),
            )
            .toList(),
        nextCursor: data.nextCursor,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<PagedItems<DefinitionDraft>> fetchDrafts({
    String? cursor,
    int limit = 20,
  }) async {
    final page = await _draftRepository.list(cursor: cursor, limit: limit);
    return PagedItems(items: page.items, nextCursor: page.nextCursor);
  }

  Future<void> deleteDraft(String id) => _draftRepository.delete(id);

  Future<PagedItems<SavedWord>> fetchSavedWords({
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final data = (await _meApi.v1MeSavedWordsGet(
        cursor: cursor,
        limit: limit,
      )).data!;
      return PagedItems(
        items: data.items
            .map(
              (item) => SavedWord(
                id: item.word.id,
                word: item.word.word,
                reading: item.word.reading,
                isDefinedByMe: item.isDefinedByMe,
              ),
            )
            .toList(),
        nextCursor: data.nextCursor,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
