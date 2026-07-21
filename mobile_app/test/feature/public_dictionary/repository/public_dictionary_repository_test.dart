import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/public_dictionary/repository/public_dictionary_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'public_dictionary_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UsersApi>()])
void main() {
  final usersApi = MockUsersApi();
  final repository = PublicDictionaryRepository(usersApi);

  tearDown(() => reset(usersApi));

  test('公開辞書を言葉単位の一覧状態へ変換する', () async {
    when(
      usersApi.v1UsersIdDictionaryGet(id: 'user-1', cursor: 'before'),
    ).thenAnswer(
      (_) async => Response(
        data: V1UsersIdDictionaryGet200Response(
          items: [
            UserDictionaryItem(
              word: WordSummary(id: 'word-1', word: '余白', reading: 'よはく'),
              publicCount: 2,
            ),
          ],
          nextCursor: 'next',
        ),
        requestOptions: RequestOptions(path: '/v1/users/user-1/dictionary'),
      ),
    );

    final result = await repository.fetch('user-1', 'before');

    expect(result.list.single.word.id, 'word-1');
    expect(result.list.single.publicDefinitionCount, 2);
    expect(result.nextCursor, 'next');
    expect(result.hasMore, isTrue);
  });
}
