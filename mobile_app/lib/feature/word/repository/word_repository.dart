import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../../util/constant/initial_main_group.dart';
import '../domain/word.dart';

part 'word_repository.g.dart';

@riverpod
WordRepository wordRepository(WordRepositoryRef ref) =>
    WordRepository(ref.watch(teigiiiApiProvider).getWordsApi());

/// @doc doc/specs/legacy-repository-api-mapping.md#言葉
class WordRepository {
  WordRepository(this._wordsApi);

  final WordsApi _wordsApi;

  /// [wordId] に一致する [Word] を返す。
  ///
  /// 該当する言葉が見つからない場合、null を返す。
  Future<Word?> fetchWordById(String wordId) async {
    try {
      final response = await _wordsApi.v1WordsIdGet(id: wordId);
      return _wordFromResponse(response.data!);
    } on DioException catch (exception) {
      if (exception.response?.statusCode == 404) {
        return null;
      }
      throw ApiException.fromDioException(exception);
    }
  }

  /// [wordId] の言葉を保存する。
  Future<void> save(String wordId) async {
    try {
      await _wordsApi.v1WordsIdSavePut(id: wordId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// [wordId] の言葉の保存を解除する。
  Future<void> unsave(String wordId) async {
    try {
      await _wordsApi.v1WordsIdSaveDelete(id: wordId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// 新しい言葉を登録する。
  ///
  /// 409 (既存語句との重複) の場合、既存の [Word] を返す。
  Future<Word> create({
    required String word,
    required String reading,
  }) async {
    try {
      final response = await _wordsApi.v1WordsPost(
        createWordRequest: CreateWordRequest(word: word, reading: reading),
      );
      return _wordFromResponse(response.data!);
    } on DioException catch (exception) {
      if (exception.response?.statusCode == 409) {
        final data = exception.response!.data;
        if (data is Map<String, dynamic>) {
          final conflict = WordConflictResponse.fromJson(data);
          return Word(
            id: conflict.existingWord.id,
            word: conflict.existingWord.word,
            reading: conflict.existingWord.reading,
            initialSubGroupLabel:
                InitialSubGroup.fromString(conflict.existingWord.reading).label,
            postedDefinitionCount: 0,
          );
        }
      }
      throw ApiException.fromDioException(exception);
    }
  }

  Word _wordFromResponse(WordResponse r) => Word(
    id: r.id,
    word: r.word,
    reading: r.reading,
    initialSubGroupLabel: r.readingSubGroup,
    postedDefinitionCount: r.publicDefinitionCount,
    isSavedByMe: r.isSavedByMe,
  );
}
