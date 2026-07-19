import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';

part 'like_definition_repository.g.dart';

@riverpod
LikeDefinitionRepository likeDefinitionRepository(
  LikeDefinitionRepositoryRef ref,
) =>
    LikeDefinitionRepository(ref.watch(teigiiiApiProvider).getDefinitionsApi());

/// 定義のいいねに関する処理を記述するRepository
///
/// @doc doc/specs/legacy-repository-api-mapping.md#いいね
class LikeDefinitionRepository {
  LikeDefinitionRepository(this._definitionsApi);

  final DefinitionsApi _definitionsApi;

  Future<void> likeDefinition(String definitionId) async {
    try {
      await _definitionsApi.v1DefinitionsIdLikePut(id: definitionId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<void> unlikeDefinition(String definitionId) async {
    try {
      await _definitionsApi.v1DefinitionsIdLikeDelete(id: definitionId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
