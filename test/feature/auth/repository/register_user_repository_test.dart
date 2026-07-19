import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/repository/register_user_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'register_user_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UsersApi>()])
void main() {
  final mockUsersApi = MockUsersApi();
  final repository = RegisterUserRepository(mockUsersApi);

  tearDown(() => reset(mockUsersApi));

  final meResponse = MeResponse(
    id: 'user1',
    publicId: '123456789',
    name: '新人さん',
    avatarUrl: null,
    bio: '',
    createdAt: DateTime.utc(2026),
  );

  group('initUser', () {
    test(
      'name / osVersion / appVersion を CreateUserRequest で POST する',
      () async {
        // * Arrange
        when(
          mockUsersApi.v1UsersPost(
            createUserRequest: anyNamed('createUserRequest'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: meResponse,
            requestOptions: RequestOptions(path: '/v1/users'),
          ),
        );

        // * Act
        await repository.initUser(
          name: '新人さん',
          osVersion: 'iOS 26.0',
          appVersion: '2.0.0',
        );

        // * Assert
        final captured =
            verify(
                  mockUsersApi.v1UsersPost(
                    createUserRequest: captureAnyNamed('createUserRequest'),
                  ),
                ).captured.single
                as CreateUserRequest;
        expect(captured.name, '新人さん');
        expect(captured.osVersion, 'iOS 26.0');
        expect(captured.appVersion, '2.0.0');
      },
    );
  });

  group('updateVersionInfo', () {
    test('osVersion / appVersion を UpdateMeRequest で PATCH する', () async {
      // * Arrange
      when(
        mockUsersApi.v1UsersMePatch(
          updateMeRequest: anyNamed('updateMeRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: meResponse,
          requestOptions: RequestOptions(path: '/v1/users/me'),
        ),
      );

      // * Act
      await repository.updateVersionInfo(
        osVersion: 'iOS 26.0',
        appVersion: '2.0.0',
      );

      // * Assert
      final captured =
          verify(
                mockUsersApi.v1UsersMePatch(
                  updateMeRequest: captureAnyNamed('updateMeRequest'),
                ),
              ).captured.single
              as UpdateMeRequest;
      expect(captured.osVersion, 'iOS 26.0');
      expect(captured.appVersion, '2.0.0');
      expect(captured.name, isNull);
      expect(captured.bio, isNull);
    });
  });

  group('deleteUser', () {
    test('DELETE /v1/users/me を呼ぶ', () async {
      // * Arrange
      when(mockUsersApi.v1UsersMeDelete()).thenAnswer(
        (_) async =>
            Response(requestOptions: RequestOptions(path: '/v1/users/me')),
      );

      // * Act
      await repository.deleteUser();

      // * Assert
      verify(mockUsersApi.v1UsersMeDelete()).called(1);
    });
  });
}
