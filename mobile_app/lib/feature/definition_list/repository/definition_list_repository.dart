import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/constant/initial_main_group.dart';
import '../../definition/domain/definition.dart';
import '../../definition/repository/definition_response_mapper.dart';
import '../domain/definition_list_state.dart';
import '../util/definition_feed_type.dart';

part 'definition_list_repository.g.dart';

@Riverpod(keepAlive: true)
DefinitionListRepository definitionListRepository(
  DefinitionListRepositoryRef ref,
) {
  final api = ref.watch(teigiiiApiProvider);
  return DefinitionListRepository(
    api.getTimelineApi(),
    api.getWordsApi(),
    api.getUsersApi(),
  );
}

/// 定義一覧を Workers API から取得する Repository。
///
/// 一覧 API は定義本体（DefinitionResponse）を返すため、ID へ潰さず
/// [Definition] のまま返す。ID だけにすると各 tile が個別取得して N+1 になる。
///
/// @doc doc/specs/legacy-repository-api-mapping.md#定義一覧-フィード
class DefinitionListRepository {
  DefinitionListRepository(this._timelineApi, this._wordsApi, this._usersApi);

  final TimelineApi _timelineApi;
  final WordsApi _wordsApi;
  final UsersApi _usersApi;

  Future<DefinitionListState> fetchForHomeRecommend(String? cursor) async {
    try {
      final response = await _timelineApi.v1TimelineDiscoverGet(
        cursor: cursor,
        limit: fetchLimitForDefinitionList,
        type: 'definition',
      );
      final page = response.data!;

      return DefinitionListState(
        list: page.items
            .whereType<DiscoverFeedDefinitionItem>()
            .map((item) => definitionFromResponse(item.activity.definition))
            .toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<DefinitionListState> fetchForHomeFollowing(String? cursor) async {
    try {
      final response = await _timelineApi.v1TimelineFollowingGet(
        cursor: cursor,
        limit: fetchLimitForDefinitionList,
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<DefinitionListState> fetchForWordTop(
    WordTopOrderByType orderByType,
    String wordId,
    String? cursor,
  ) async {
    try {
      final response = await _wordsApi.v1WordsIdDefinitionsGet(
        id: wordId,
        cursor: cursor,
        limit: fetchLimitForDefinitionList,
        scope: 'all',
        sort: switch (orderByType) {
          WordTopOrderByType.createdAt => 'newest',
          WordTopOrderByType.likesCount => 'reactions',
        },
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<DefinitionListState> fetchForProfileCreatedAt(
    String targetUserId,
    String? cursor,
  ) async {
    try {
      final response = await _usersApi.v1UsersIdDefinitionsGet(
        id: targetUserId,
        cursor: cursor,
        limit: fetchLimitForDefinitionList,
        sort: 'newest',
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<DefinitionListState> fetchForLikedByUser(
    String targetUserId,
    String? cursor,
  ) async {
    try {
      final response = await _usersApi.v1UsersIdLikedDefinitionsGet(
        id: targetUserId,
        cursor: cursor,
        limit: fetchLimitForDefinitionList,
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<DefinitionListState> fetchForIndividualDictionary(
    String targetUserId,
    InitialSubGroup initialSubGroup,
    String? cursor,
  ) async {
    try {
      final response = await _usersApi.v1UsersIdDefinitionsGet(
        id: targetUserId,
        cursor: cursor,
        limit: fetchLimitForDefinitionList,
        subGroup: initialSubGroup.label,
        sort: 'reading',
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// 特定ユーザーの、特定の言葉に対する定義一覧（新着順）。
  ///
  /// 本人閲覧時は public + private（下書きは含まない）。
  Future<DefinitionListState> fetchForUserWord(
    String targetUserId,
    String wordId,
    String? cursor,
  ) async {
    try {
      final response = await _usersApi.v1UsersIdDefinitionsGet(
        id: targetUserId,
        cursor: cursor,
        limit: fetchLimitForDefinitionList,
        wordId: wordId,
        sort: 'newest',
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  DefinitionListState _toState(V1UsersIdDefinitionsGet200Response page) =>
      DefinitionListState(
        list: page.items.map(definitionFromResponse).toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
}
