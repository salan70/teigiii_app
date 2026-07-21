import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';
import 'package:teigi_app/util/exception/database_exception.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'user_profile_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UsersApi>()])
void main() {
  final mockUsersApi = MockUsersApi();
  final repository = UserProfileRepository(mockUsersApi);

  tearDown(() => reset(mockUsersApi));

  final userResponse = UserResponse(
    id: 'user1',
    publicId: '123456789',
    name: 'テスト太郎',
    avatarUrl: 'https://api.example.com/v1/avatars/user1',
    bio: 'よろしく',
    publicDefinitionCount: 3,
    followingCount: 10,
    followerCount: 20,
    isFollowedByMe: true,
    isMutedByMe: false,
    createdAt: DateTime.utc(2026),
  );

  group('fetchUserProfile', () {
    test('UserResponse を UserProfile に変換して返す', () async {
      // * Arrange
      when(mockUsersApi.v1UsersIdGet(id: 'user1')).thenAnswer(
        (_) async => Response(
          data: userResponse,
          requestOptions: RequestOptions(path: '/v1/users/user1'),
        ),
      );

      // * Act
      final userProfile = await repository.fetchUserProfile('user1');

      // * Assert
      expect(
        userProfile,
        const UserProfile(
          id: 'user1',
          publicId: '123456789',
          name: 'テスト太郎',
          avatarUrl: 'https://api.example.com/v1/avatars/user1',
          bio: 'よろしく',
          publicDefinitionCount: 3,
          followingCount: 10,
          followerCount: 20,
          isFollowedByMe: true,
          croppedFile: null,
        ),
      );
    });

    test('avatarUrl が null の UserResponse をそのまま変換する', () async {
      // * Arrange
      when(mockUsersApi.v1UsersIdGet(id: 'user1')).thenAnswer(
        (_) async => Response(
          data: UserResponse(
            id: 'user1',
            publicId: '123456789',
            name: 'テスト太郎',
            avatarUrl: null,
            bio: 'よろしく',
            publicDefinitionCount: 3,
            followingCount: 10,
            followerCount: 20,
            isFollowedByMe: false,
            isMutedByMe: false,
            createdAt: DateTime.utc(2026),
          ),
          requestOptions: RequestOptions(path: '/v1/users/user1'),
        ),
      );

      // * Act
      final userProfile = await repository.fetchUserProfile('user1');

      // * Assert
      expect(userProfile.avatarUrl, isNull);
    });

    test('404 の場合 DatabaseException(notFound) を投げる', () async {
      // * Arrange
      final requestOptions = RequestOptions(path: '/v1/users/user1');
      when(mockUsersApi.v1UsersIdGet(id: 'user1')).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            statusCode: 404,
            data: {
              'error': {'code': 'user_not_found', 'message': 'User not found'},
            },
            requestOptions: requestOptions,
          ),
        ),
      );

      // * Act & Assert
      expect(
        () => repository.fetchUserProfile('user1'),
        throwsA(const DatabaseException(DatabaseExceptionCode.notFound)),
      );
    });
  });

  group('updateUserProfile', () {
    test('name と bio を UpdateMeRequest で PATCH する', () async {
      // * Arrange
      when(
        mockUsersApi.v1UsersMePatch(
          updateMeRequest: anyNamed('updateMeRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: MeResponse(
            id: 'user1',
            publicId: '123456789',
            name: '新しい名前',
            avatarUrl: null,
            bio: '新しい自己紹介',
            createdAt: DateTime.utc(2026),
          ),
          requestOptions: RequestOptions(path: '/v1/users/me'),
        ),
      );
      const userProfile = UserProfile(
        id: 'user1',
        publicId: '123456789',
        name: '新しい名前',
        avatarUrl: null,
        bio: '新しい自己紹介',
        followingCount: 0,
        followerCount: 0,
        isFollowedByMe: false,
        croppedFile: null,
      );

      // * Act
      await repository.updateUserProfile(userProfile);

      // * Assert
      final captured =
          verify(
                mockUsersApi.v1UsersMePatch(
                  updateMeRequest: captureAnyNamed('updateMeRequest'),
                ),
              ).captured.single
              as UpdateMeRequest;
      expect(captured.name, '新しい名前');
      expect(captured.bio, '新しい自己紹介');
    });
  });
}
