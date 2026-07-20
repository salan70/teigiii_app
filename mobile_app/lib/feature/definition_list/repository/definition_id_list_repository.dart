import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/constant/initial_main_group.dart';
import '../domain/definition_id_list_state.dart';
import '../util/definition_feed_type.dart';

part 'definition_id_list_repository.g.dart';

@Riverpod(keepAlive: true)
DefinitionIdListRepository definitionIdListRepository(
  DefinitionIdListRepositoryRef ref,
) {
  final api = ref.watch(teigiiiApiProvider);
  return DefinitionIdListRepository(
    api.getTimelineApi(),
    api.getWordsApi(),
    api.getUsersApi(),
  );
}

/// 定義 ID 一覧を Workers API から取得する Repository。
///
/// @doc doc/specs/legacy-repository-api-mapping.md#定義一覧-フィード
class DefinitionIdListRepository {
  DefinitionIdListRepository(this._timelineApi, this._wordsApi, this._usersApi);

  final TimelineApi _timelineApi;
  final WordsApi _wordsApi;
  final UsersApi _usersApi;

  Future<DefinitionIdListState> fetchForHomeRecommend(String? cursor) async {
    try {
      final response = await _timelineApi.v1TimelineDiscoverGet(
        cursor: cursor,
        limit: fetchLimitForDefinitionList,
        type: 'definition',
      );
      final page = response.data!;

      return DefinitionIdListState(
        list: page.items
            .whereType<DiscoverFeedDefinitionItem>()
            .map((item) => item.activity.definition.id)
            .toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<DefinitionIdListState> fetchForHomeFollowing(String? cursor) async {
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

  Future<DefinitionIdListState> fetchForWordMine(
    String wordId,
    String? cursor,
  ) async {
    try {
      final response = await _wordsApi.v1WordsIdDefinitionsGet(
        id: wordId,
        cursor: cursor,
        limit: fetchLimitForDefinitionList,
        scope: 'mine',
        sort: 'newest',
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<DefinitionIdListState> fetchForWordOthers(
    WordTopOrderByType orderByType,
    String wordId,
    String? cursor,
  ) async {
    try {
      final response = await _wordsApi.v1WordsIdDefinitionsGet(
        id: wordId,
        cursor: cursor,
        limit: fetchLimitForDefinitionList,
        scope: 'others',
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

  Future<DefinitionIdListState> fetchForProfileCreatedAt(
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

  Future<DefinitionIdListState> fetchForLikedByUser(
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

  Future<DefinitionIdListState> fetchForIndividualDictionary(
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

  DefinitionIdListState _toState(V1UsersIdDefinitionsGet200Response page) =>
      DefinitionIdListState(
        list: page.items.map((item) => item.id).toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
}
