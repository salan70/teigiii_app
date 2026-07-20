import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../community_dictionary/domain/community_dictionary.dart';
import '../../word/domain/word.dart';
import '../domain/word_list_state.dart';

part 'fetch_word_list_repository.g.dart';

@riverpod
FetchWordListRepository fetchWordListRepository(
  FetchWordListRepositoryRef ref,
) {
  final api = ref.watch(teigiiiApiProvider);
  return FetchWordListRepository(api.getWordsApi(), api.getSearchApi());
}

/// 言葉一覧を Workers API から取得する Repository。
///
/// @doc doc/specs/legacy-repository-api-mapping.md#言葉
class FetchWordListRepository {
  FetchWordListRepository(this._wordsApi, this._searchApi);

  final WordsApi _wordsApi;
  final SearchApi _searchApi;

  Future<WordListState> fetchWordListStateByInitial(
    String initial,
    String? cursor,
  ) async {
    try {
      final response = await _wordsApi.v1WordsGet(
        cursor: cursor,
        limit: fetchLimitForWordList,
        subGroup: initial,
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<WordListState> fetchCommunityWordList({
    required CommunityWordFilter filter,
    required String query,
    required String? cursor,
  }) async {
    try {
      final response = await _wordsApi.v1WordsGet(
        cursor: cursor,
        limit: fetchLimitForWordList,
        filter: filter.apiValue,
        q: query.isEmpty ? null : query,
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<WordListState> fetchWordListStateBySearchWord(
    String searchWord,
    String? cursor,
  ) async {
    try {
      final response = await _searchApi.v1SearchWordsGet(
        q: searchWord,
        cursor: cursor,
        limit: fetchLimitForWordList,
      );
      return _toState(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  WordListState _toState(V1WordsGet200Response page) => WordListState(
    list: page.items
        .map(
          (item) => Word(
            id: item.id,
            word: item.word,
            reading: item.reading,
            initialSubGroupLabel: item.readingSubGroup,
            postedDefinitionCount: item.publicDefinitionCount,
          ),
        )
        .toList(),
    nextCursor: page.nextCursor,
    hasMore: page.nextCursor != null,
  );
}
