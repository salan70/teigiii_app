import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../domain/word.dart';

part 'word_repository.g.dart';

@riverpod
WordRepository wordRepository(WordRepositoryRef ref) =>
    WordRepository(ref.watch(teigiiiApiProvider).getWordsApi());

/// @doc doc/specs/legacy-repository-api-mapping.md#言葉
class WordRepository {
  WordRepository(this._wordsApi);

  final WordsApi _wordsApi;

  Word _fromResponse(WordResponse response) => Word(
    id: response.id,
    word: response.word,
    reading: response.reading,
    initialSubGroupLabel: response.readingSubGroup,
    postedDefinitionCount: response.publicDefinitionCount,
    isSavedByMe: response.isSavedByMe,
    isEditableByMe: response.isEditableByMe,
  );

  /// [wordId] に一致する [Word] を返す。
  ///
  /// 該当する言葉が見つからない場合、null を返す。
  Future<Word?> fetchWordById(String wordId) async {
    try {
      final response = await _wordsApi.v1WordsIdGet(id: wordId);
      final word = response.data!;
      return _fromResponse(word);
    } on DioException catch (exception) {
      if (exception.response?.statusCode == 404) {
        return null;
      }
      throw ApiException.fromDioException(exception);
    }
  }

  Future<void> save(String wordId) async {
    try {
      await _wordsApi.v1WordsIdSavePut(id: wordId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<void> unsave(String wordId) async {
    try {
      await _wordsApi.v1WordsIdSaveDelete(id: wordId);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<Word> update({
    required String wordId,
    required String word,
    required String reading,
  }) async {
    try {
      final response = await _wordsApi.v1WordsIdPatch(
        id: wordId,
        updateWordRequest: UpdateWordRequest(word: word, reading: reading),
      );
      return _fromResponse(response.data!);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
