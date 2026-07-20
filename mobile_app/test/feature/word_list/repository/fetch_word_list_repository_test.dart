import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/feature/community_dictionary/domain/community_dictionary.dart';
import 'package:teigi_app/feature/word/domain/word.dart';
import 'package:teigi_app/feature/word_list/repository/fetch_word_list_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'fetch_word_list_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WordsApi>(), MockSpec<SearchApi>()])
void main() {
  final wordsApi = MockWordsApi();
  final searchApi = MockSearchApi();
  final repository = FetchWordListRepository(wordsApi, searchApi);

  tearDown(() {
    reset(wordsApi);
    reset(searchApi);
  });

  final item = WordListItem(
    id: 'word-1',
    word: '余白',
    reading: 'よはく',
    readingSubGroup: 'や',
    publicDefinitionCount: 0,
  );

  test('行別一覧は定義0件の言葉も Word に変換する', () async {
    when(
      wordsApi.v1WordsGet(cursor: null, limit: 20, subGroup: 'や'),
    ).thenAnswer(
      (_) async => Response(
        data: V1WordsGet200Response(items: [item], nextCursor: 'next'),
        requestOptions: RequestOptions(path: '/v1/words'),
      ),
    );

    final result = await repository.fetchWordListStateByInitial('や', null);

    expect(result.list, const [
      Word(
        id: 'word-1',
        word: '余白',
        reading: 'よはく',
        initialSubGroupLabel: 'や',
        postedDefinitionCount: 0,
      ),
    ]);
    expect(result.nextCursor, 'next');
    expect(result.hasMore, isTrue);
  });

  test('みんなの辞書は filter、q、cursor を同じ一覧 API に渡す', () async {
    when(
      wordsApi.v1WordsGet(
        cursor: 'before',
        limit: 20,
        filter: 'defined',
        q: 'よは',
      ),
    ).thenAnswer(
      (_) async => Response(
        data: V1WordsGet200Response(items: [item], nextCursor: null),
        requestOptions: RequestOptions(path: '/v1/words'),
      ),
    );

    final result = await repository.fetchCommunityWordList(
      filter: CommunityWordFilter.defined,
      query: 'よは',
      cursor: 'before',
    );

    expect(result.list.single.id, 'word-1');
    expect(result.hasMore, isFalse);
  });

  test('検索は表記・よみ部分一致 API を使用する', () async {
    when(
      searchApi.v1SearchWordsGet(q: 'よは', cursor: 'before', limit: 20),
    ).thenAnswer(
      (_) async => Response(
        data: V1WordsGet200Response(items: [item], nextCursor: null),
        requestOptions: RequestOptions(path: '/v1/search/words'),
      ),
    );

    final result = await repository.fetchWordListStateBySearchWord(
      'よは',
      'before',
    );

    expect(result.list.single.id, 'word-1');
    expect(result.hasMore, isFalse);
  });

  test('DioException を ApiException に変換する', () async {
    final requestOptions = RequestOptions(path: '/v1/words');
    when(
      wordsApi.v1WordsGet(cursor: null, limit: 20, subGroup: 'や'),
    ).thenThrow(DioException(requestOptions: requestOptions));

    expect(
      () => repository.fetchWordListStateByInitial('や', null),
      throwsA(isA<ApiException>()),
    );
  });
}
