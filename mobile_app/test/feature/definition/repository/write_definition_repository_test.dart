import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/feature/definition/domain/definition_for_write.dart';
import 'package:teigi_app/feature/definition/repository/write_definition_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'write_definition_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DefinitionsApi>()])
void main() {
  final mockDefinitionsApi = MockDefinitionsApi();
  final repository = WriteDefinitionRepository(mockDefinitionsApi);

  tearDown(() {
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
    test('word + reading で定義を作成し、定義 id を返す', () async {
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

      final definitionId = await repository.createDefinition(
        definitionForWrite,
      );

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
      expect(capturedDefinitionRequest.wordId, isNull);
      expect(capturedDefinitionRequest.word, '二日目のカレー');
      expect(capturedDefinitionRequest.reading, 'ふつかめのかれー');
      expect(capturedDefinitionRequest.body, '作ってから一晩経ったカレー。');
      expect(capturedDefinitionRequest.status, DefinitionStatus.public);
    });

    test('isPublic が false の場合 status が private になる', () async {
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

      await repository.createDefinition(
        definitionForWrite.copyWith(isPublic: false),
      );

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

    test('定義作成が失敗した場合 ApiException を投げる', () async {
      final requestOptions = RequestOptions(path: '/v1/definitions');
      when(
        mockDefinitionsApi.v1DefinitionsPost(
          createDefinitionRequest: anyNamed('createDefinitionRequest'),
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

      expect(
        () => repository.createDefinition(definitionForWrite),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('updateDefinition', () {
    test('本文と公開設定を PATCH する（言葉は変更しない）', () async {
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

      await repository.updateDefinition(definitionForWrite);

      final captured = verify(
        mockDefinitionsApi.v1DefinitionsIdPatch(
          id: captureAnyNamed('id'),
          updateDefinitionRequest: captureAnyNamed('updateDefinitionRequest'),
        ),
      ).captured;
      expect(captured[0], 'definition1');
      final request = captured[1] as UpdateDefinitionRequest;
      expect(request.body, '作ってから一晩経ったカレー。');
      expect(request.status, DefinitionStatus.public);
    });
  });

  group('updatePostType', () {
    test('status のみを PATCH する', () async {
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

      await repository.updatePostType(
        definitionId: 'definition1',
        isPublic: false,
      );

      final captured = verify(
        mockDefinitionsApi.v1DefinitionsIdPatch(
          id: captureAnyNamed('id'),
          updateDefinitionRequest: captureAnyNamed('updateDefinitionRequest'),
        ),
      ).captured;
      expect(captured[0], 'definition1');
      final request = captured[1] as UpdateDefinitionRequest;
      expect(request.body, isNull);
      expect(request.status, DefinitionStatus.private);
    });
  });

  group('deleteDefinition', () {
    test('DELETE /v1/definitions/{id} を呼ぶ', () async {
      when(
        mockDefinitionsApi.v1DefinitionsIdDelete(id: anyNamed('id')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/v1/definitions/definition1'),
        ),
      );

      await repository.deleteDefinition('definition1');

      verify(mockDefinitionsApi.v1DefinitionsIdDelete(id: 'definition1'));
    });

    test('エラーの場合 ApiException を投げる', () async {
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

      expect(
        () => repository.deleteDefinition('definition1'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
