import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/constant/initial_main_group.dart';
import '../../word/domain/word.dart';
import '../domain/word_list_state.dart';

part 'user_dictionary_word_repository.g.dart';

@riverpod
UserDictionaryWordRepository userDictionaryWordRepository(
  UserDictionaryWordRepositoryRef ref,
) {
  final api = ref.watch(teigiiiApiProvider);
  return UserDictionaryWordRepository(api.getMeApi(), api.getUsersApi());
}

/// 自分・他ユーザーの辞書言葉一覧および保存言葉一覧を取得する Repository。
class UserDictionaryWordRepository {
  UserDictionaryWordRepository(this._meApi, this._usersApi);

  final MeApi _meApi;
  final UsersApi _usersApi;

  /// 自分が定義済みの言葉一覧を取得する（公開 + 非公開 の件数合算）。
  Future<WordListState> fetchMyDefinedWords(String? cursor) async {
    try {
      final response = await _meApi.v1MeDefinedWordsGet(
        cursor: cursor,
        limit: fetchLimitForWordList,
      );
      final page = response.data!;
      return WordListState(
        list: page.items
            .map(
              (item) => Word(
                id: item.word.id,
                word: item.word.word,
                reading: item.word.reading,
                initialSubGroupLabel:
                    InitialSubGroup.fromString(item.word.reading).label,
                postedDefinitionCount: item.publicCount + item.privateCount,
                isSavedByMe: false,
              ),
            )
            .toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// 他ユーザーの公開辞書言葉一覧を取得する。
  Future<WordListState> fetchUserDictionary(
    String userId,
    String? cursor,
  ) async {
    try {
      final response = await _usersApi.v1UsersIdDictionaryGet(
        id: userId,
        cursor: cursor,
        limit: fetchLimitForWordList,
      );
      final page = response.data!;
      return WordListState(
        list: page.items
            .map(
              (item) => Word(
                id: item.word.id,
                word: item.word.word,
                reading: item.word.reading,
                initialSubGroupLabel:
                    InitialSubGroup.fromString(item.word.reading).label,
                postedDefinitionCount: item.publicCount,
                isSavedByMe: false,
              ),
            )
            .toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// 自分が保存した言葉一覧を取得する。
  Future<WordListState> fetchMySavedWords(String? cursor) async {
    try {
      final response = await _meApi.v1MeSavedWordsGet(
        cursor: cursor,
        limit: fetchLimitForWordList,
      );
      final page = response.data!;
      return WordListState(
        list: page.items
            .map(
              (item) => Word(
                id: item.word.id,
                word: item.word.word,
                reading: item.word.reading,
                initialSubGroupLabel:
                    InitialSubGroup.fromString(item.word.reading).label,
                postedDefinitionCount: item.publicCount,
                isSavedByMe: true,
              ),
            )
            .toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
