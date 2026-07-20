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
  final api = MockDefinitionsApi();
  final repository = WriteDefinitionRepository(api);

  tearDown(() => reset(api));

  const definitionForWrite = DefinitionForWrite(
    id: 'definition1',
    authorId: 'user1',
    word: '二日目のカレー',
    wordReading: 'ふつかめのかれー',
    isPublic: true,
    definition: '作ってから一晩経ったカレー。',
  );

  DefinitionResponse response() => DefinitionResponse(
    id: 'definition1',
    word: WordSummary(id: 'word1', word: '二日目のカレー', reading: 'ふつかめのかれー'),
    author: UserSummary(
      id: 'user1',
      publicId: '123456789',
      name: 'テスト太郎',
      avatarUrl: null,
    ),
    body: definitionForWrite.definition,
    status: DefinitionStatus.public,
    isEdited: false,
    likesCount: 0,
    isLikedByMe: false,
    finalizedAt: DateTime.utc(2026, 7),
    editableUntil: DateTime.utc(2026, 7, 1, 1),
    createdAt: DateTime.utc(2026, 7),
    updatedAt: DateTime.utc(2026, 7),
  );

  test('本文と公開設定を PATCH する', () async {
    when(
      api.v1DefinitionsIdPatch(
        id: anyNamed('id'),
        updateDefinitionRequest: anyNamed('updateDefinitionRequest'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: response(),
        requestOptions: RequestOptions(path: '/v1/definitions/definition1'),
      ),
    );

    await repository.updateDefinition(definitionForWrite);

    final captured = verify(
      api.v1DefinitionsIdPatch(
        id: captureAnyNamed('id'),
        updateDefinitionRequest: captureAnyNamed('updateDefinitionRequest'),
      ),
    ).captured;
    expect(captured[0], 'definition1');
    final request = captured[1] as UpdateDefinitionRequest;
    expect(request.body, definitionForWrite.definition);
    expect(request.status, DefinitionStatus.public);
  });

  test('公開範囲だけを PATCH する', () async {
    when(
      api.v1DefinitionsIdPatch(
        id: anyNamed('id'),
        updateDefinitionRequest: anyNamed('updateDefinitionRequest'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: response(),
        requestOptions: RequestOptions(path: '/v1/definitions/definition1'),
      ),
    );

    await repository.updatePostType(
      definitionId: 'definition1',
      isPublic: false,
    );

    final request =
        verify(
              api.v1DefinitionsIdPatch(
                id: 'definition1',
                updateDefinitionRequest: captureAnyNamed(
                  'updateDefinitionRequest',
                ),
              ),
            ).captured.single
            as UpdateDefinitionRequest;
    expect(request.body, isNull);
    expect(request.status, DefinitionStatus.private);
  });

  test('DELETE /v1/definitions/{id} を呼ぶ', () async {
    when(api.v1DefinitionsIdDelete(id: anyNamed('id'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/v1/definitions/definition1'),
      ),
    );

    await repository.deleteDefinition('definition1');

    verify(api.v1DefinitionsIdDelete(id: 'definition1')).called(1);
  });

  test('削除エラーを ApiException に変換する', () async {
    final options = RequestOptions(path: '/v1/definitions/definition1');
    when(api.v1DefinitionsIdDelete(id: anyNamed('id'))).thenThrow(
      DioException(
        requestOptions: options,
        response: Response(
          statusCode: 403,
          data: {
            'error': {'code': 'forbidden', 'message': 'Forbidden'},
          },
          requestOptions: options,
        ),
      ),
    );

    await expectLater(
      repository.deleteDefinition('definition1'),
      throwsA(isA<ApiException>()),
    );
  });
}
