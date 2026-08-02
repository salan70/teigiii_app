import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../domain/word.dart';
import '../domain/word_registration.dart';

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

  /// 言葉を明示登録する。
  ///
  /// 登録した [Word] と、その登録が何をもたらしたかを表す
  /// [WordRegistrationOutcome] を返す。
  Future<WordRegistration> create({
    required String word,
    required String reading,
  }) async {
    try {
      final response = await _wordsApi.v1WordsPost(
        createWordRequest: CreateWordRequest(word: word, reading: reading),
      );
      final data = response.data!;
      return WordRegistration(
        word: Word(
          id: data.id,
          word: data.word,
          reading: data.reading,
          initialSubGroupLabel: data.readingSubGroup,
          postedDefinitionCount: data.publicDefinitionCount,
          isSavedByMe: data.isSavedByMe,
        ),
        outcome: _outcomeFromResponse(data.registrationResult),
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  /// 登録前の既存語チェック。
  ///
  /// (表記, よみ) が完全一致し、かつ公開されている言葉の ID を返す。
  /// 該当がない場合は null を返す。非公開の言葉は存在を秘匿するため null になる。
  Future<String?> findPublicWordId({
    required String word,
    required String reading,
  }) async {
    try {
      final response = await _wordsApi.v1WordsLookupGet(
        word: word,
        reading: reading,
      );
      return response.data!.word?.id;
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  WordRegistrationOutcome _outcomeFromResponse(WordRegistrationResult result) =>
      switch (result) {
        WordRegistrationResult.created => WordRegistrationOutcome.created,
        WordRegistrationResult.promoted => WordRegistrationOutcome.promoted,
        WordRegistrationResult.alreadyPublic =>
          WordRegistrationOutcome.alreadyPublic,
      };

  Word _wordFromResponse(WordResponse r) => Word(
    id: r.id,
    word: r.word,
    reading: r.reading,
    initialSubGroupLabel: r.readingSubGroup,
    postedDefinitionCount: r.publicDefinitionCount,
    isSavedByMe: r.isSavedByMe,
  );
}
