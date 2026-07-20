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
  ref.watch(teigiiiApiProvider).getDefinitionsApi(),
);

/// 定義の書き込み（新規作成、更新、削除）に関する処理を記述するRepository
///
/// @doc doc/specs/legacy-repository-api-mapping.md#定義の読み書き
class WriteDefinitionRepository {
  WriteDefinitionRepository(this._definitionsApi);

  final DefinitionsApi _definitionsApi;

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

  DefinitionStatus _toStatus({required bool isPublic}) =>
      isPublic ? DefinitionStatus.public : DefinitionStatus.private;
}
