import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'user_config_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MeApi>(), MockSpec<UsersApi>()])
void main() {
  final mockMeApi = MockMeApi();
  final mockUsersApi = MockUsersApi();
  final repository = UserConfigRepository(mockMeApi, mockUsersApi);

  tearDown(() {
    reset(mockMeApi);
    reset(mockUsersApi);
  });

  UserListItem buildItem(String id) => UserListItem(
    id: id,
    publicId: '123456789',
    name: 'テスト太郎',
    avatarUrl: null,
    isFollowedByMe: false,
    isMutedByMe: true,
  );

  Response<V1UsersIdFollowersGet200Response> buildPage(
    List<String> ids,
    String? nextCursor,
  ) => Response(
    data: V1UsersIdFollowersGet200Response(
      items: ids.map(buildItem).toList(),
      nextCursor: nextCursor,
    ),
    requestOptions: RequestOptions(path: '/v1/me/mutes'),
  );

  group('fetchMutedUserIdList', () {
    test('nextCursor が尽きるまで走査して全ミュート ID を返す', () async {
      // * Arrange
      when(
        mockMeApi.v1MeMutesGet(limit: anyNamed('limit')),
      ).thenAnswer((_) async => buildPage(['a', 'b'], 'cursor1'));
      when(
        mockMeApi.v1MeMutesGet(cursor: 'cursor1', limit: anyNamed('limit')),
      ).thenAnswer((_) async => buildPage(['c'], null));

      // * Act
      final idList = await repository.fetchMutedUserIdList();

      // * Assert
      expect(idList, ['a', 'b', 'c']);
    });
  });

  group('appendMutedUserIdList', () {
    test('PUT /v1/users/{id}/mute を呼ぶ', () async {
      // * Arrange
      when(mockUsersApi.v1UsersIdMutePut(id: 'target1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/v1/users/target1/mute'),
        ),
      );

      // * Act
      await repository.appendMutedUserIdList('target1');

      // * Assert
      verify(mockUsersApi.v1UsersIdMutePut(id: 'target1')).called(1);
    });
  });

  group('removeMutedUserIdList', () {
    test('DELETE /v1/users/{id}/mute を呼ぶ', () async {
      // * Arrange
      when(mockUsersApi.v1UsersIdMuteDelete(id: 'target1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/v1/users/target1/mute'),
        ),
      );

      // * Act
      await repository.removeMutedUserIdList('target1');

      // * Assert
      verify(mockUsersApi.v1UsersIdMuteDelete(id: 'target1')).called(1);
    });
  });
}
