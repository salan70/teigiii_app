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
              readingSubGroup: 'か',
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
    expect(page.list.single.initialSubGroupLabel, 'か');
    expect(page.list.single.isSavedByMe, isTrue);
  });

  test('自分の定義済み言葉は API の readingSubGroup をマッピングする', () async {
    when(
      meApi.v1MeDefinedWordsGet(cursor: null, limit: anyNamed('limit')),
    ).thenAnswer(
      (_) async => Response(
        data: V1MeDefinedWordsGet200Response(
          items: [
            DefinedWordItem(
              word: WordSummary(id: 'w1', word: '朝', reading: 'あさ'),
              readingSubGroup: 'か',
              publicCount: 1,
              privateCount: 2,
            ),
          ],
          nextCursor: null,
        ),
        requestOptions: RequestOptions(path: '/v1/me/defined-words'),
      ),
    );

    final page = await repository.fetchMyDefinedWords(null);

    expect(page.list.single.initialSubGroupLabel, 'か');
  });

  test('他ユーザーの辞書は API の readingSubGroup をマッピングする', () async {
    when(
      usersApi.v1UsersIdDictionaryGet(
        id: 'user-1',
        cursor: null,
        limit: anyNamed('limit'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: V1UsersIdDictionaryGet200Response(
          items: [
            UserDictionaryItem(
              word: WordSummary(id: 'w1', word: '朝', reading: 'あさ'),
              readingSubGroup: 'か',
              publicCount: 3,
            ),
          ],
          nextCursor: null,
        ),
        requestOptions: RequestOptions(path: '/v1/users/user-1/dictionary'),
      ),
    );

    final page = await repository.fetchUserDictionary('user-1', null);

    expect(page.list.single.initialSubGroupLabel, 'か');
  });
}
