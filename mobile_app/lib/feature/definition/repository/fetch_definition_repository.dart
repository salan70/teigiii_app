import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../domain/definition.dart';

part 'fetch_definition_repository.g.dart';

@Riverpod(keepAlive: true)
FetchDefinitionRepository fetchDefinitionRepository(
  FetchDefinitionRepositoryRef ref,
) => FetchDefinitionRepository(
  ref.watch(teigiiiApiProvider).getDefinitionsApi(),
);

/// 定義の取得に関する処理を記述するRepository
///
/// @doc doc/specs/legacy-repository-api-mapping.md#定義の読み書き
class FetchDefinitionRepository {
  FetchDefinitionRepository(this._definitionsApi);

  final DefinitionsApi _definitionsApi;

  Future<Definition> fetchDefinition(String definitionId) async {
    try {
      final response = await _definitionsApi.v1DefinitionsIdGet(
        id: definitionId,
      );
      final definition = response.data!;
      return Definition(
        id: definition.id,
        wordId: definition.word.id,
        word: definition.word.word,
        wordReading: definition.word.reading,
        authorId: definition.author.id,
        authorName: definition.author.name,
        authorImageUrl: definition.author.avatarUrl,
        definition: definition.body,
        isPublic: definition.status == DefinitionStatus.public,
        likesCount: definition.likesCount,
        isLikedByUser: definition.isLikedByMe,
        editableUntil: definition.editableUntil,
        createdAt: definition.createdAt,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
