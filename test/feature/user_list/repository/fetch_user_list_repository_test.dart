import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/feature/user_list/repository/fetch_user_list_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'fetch_user_list_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UsersApi>(), MockSpec<DefinitionsApi>()])
void main() {
  final usersApi = MockUsersApi();
  final definitionsApi = MockDefinitionsApi();
  final repository = FetchUserListRepository(usersApi, definitionsApi);

  tearDown(() {
    reset(usersApi);
    reset(definitionsApi);
  });

  final item = UserListItem(
    id: 'user-1',
    publicId: '123456789',
    name: 'ユーザー',
    avatarUrl: null,
    isFollowedByMe: false,
    isMutedByMe: false,
  );

  test('フォロー中一覧は following API の ID と cursor を返す', () async {
    when(
      usersApi.v1UsersIdFollowingGet(id: 'target', cursor: 'before', limit: 20),
    ).thenAnswer(
      (_) async => Response(
        data: V1UsersIdFollowersGet200Response(
          items: [item],
          nextCursor: 'after',
        ),
        requestOptions: RequestOptions(path: '/v1/users/target/following'),
      ),
    );

    final result = await repository.fetchFollowingIdList('target', 'before');

    expect(result.list, ['user-1']);
    expect(result.nextCursor, 'after');
    expect(result.hasMore, isTrue);
  });

  test('フォロワー一覧は followers API を使用する', () async {
    when(
      usersApi.v1UsersIdFollowersGet(id: 'target', cursor: null, limit: 20),
    ).thenAnswer(
      (_) async => Response(
        data: V1UsersIdFollowersGet200Response(items: [item], nextCursor: null),
        requestOptions: RequestOptions(path: '/v1/users/target/followers'),
      ),
    );

    final result = await repository.fetchFollowerIdList('target', null);

    expect(result.list, ['user-1']);
    expect(result.hasMore, isFalse);
  });

  test('いいねユーザー一覧は definitions likes API を使用する', () async {
    when(
      definitionsApi.v1DefinitionsIdLikesGet(
        id: 'definition-1',
        cursor: null,
        limit: 20,
      ),
    ).thenAnswer(
      (_) async => Response(
        data: V1UsersIdFollowersGet200Response(items: [item], nextCursor: null),
        requestOptions: RequestOptions(
          path: '/v1/definitions/definition-1/likes',
        ),
      ),
    );

    final result = await repository.fetchLikedUserIdList('definition-1', null);

    expect(result.list, ['user-1']);
  });

  test('DioException を ApiException に変換する', () async {
    final requestOptions = RequestOptions(path: '/v1/users/target/following');
    when(
      usersApi.v1UsersIdFollowingGet(id: 'target', cursor: null, limit: 20),
    ).thenThrow(DioException(requestOptions: requestOptions));

    expect(
      () => repository.fetchFollowingIdList('target', null),
      throwsA(isA<ApiException>()),
    );
  });
}
