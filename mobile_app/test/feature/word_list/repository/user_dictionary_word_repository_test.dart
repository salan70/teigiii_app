import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/word_list/repository/user_dictionary_word_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'user_dictionary_word_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MeApi>(), MockSpec<UsersApi>()])
void main() {
  late MockMeApi meApi;
  late MockUsersApi usersApi;
  late UserDictionaryWordRepository repository;

  setUp(() {
    meApi = MockMeApi();
    usersApi = MockUsersApi();
    repository = UserDictionaryWordRepository(meApi, usersApi);
  });

  tearDown(() {
    reset(meApi);
    reset(usersApi);
  });

  test('保存した言葉は publicCount を投稿数としてマッピングする', () async {
    when(
      meApi.v1MeSavedWordsGet(cursor: null, limit: anyNamed('limit')),
    ).thenAnswer(
      (_) async => Response(
        data: V1MeSavedWordsGet200Response(
          items: [
            SavedWordItem(
              word: WordSummary(id: 'w1', word: '朝', reading: 'あさ'),
              isDefinedByMe: true,
              publicCount: 3,
            ),
          ],
          nextCursor: null,
        ),
        requestOptions: RequestOptions(path: '/v1/me/saved-words'),
      ),
    );

    final page = await repository.fetchMySavedWords(null);

    expect(page.list.single.postedDefinitionCount, 3);
    expect(page.list.single.isSavedByMe, isTrue);
  });
}
