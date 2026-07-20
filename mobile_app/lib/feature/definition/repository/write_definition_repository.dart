import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../domain/definition_for_write.dart';

part 'write_definition_repository.g.dart';

@riverpod
WriteDefinitionRepository writeDefinitionRepository(
  WriteDefinitionRepositoryRef ref,
) => WriteDefinitionRepository(
  ref.watch(teigiiiApiProvider).getWordsApi(),
  ref.watch(teigiiiApiProvider).getDefinitionsApi(),
);

/// 定義の書き込み（新規作成、更新、削除）に関する処理を記述するRepository
///
/// @doc doc/specs/legacy-repository-api-mapping.md#定義の読み書き
class WriteDefinitionRepository {
  WriteDefinitionRepository(this._wordsApi, this._definitionsApi);

  final WordsApi _wordsApi;
  final DefinitionsApi _definitionsApi;

  /// 定義を新規作成し、作成した定義の id を返す。
  ///
  /// 言葉が未登録の場合は新規登録し、既存の場合は
  /// 409 レスポンスの `existingWord.id` を使う。
  Future<String> createDefinition(DefinitionForWrite definitionForWrite) async {
    final wordId = await _resolveWordId(definitionForWrite);

    try {
      final response = await _definitionsApi.v1DefinitionsPost(
        createDefinitionRequest: CreateDefinitionRequest(
          wordId: wordId,
          body: definitionForWrite.definition,
          status: _toStatus(isPublic: definitionForWrite.isPublic),
        ),
      );
      return response.data!.id;
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// 定義の本文と公開設定を更新する。言葉・よみは変更しない。
  Future<void> updateDefinition(DefinitionForWrite definitionForWrite) async {
    try {
      await _definitionsApi.v1DefinitionsIdPatch(
        id: definitionForWrite.id!,
        updateDefinitionRequest: UpdateDefinitionRequest(
          body: definitionForWrite.definition,
          status: _toStatus(isPublic: definitionForWrite.isPublic),
        ),
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<void> updatePostType({
    required String definitionId,
    required bool isPublic,
  }) async {
    try {
      await _definitionsApi.v1DefinitionsIdPatch(
        id: definitionId,
        updateDefinitionRequest: UpdateDefinitionRequest(
          status: _toStatus(isPublic: isPublic),
        ),
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// 定義を削除する。
  ///
  /// 孤児になった言葉の削除は行わない（言葉はグローバル資産として残す）。
  Future<void> deleteDefinition(String definitionId) async {
    try {
      await _definitionsApi.v1DefinitionsIdDelete(id: definitionId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// 言葉を登録し、定義の作成に使う wordId を返す。
  Future<String> _resolveWordId(DefinitionForWrite definitionForWrite) async {
    try {
      final response = await _wordsApi.v1WordsPost(
        createWordRequest: CreateWordRequest(
          word: definitionForWrite.trimmedWord,
          reading: definitionForWrite.trimmedWordReading,
        ),
      );
      return response.data!.id;
    } on DioException catch (exception) {
      final data = exception.response?.data;
      if (exception.response?.statusCode == 409 &&
          data is Map<String, dynamic>) {
        return WordConflictResponse.fromJson(data).existingWord.id;
      }
      throw ApiException.fromDioException(exception);
    }
  }

  DefinitionStatus _toStatus({required bool isPublic}) =>
      isPublic ? DefinitionStatus.public : DefinitionStatus.private;
}
