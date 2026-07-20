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
          isSavedByMe: false,
          isEditableByMe: false,
        ),
      );
    });

    test('保存状態と修正可否を Word に変換する', () async {
      when(mockWordsApi.v1WordsIdGet(id: 'word1')).thenAnswer(
        (_) async => Response(
          data: WordResponse(
            id: 'word1',
            word: '自由',
            reading: 'じゆう',
            readingSubGroup: 'さ行',
            publicDefinitionCount: 0,
            isSavedByMe: true,
            isEditableByMe: true,
          ),
          requestOptions: RequestOptions(path: '/v1/words/word1'),
        ),
      );

      final word = await repository.fetchWordById('word1');

      expect(word!.isSavedByMe, isTrue);
      expect(word.isEditableByMe, isTrue);
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

  group('言葉の保存', () {
    test('save は PUT /v1/words/{id}/save を呼ぶ', () async {
      when(mockWordsApi.v1WordsIdSavePut(id: 'word1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/v1/words/word1/save'),
        ),
      );

      await repository.save('word1');

      verify(mockWordsApi.v1WordsIdSavePut(id: 'word1')).called(1);
    });

    test('unsave は DELETE /v1/words/{id}/save を呼ぶ', () async {
      when(mockWordsApi.v1WordsIdSaveDelete(id: 'word1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/v1/words/word1/save'),
        ),
      );

      await repository.unsave('word1');

      verify(mockWordsApi.v1WordsIdSaveDelete(id: 'word1')).called(1);
    });
  });

  group('言葉の修正', () {
    test('update は PATCH の結果を Word に変換して返す', () async {
      when(
        mockWordsApi.v1WordsIdPatch(
          id: 'word1',
          updateWordRequest: anyNamed('updateWordRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: WordResponse(
            id: 'word1',
            word: '自由',
            reading: 'じゆう',
            readingSubGroup: 'さ行',
            publicDefinitionCount: 1,
            isSavedByMe: true,
            isEditableByMe: true,
          ),
          requestOptions: RequestOptions(path: '/v1/words/word1'),
        ),
      );

      final updated = await repository.update(
        wordId: 'word1',
        word: '自由',
        reading: 'じゆう',
      );

      final captured =
          verify(
                mockWordsApi.v1WordsIdPatch(
                  id: 'word1',
                  updateWordRequest: captureAnyNamed('updateWordRequest'),
                ),
              ).captured.single
              as UpdateWordRequest;
      expect(captured.word, '自由');
      expect(captured.reading, 'じゆう');
      expect(updated.word, '自由');
      expect(updated.isSavedByMe, isTrue);
      expect(updated.isEditableByMe, isTrue);
    });
  });
}
