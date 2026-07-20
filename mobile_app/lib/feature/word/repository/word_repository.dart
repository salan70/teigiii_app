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

  /// [wordId] に一致する [Word] を返す。
  ///
  /// 該当する言葉が見つからない場合、null を返す。
  Future<Word?> fetchWordById(String wordId) async {
    try {
      final response = await _wordsApi.v1WordsIdGet(id: wordId);
      final word = response.data!;
      return Word(
        id: word.id,
        word: word.word,
        reading: word.reading,
        initialSubGroupLabel: word.readingSubGroup,
        postedDefinitionCount: word.publicDefinitionCount,
      );
    } on DioException catch (exception) {
      if (exception.response?.statusCode == 404) {
        return null;
      }
      throw ApiException.fromDioException(exception);
    }
  }
}
