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
      final idList = <String>[];
      var nextCursor = cursor;

      do {
        final remaining = fetchLimitForDefinitionList - idList.length;
        final response = await _timelineApi.v1TimelineDiscoverGet(
          cursor: nextCursor,
          limit: remaining,
        );
        final page = response.data!;
        idList.addAll(
          page.items.whereType<DiscoverFeedDefinitionItem>().map(
            (item) => item.activity.definition.id,
          ),
        );
        nextCursor = page.nextCursor;
      } while (idList.length < fetchLimitForDefinitionList &&
          nextCursor != null);

      return DefinitionIdListState(
        list: idList,
        nextCursor: nextCursor,
        hasMore: nextCursor != null,
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

  Future<DefinitionIdListState> fetchForWordTop(
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
