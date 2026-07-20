import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/domain/definition_draft.dart';
import 'package:teigi_app/feature/definition/repository/definition_draft_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'definition_draft_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DefinitionDraftsApi>()])
void main() {
  final api = MockDefinitionDraftsApi();
  final repository = DefinitionDraftRepository(api);
  const draft = DefinitionDraft(
    id: '00000000-0000-4000-8000-000000000001',
    wordId: null,
    word: '言葉',
    wordReading: '',
    isPublic: true,
    definition: '',
    isPersisted: false,
  );

  DefinitionDraftResponse response() => DefinitionDraftResponse(
    id: draft.id,
    wordId: null,
    word: '言葉',
    reading: '',
    body: '',
    visibility: DefinitionVisibility.public,
    finalizedDefinitionId: null,
    createdAt: DateTime.utc(2026, 7, 21),
    updatedAt: DateTime.utc(2026, 7, 21),
  );

  tearDown(() => reset(api));

  test('部分入力を同じクライアント生成 ID で保存する', () async {
    when(
      api.v1DefinitionDraftsIdPut(
        id: anyNamed('id'),
        putDefinitionDraftRequest: anyNamed('putDefinitionDraftRequest'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: response(),
        requestOptions: RequestOptions(
          path: '/v1/definition-drafts/${draft.id}',
        ),
      ),
    );

    final saved = await repository.save(draft);

    expect(saved.isPersisted, isTrue);
    final request =
        verify(
              api.v1DefinitionDraftsIdPut(
                id: draft.id,
                putDefinitionDraftRequest: captureAnyNamed(
                  'putDefinitionDraftRequest',
                ),
              ),
            ).captured.single
            as PutDefinitionDraftRequest;
    expect(request.word, '言葉');
    expect(request.reading, '');
    expect(request.body, '');
    expect(request.visibility, DefinitionVisibility.public);
  });

  test('よみ不一致の 409 は確認に必要な既存語を保持して返す', () async {
    final options = RequestOptions(
      path: '/v1/definition-drafts/${draft.id}/finalize',
    );
    when(
      api.v1DefinitionDraftsIdFinalizePost(
        id: anyNamed('id'),
        finalizeDefinitionDraftRequest: anyNamed(
          'finalizeDefinitionDraftRequest',
        ),
      ),
    ).thenThrow(
      DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 409,
          data: {
            'error': {
              'code': 'word_reading_mismatch',
              'message': 'Word reading differs',
            },
            'existingWord': {'id': 'word-id', 'word': '言葉', 'reading': 'ことのは'},
          },
        ),
      ),
    );

    await expectLater(
      repository.finalize(draft.id),
      throwsA(
        isA<WordReadingMismatchException>()
            .having((error) => error.word, 'word', '言葉')
            .having(
              (error) => error.existingReading,
              'existingReading',
              'ことのは',
            ),
      ),
    );
  });
}
