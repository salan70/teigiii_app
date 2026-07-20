import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/feature/definition/domain/definition_for_write.dart';
import 'package:teigi_app/feature/definition/repository/write_definition_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'write_definition_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WordsApi>(), MockSpec<DefinitionsApi>()])
void main() {
  final mockWordsApi = MockWordsApi();
  final mockDefinitionsApi = MockDefinitionsApi();
  final repository = WriteDefinitionRepository(
    mockWordsApi,
    mockDefinitionsApi,
  );

  tearDown(() {
    reset(mockWordsApi);
    reset(mockDefinitionsApi);
  });

  const definitionForWrite = DefinitionForWrite(
    id: 'definition1',
    authorId: 'user1',
    word: '二日目のカレー',
    wordReading: 'ふつかめのかれー',
    isPublic: true,
    definition: '作ってから一晩経ったカレー。',
  );

  WordResponse buildWordResponse(String wordId) {
    return WordResponse(
      id: wordId,
      word: '二日目のカレー',
      reading: 'ふつかめのかれー',
      readingSubGroup: 'は行',
      publicDefinitionCount: 0,
      isSavedByMe: false,
      isEditableByMe: true,
    );
  }

  DefinitionResponse buildDefinitionResponse(String definitionId) {
    return DefinitionResponse(
      id: definitionId,
      word: WordSummary(id: 'word1', word: '二日目のカレー', reading: 'ふつかめのかれー'),
      author: UserSummary(
        id: 'user1',
        publicId: '123456789',
        name: 'テスト太郎',
        avatarUrl: null,
      ),
      body: '作ってから一晩経ったカレー。',
      status: DefinitionStatus.public,
      isEdited: false,
      likesCount: 0,
      isLikedByMe: false,
      finalizedAt: DateTime.utc(2026, 7),
      editableUntil: DateTime.utc(2026, 7, 1, 1),
      createdAt: DateTime.utc(2026, 7),
      updatedAt: DateTime.utc(2026, 7),
    );
  }

  group('createDefinition', () {
    test('言葉を新規登録し、その id で定義を作成して定義 id を返す', () async {
      // * Arrange
      when(
        mockWordsApi.v1WordsPost(
          createWordRequest: anyNamed('createWordRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: buildWordResponse('word1'),
          requestOptions: RequestOptions(path: '/v1/words'),
        ),
      );
      when(
        mockDefinitionsApi.v1DefinitionsPost(
          createDefinitionRequest: anyNamed('createDefinitionRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: buildDefinitionResponse('definition1'),
          requestOptions: RequestOptions(path: '/v1/definitions'),
        ),
      );

      // * Act
      final definitionId = await repository.createDefinition(
        definitionForWrite,
      );

      // * Assert
      expect(definitionId, 'definition1');
      final capturedWordRequest =
          verify(
                mockWordsApi.v1WordsPost(
                  createWordRequest: captureAnyNamed('createWordRequest'),
                ),
              ).captured.single
              as CreateWordRequest;
      expect(capturedWordRequest.word, '二日目のカレー');
      expect(capturedWordRequest.reading, 'ふつかめのかれー');
      final capturedDefinitionRequest =
          verify(
                mockDefinitionsApi.v1DefinitionsPost(
                  createDefinitionRequest: captureAnyNamed(
                    'createDefinitionRequest',
                  ),
                ),
              ).captured.single
              as CreateDefinitionRequest;
      expect(capturedDefinitionRequest.wordId, 'word1');
      expect(capturedDefinitionRequest.body, '作ってから一晩経ったカレー。');
      expect(capturedDefinitionRequest.status, DefinitionStatus.public);
    });

    test('言葉が既存（409）の場合 existingWord.id で定義を作成する', () async {
      // * Arrange
      final requestOptions = RequestOptions(path: '/v1/words');
      when(
        mockWordsApi.v1WordsPost(
          createWordRequest: anyNamed('createWordRequest'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            statusCode: 409,
            data: {
              'error': {
                'code': 'word_already_exists',
                'message': 'Word already exists',
              },
              'existingWord': {
                'id': 'existingWord1',
                'word': '二日目のカレー',
                'reading': 'ふつかめのかれー',
              },
            },
            requestOptions: requestOptions,
          ),
        ),
      );
      when(
        mockDefinitionsApi.v1DefinitionsPost(
          createDefinitionRequest: anyNamed('createDefinitionRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: buildDefinitionResponse('definition1'),
          requestOptions: RequestOptions(path: '/v1/definitions'),
        ),
      );

      // * Act
      final definitionId = await repository.createDefinition(
        definitionForWrite,
      );

      // * Assert
      expect(definitionId, 'definition1');
      final capturedDefinitionRequest =
          verify(
                mockDefinitionsApi.v1DefinitionsPost(
                  createDefinitionRequest: captureAnyNamed(
                    'createDefinitionRequest',
                  ),
                ),
              ).captured.single
              as CreateDefinitionRequest;
      expect(capturedDefinitionRequest.wordId, 'existingWord1');
    });

    test('isPublic が false の場合 status が private になる', () async {
      // * Arrange
      when(
        mockWordsApi.v1WordsPost(
          createWordRequest: anyNamed('createWordRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: buildWordResponse('word1'),
          requestOptions: RequestOptions(path: '/v1/words'),
        ),
      );
      when(
        mockDefinitionsApi.v1DefinitionsPost(
          createDefinitionRequest: anyNamed('createDefinitionRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: buildDefinitionResponse('definition1'),
          requestOptions: RequestOptions(path: '/v1/definitions'),
        ),
      );

      // * Act
      await repository.createDefinition(
        definitionForWrite.copyWith(isPublic: false),
      );

      // * Assert
      final captured =
          verify(
                mockDefinitionsApi.v1DefinitionsPost(
                  createDefinitionRequest: captureAnyNamed(
                    'createDefinitionRequest',
                  ),
                ),
              ).captured.single
              as CreateDefinitionRequest;
      expect(captured.status, DefinitionStatus.private);
    });

    test('言葉登録が 409 以外で失敗した場合 ApiException を投げる', () async {
      // * Arrange
      final requestOptions = RequestOptions(path: '/v1/words');
      when(
        mockWordsApi.v1WordsPost(
          createWordRequest: anyNamed('createWordRequest'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            statusCode: 400,
            data: {
              'error': {'code': 'invalid_request', 'message': 'Invalid'},
            },
            requestOptions: requestOptions,
          ),
        ),
      );

      // * Act & Assert
      expect(
        () => repository.createDefinition(definitionForWrite),
        throwsA(isA<ApiException>()),
      );
      verifyNever(
        mockDefinitionsApi.v1DefinitionsPost(
          createDefinitionRequest: anyNamed('createDefinitionRequest'),
        ),
      );
    });
  });

  group('updateDefinition', () {
    test('本文と公開設定を PATCH する（言葉は変更しない）', () async {
      // * Arrange
      when(
        mockDefinitionsApi.v1DefinitionsIdPatch(
          id: anyNamed('id'),
          updateDefinitionRequest: anyNamed('updateDefinitionRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: buildDefinitionResponse('definition1'),
          requestOptions: RequestOptions(path: '/v1/definitions/definition1'),
        ),
      );

      // * Act
      await repository.updateDefinition(definitionForWrite);

      // * Assert
      final captured = verify(
        mockDefinitionsApi.v1DefinitionsIdPatch(
          id: captureAnyNamed('id'),
          updateDefinitionRequest: captureAnyNamed('updateDefinitionRequest'),
        ),
      ).captured;
      expect(captured[0], 'definition1');
      final request = captured[1] as UpdateDefinitionRequest;
      expect(request.wordId, isNull);
      expect(request.body, '作ってから一晩経ったカレー。');
      expect(request.status, DefinitionStatus.public);
    });
  });

  group('updatePostType', () {
    test('status のみを PATCH する', () async {
      // * Arrange
      when(
        mockDefinitionsApi.v1DefinitionsIdPatch(
          id: anyNamed('id'),
          updateDefinitionRequest: anyNamed('updateDefinitionRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: buildDefinitionResponse('definition1'),
          requestOptions: RequestOptions(path: '/v1/definitions/definition1'),
        ),
      );

      // * Act
      await repository.updatePostType(
        definitionId: 'definition1',
        isPublic: false,
      );

      // * Assert
      final captured = verify(
        mockDefinitionsApi.v1DefinitionsIdPatch(
          id: captureAnyNamed('id'),
          updateDefinitionRequest: captureAnyNamed('updateDefinitionRequest'),
        ),
      ).captured;
      expect(captured[0], 'definition1');
      final request = captured[1] as UpdateDefinitionRequest;
      expect(request.wordId, isNull);
      expect(request.body, isNull);
      expect(request.status, DefinitionStatus.private);
    });
  });

  group('deleteDefinition', () {
    test('DELETE /v1/definitions/{id} を呼ぶ', () async {
      // * Arrange
      when(
        mockDefinitionsApi.v1DefinitionsIdDelete(id: anyNamed('id')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/v1/definitions/definition1'),
        ),
      );

      // * Act
      await repository.deleteDefinition('definition1');

      // * Assert
      verify(mockDefinitionsApi.v1DefinitionsIdDelete(id: 'definition1'));
    });

    test('エラーの場合 ApiException を投げる', () async {
      // * Arrange
      final requestOptions = RequestOptions(
        path: '/v1/definitions/definition1',
      );
      when(
        mockDefinitionsApi.v1DefinitionsIdDelete(id: anyNamed('id')),
      ).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            statusCode: 403,
            data: {
              'error': {'code': 'forbidden', 'message': 'Forbidden'},
            },
            requestOptions: requestOptions,
          ),
        ),
      );

      // * Act & Assert
      expect(
        () => repository.deleteDefinition('definition1'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
