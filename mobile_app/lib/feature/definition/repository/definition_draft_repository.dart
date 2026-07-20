import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../domain/definition_draft.dart';

part 'definition_draft_repository.g.dart';

@riverpod
DefinitionDraftRepository definitionDraftRepository(
  DefinitionDraftRepositoryRef ref,
) => DefinitionDraftRepository(
  ref.watch(teigiiiApiProvider).getDefinitionDraftsApi(),
);

/// Definition Draft の保存・取得・削除・確定を担う API 境界。
///
/// @doc doc/specs/mobile-app-functional-spec.md#4-下書き
class DefinitionDraftRepository {
  DefinitionDraftRepository(this._api);

  final DefinitionDraftsApi _api;

  Future<DefinitionDraft> save(DefinitionDraft draft) async {
    try {
      final response = await _api.v1DefinitionDraftsIdPut(
        id: draft.id,
        putDefinitionDraftRequest: PutDefinitionDraftRequest(
          wordId: draft.wordId,
          word: draft.word,
          reading: draft.wordReading,
          body: draft.definition,
          visibility: draft.isPublic
              ? DefinitionVisibility.public
              : DefinitionVisibility.private,
        ),
      );
      return DefinitionDraft.fromResponse(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<DefinitionDraft> get(String id) async {
    try {
      final response = await _api.v1DefinitionDraftsIdGet(id: id);
      return DefinitionDraft.fromResponse(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<({List<DefinitionDraft> items, String? nextCursor})> list({
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _api.v1MeDefinitionDraftsGet(
        cursor: cursor,
        limit: limit,
      );
      final page = response.data!;
      return (
        items: page.items.map(DefinitionDraft.fromResponse).toList(),
        nextCursor: page.nextCursor,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _api.v1DefinitionDraftsIdDelete(id: id);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<String> finalize(
    String id, {
    bool confirmReadingMismatch = false,
  }) async {
    try {
      final response = await _api.v1DefinitionDraftsIdFinalizePost(
        id: id,
        finalizeDefinitionDraftRequest: FinalizeDefinitionDraftRequest(
          confirmReadingMismatch: confirmReadingMismatch,
        ),
      );
      return response.data!.id;
    } on DioException catch (exception) {
      final data = exception.response?.data;
      if (exception.response?.statusCode == 409 &&
          data is Map<String, dynamic> &&
          data['error'] is Map<String, dynamic> &&
          (data['error'] as Map<String, dynamic>)['code'] ==
              'word_reading_mismatch') {
        final mismatch = WordReadingMismatchResponse.fromJson(data);
        throw WordReadingMismatchException(
          word: mismatch.existingWord.word,
          existingReading: mismatch.existingWord.reading,
        );
      }
      throw ApiException.fromDioException(exception);
    }
  }
}

class WordReadingMismatchException implements Exception {
  const WordReadingMismatchException({
    required this.word,
    required this.existingReading,
  });

  final String word;
  final String existingReading;
}
