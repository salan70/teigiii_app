import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/user_follow/repository/user_follow_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'user_follow_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UsersApi>()])
void main() {
  final mockUsersApi = MockUsersApi();
  final repository = UserFollowRepository(mockUsersApi);

  tearDown(() => reset(mockUsersApi));

  group('follow', () {
    test('PUT /v1/users/{id}/follow を呼ぶ', () async {
      // * Arrange
      when(mockUsersApi.v1UsersIdFollowPut(id: 'target1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/v1/users/target1/follow'),
        ),
      );

      // * Act
      await repository.follow('target1');

      // * Assert
      verify(mockUsersApi.v1UsersIdFollowPut(id: 'target1')).called(1);
    });
  });

  group('unfollow', () {
    test('DELETE /v1/users/{id}/follow を呼ぶ', () async {
      // * Arrange
      when(mockUsersApi.v1UsersIdFollowDelete(id: 'target1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/v1/users/target1/follow'),
        ),
      );

      // * Act
      await repository.unfollow('target1');

      // * Assert
      verify(mockUsersApi.v1UsersIdFollowDelete(id: 'target1')).called(1);
    });
  });
}
