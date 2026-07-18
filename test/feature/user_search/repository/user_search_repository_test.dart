import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/user_search/repository/user_search_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'user_search_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SearchApi>()])
void main() {
  final mockSearchApi = MockSearchApi();
  final repository = UserSearchRepository(mockSearchApi);

  tearDown(() => reset(mockSearchApi));

  UserListItem buildItem(String id, String publicId) => UserListItem(
    id: id,
    publicId: publicId,
    name: 'テスト太郎',
    avatarUrl: null,
    isFollowedByMe: false,
    isMutedByMe: false,
  );

  Response<V1UsersIdFollowersGet200Response> buildResponse(
    List<UserListItem> items,
  ) => Response(
    data: V1UsersIdFollowersGet200Response(items: items, nextCursor: null),
    requestOptions: RequestOptions(path: '/v1/search/users'),
  );

  group('searchByPublicId', () {
    test('publicId が完全一致するユーザーの userId を返す', () async {
      // * Arrange
      // サーバーは部分一致検索のため、前方部分一致のユーザーも混ざって返る
      when(mockSearchApi.v1SearchUsersGet(q: '123456789')).thenAnswer(
        (_) async => buildResponse([
          buildItem('userA', '123456789'),
          buildItem('userB', '1234567890'),
        ]),
      );

      // * Act
      final userId = await repository.searchByPublicId('123456789');

      // * Assert
      expect(userId, 'userA');
    });

    test('完全一致するユーザーがいない場合 null を返す', () async {
      // * Arrange
      when(mockSearchApi.v1SearchUsersGet(q: '999999999')).thenAnswer(
        (_) async => buildResponse([buildItem('userB', '9999999990')]),
      );

      // * Act
      final userId = await repository.searchByPublicId('999999999');

      // * Assert
      expect(userId, isNull);
    });
  });
}
