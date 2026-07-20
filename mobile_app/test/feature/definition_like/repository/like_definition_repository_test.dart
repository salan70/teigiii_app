import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/feature/definition_like/repository/like_definition_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'like_definition_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DefinitionsApi>()])
void main() {
  final mockDefinitionsApi = MockDefinitionsApi();
  final repository = LikeDefinitionRepository(mockDefinitionsApi);

  tearDown(() => reset(mockDefinitionsApi));

  group('likeDefinition', () {
    test('PUT /v1/definitions/{id}/like を呼ぶ', () async {
      // * Arrange
      when(
        mockDefinitionsApi.v1DefinitionsIdLikePut(id: 'definition1'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: '/v1/definitions/definition1/like',
          ),
        ),
      );

      // * Act
      await repository.likeDefinition('definition1');

      // * Assert
      verify(
        mockDefinitionsApi.v1DefinitionsIdLikePut(id: 'definition1'),
      ).called(1);
    });

    test('エラーの場合 ApiException を投げる', () async {
      // * Arrange
      final requestOptions = RequestOptions(
        path: '/v1/definitions/definition1/like',
      );
      when(
        mockDefinitionsApi.v1DefinitionsIdLikePut(id: 'definition1'),
      ).thenThrow(
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
        () => repository.likeDefinition('definition1'),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('unlikeDefinition', () {
    test('DELETE /v1/definitions/{id}/like を呼ぶ', () async {
      // * Arrange
      when(
        mockDefinitionsApi.v1DefinitionsIdLikeDelete(id: 'definition1'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: '/v1/definitions/definition1/like',
          ),
        ),
      );

      // * Act
      await repository.unlikeDefinition('definition1');

      // * Assert
      verify(
        mockDefinitionsApi.v1DefinitionsIdLikeDelete(id: 'definition1'),
      ).called(1);
    });

    test('エラーの場合 ApiException を投げる', () async {
      // * Arrange
      final requestOptions = RequestOptions(
        path: '/v1/definitions/definition1/like',
      );
      when(
        mockDefinitionsApi.v1DefinitionsIdLikeDelete(id: 'definition1'),
      ).thenThrow(
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
        () => repository.unlikeDefinition('definition1'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
