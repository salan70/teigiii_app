import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/repository/fetch_definition_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'fetch_definition_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DefinitionsApi>()])
void main() {
  final mockDefinitionsApi = MockDefinitionsApi();
  final repository = FetchDefinitionRepository(mockDefinitionsApi);

  tearDown(() => reset(mockDefinitionsApi));

  DefinitionResponse buildDefinitionResponse({
    required DefinitionStatus status,
    required bool isLikedByMe,
  }) {
    return DefinitionResponse(
      id: 'definition1',
      word: WordSummary(id: 'word1', word: '二日目のカレー', reading: 'ふつかめのかれー'),
      author: UserSummary(
        id: 'user1',
        publicId: '123456789',
        name: 'テスト太郎',
        avatarUrl: 'https://api.example.com/v1/avatars/user1',
      ),
      body: '作ってから一晩経ったカレー。',
      status: status,
      isEdited: false,
      likesCount: 5,
      isLikedByMe: isLikedByMe,
      finalizedAt: DateTime.utc(2026, 7),
      editableUntil: DateTime.utc(2026, 7, 1, 1),
      createdAt: DateTime.utc(2026, 7),
      updatedAt: DateTime.utc(2026, 7),
    );
  }

  group('fetchDefinition', () {
    test('DefinitionResponse を Definition に変換して返す', () async {
      // * Arrange
      when(mockDefinitionsApi.v1DefinitionsIdGet(id: 'definition1')).thenAnswer(
        (_) async => Response(
          data: buildDefinitionResponse(
            status: DefinitionStatus.public,
            isLikedByMe: true,
          ),
          requestOptions: RequestOptions(path: '/v1/definitions/definition1'),
        ),
      );

      // * Act
      final definition = await repository.fetchDefinition('definition1');

      // * Assert
      expect(
        definition,
        Definition(
          id: 'definition1',
          wordId: 'word1',
          word: '二日目のカレー',
          wordReading: 'ふつかめのかれー',
          authorId: 'user1',
          authorName: 'テスト太郎',
          authorImageUrl: 'https://api.example.com/v1/avatars/user1',
          definition: '作ってから一晩経ったカレー。',
          isPublic: true,
          likesCount: 5,
          isLikedByUser: true,
          editableUntil: DateTime.utc(2026, 7, 1, 1),
          createdAt: DateTime.utc(2026, 7),
        ),
      );
    });

    test('status が private の場合 isPublic が false になる', () async {
      // * Arrange
      when(mockDefinitionsApi.v1DefinitionsIdGet(id: 'definition1')).thenAnswer(
        (_) async => Response(
          data: buildDefinitionResponse(
            status: DefinitionStatus.private,
            isLikedByMe: false,
          ),
          requestOptions: RequestOptions(path: '/v1/definitions/definition1'),
        ),
      );

      // * Act
      final definition = await repository.fetchDefinition('definition1');

      // * Assert
      expect(definition.isPublic, isFalse);
      expect(definition.isLikedByUser, isFalse);
    });

    test('エラーの場合 ApiException を投げる', () async {
      // * Arrange
      final requestOptions = RequestOptions(
        path: '/v1/definitions/definition1',
      );
      when(mockDefinitionsApi.v1DefinitionsIdGet(id: 'definition1')).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            statusCode: 404,
            data: {
              'error': {
                'code': 'definition_not_found',
                'message': 'Definition not found',
              },
            },
            requestOptions: requestOptions,
          ),
        ),
      );

      // * Act & Assert
      expect(
        () => repository.fetchDefinition('definition1'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
