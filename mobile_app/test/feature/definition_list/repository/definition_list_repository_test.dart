import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/feature/definition_list/repository/definition_list_repository.dart';
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart';
import 'package:teigi_app/util/constant/initial_main_group.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'definition_list_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TimelineApi>(),
  MockSpec<WordsApi>(),
  MockSpec<UsersApi>(),
])
void main() {
  final timelineApi = MockTimelineApi();
  final wordsApi = MockWordsApi();
  final usersApi = MockUsersApi();
  final repository = DefinitionListRepository(timelineApi, wordsApi, usersApi);

  tearDown(() {
    reset(timelineApi);
    reset(wordsApi);
    reset(usersApi);
  });

  DefinitionResponse definition(String id) => DefinitionResponse(
    id: id,
    word: WordSummary(id: 'word', word: '言葉', reading: 'ことば'),
    author: UserSummary(
      id: 'author',
      publicId: '123456789',
      name: '著者',
      avatarUrl: null,
    ),
    body: '本文',
    status: DefinitionStatus.public,
    isEdited: false,
    likesCount: 0,
    isLikedByMe: false,
    finalizedAt: DateTime.utc(2026),
    editableUntil: DateTime.utc(2026, 1, 1, 1),
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );

  test('discover は定義タイプを指定して1ページの定義本体を返す', () async {
    when(
      timelineApi.v1TimelineDiscoverGet(
        cursor: null,
        limit: 20,
        type: 'definition',
      ),
    ).thenAnswer(
      (_) async => Response(
        data: V1TimelineDiscoverGet200Response(
          items: [
            DiscoverFeedDefinitionItem(
              DefinitionActivity(
                type: DefinitionActivityTypeEnum.definition,
                occurredAt: DateTime.utc(2026),
                definition: definition('definition-1'),
              ),
            ),
            DiscoverFeedWordRegisteredItem(
              WordRegisteredActivity(
                type: WordRegisteredActivityTypeEnum.wordRegistered,
                occurredAt: DateTime.utc(2026),
                word: WordSummary(id: 'word', word: '言葉', reading: 'ことば'),
              ),
            ),
          ],
          nextCursor: 'cursor-1',
        ),
        requestOptions: RequestOptions(path: '/v1/timeline/discover'),
      ),
    );

    final result = await repository.fetchForHomeRecommend(null);

    expect(result.list.map((definition) => definition.id), ['definition-1']);
    expect(result.nextCursor, 'cursor-1');
    expect(result.hasMore, isTrue);
  });

  test('フォロー中は API の cursor を引き継ぐ', () async {
    when(
      timelineApi.v1TimelineFollowingGet(cursor: 'before', limit: 20),
    ).thenAnswer(
      (_) async => Response(
        data: V1UsersIdDefinitionsGet200Response(
          items: [definition('definition-1')],
          nextCursor: 'after',
        ),
        requestOptions: RequestOptions(path: '/v1/timeline/following'),
      ),
    );

    final result = await repository.fetchForHomeFollowing('before');

    expect(result.list.map((definition) => definition.id), ['definition-1']);
    expect(result.nextCursor, 'after');
    expect(result.hasMore, isTrue);
  });

  test('言葉トップのリアクション順を API パラメータへ変換する', () async {
    when(
      wordsApi.v1WordsIdDefinitionsGet(
        id: 'word-1',
        cursor: null,
        limit: 20,
        scope: 'all',
        sort: 'reactions',
      ),
    ).thenAnswer(
      (_) async => Response(
        data: V1UsersIdDefinitionsGet200Response(
          items: [definition('definition-1')],
          nextCursor: null,
        ),
        requestOptions: RequestOptions(path: '/v1/words/word-1/definitions'),
      ),
    );

    final result = await repository.fetchForWordTop(
      WordTopOrderByType.likesCount,
      'word-1',
      null,
    );

    expect(result.list.map((definition) => definition.id), ['definition-1']);
  });

  test('個人辞書は読みグループと reading 順を指定する', () async {
    when(
      usersApi.v1UsersIdDefinitionsGet(
        id: 'user-1',
        cursor: null,
        limit: 20,
        subGroup: InitialSubGroup.a.label,
        sort: 'reading',
      ),
    ).thenAnswer(
      (_) async => Response(
        data: V1UsersIdDefinitionsGet200Response(
          items: [definition('definition-1')],
          nextCursor: null,
        ),
        requestOptions: RequestOptions(path: '/v1/users/user-1/definitions'),
      ),
    );

    final result = await repository.fetchForIndividualDictionary(
      'user-1',
      InitialSubGroup.a,
      null,
    );

    expect(result.list.map((definition) => definition.id), ['definition-1']);
  });

  test('言葉単位の自分の定義一覧は wordId と newest を指定する', () async {
    when(
      usersApi.v1UsersIdDefinitionsGet(
        id: 'user-1',
        cursor: null,
        limit: 20,
        wordId: 'word-1',
        sort: 'newest',
      ),
    ).thenAnswer(
      (_) async => Response(
        data: V1UsersIdDefinitionsGet200Response(
          items: [definition('definition-1'), definition('definition-2')],
          nextCursor: null,
        ),
        requestOptions: RequestOptions(path: '/v1/users/user-1/definitions'),
      ),
    );

    final result = await repository.fetchForUserWord('user-1', 'word-1', null);

    expect(result.list.map((definition) => definition.id), [
      'definition-1',
      'definition-2',
    ]);
    expect(result.hasMore, isFalse);
  });

  test('DioException を ApiException に変換する', () async {
    final requestOptions = RequestOptions(path: '/v1/timeline/following');
    when(
      timelineApi.v1TimelineFollowingGet(cursor: null, limit: 20),
    ).thenThrow(DioException(requestOptions: requestOptions));

    expect(
      () => repository.fetchForHomeFollowing(null),
      throwsA(isA<ApiException>()),
    );
  });
}
