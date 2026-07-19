import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/feature/word/domain/word.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'word_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WordsApi>()])
void main() {
  final mockWordsApi = MockWordsApi();
  final repository = WordRepository(mockWordsApi);

  tearDown(() => reset(mockWordsApi));

  group('fetchWordById', () {
    test('WordResponse を Word に変換して返す', () async {
      // * Arrange
      when(mockWordsApi.v1WordsIdGet(id: 'word1')).thenAnswer(
        (_) async => Response(
          data: WordResponse(
            id: 'word1',
            word: '二日目のカレー',
            reading: 'ふつかめのかれー',
            readingSubGroup: 'は行',
            publicDefinitionCount: 3,
            isSavedByMe: false,
            isEditableByMe: false,
          ),
          requestOptions: RequestOptions(path: '/v1/words/word1'),
        ),
      );

      // * Act
      final word = await repository.fetchWordById('word1');

      // * Assert
      expect(
        word,
        const Word(
          id: 'word1',
          word: '二日目のカレー',
          reading: 'ふつかめのかれー',
          initialSubGroupLabel: 'は行',
          postedDefinitionCount: 3,
        ),
      );
    });

    test('404 の場合 null を返す', () async {
      // * Arrange
      final requestOptions = RequestOptions(path: '/v1/words/word1');
      when(mockWordsApi.v1WordsIdGet(id: 'word1')).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            statusCode: 404,
            data: {
              'error': {'code': 'word_not_found', 'message': 'Word not found'},
            },
            requestOptions: requestOptions,
          ),
        ),
      );

      // * Act
      final word = await repository.fetchWordById('word1');

      // * Assert
      expect(word, isNull);
    });

    test('404 以外のエラーの場合 ApiException を投げる', () async {
      // * Arrange
      final requestOptions = RequestOptions(path: '/v1/words/word1');
      when(mockWordsApi.v1WordsIdGet(id: 'word1')).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            statusCode: 500,
            data: {
              'error': {'code': 'internal_error', 'message': 'Internal error'},
            },
            requestOptions: requestOptions,
          ),
        ),
      );

      // * Act & Assert
      expect(
        () => repository.fetchWordById('word1'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
