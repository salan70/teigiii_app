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

  UserListItem buildItem(String id) => UserListItem(
    id: id,
    publicId: '123456789',
    name: 'テスト太郎',
    avatarUrl: null,
    isFollowedByMe: true,
    isMutedByMe: false,
  );

  Response<V1UsersIdFollowersGet200Response> buildPage(
    List<String> ids,
    String? nextCursor,
  ) => Response(
    data: V1UsersIdFollowersGet200Response(
      items: ids.map(buildItem).toList(),
      nextCursor: nextCursor,
    ),
    requestOptions: RequestOptions(path: '/v1/users/user1/following'),
  );

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

  group('fetchAllFollowingIdList', () {
    test('nextCursor が尽きるまで走査して全 ID を返す', () async {
      // * Arrange
      when(
        mockUsersApi.v1UsersIdFollowingGet(
          id: 'user1',
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => buildPage(['a', 'b'], 'cursor1'));
      when(
        mockUsersApi.v1UsersIdFollowingGet(
          id: 'user1',
          cursor: 'cursor1',
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => buildPage(['c'], null));

      // * Act
      final idList = await repository.fetchAllFollowingIdList('user1');

      // * Assert
      expect(idList, ['a', 'b', 'c']);
    });
  });
}
