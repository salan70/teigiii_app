import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/definition/domain/definition_draft.dart';
import 'package:teigi_app/feature/definition/repository/definition_draft_repository.dart';
import 'package:teigi_app/feature/personal_dictionary/domain/personal_dictionary.dart';
import 'package:teigi_app/feature/personal_dictionary/repository/personal_dictionary_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'personal_dictionary_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MeApi>(), MockSpec<DefinitionDraftRepository>()])
void main() {
  final meApi = MockMeApi();
  final draftRepository = MockDefinitionDraftRepository();
  late PersonalDictionaryRepository repository;

  setUp(() {
    reset(meApi);
    reset(draftRepository);
    repository = PersonalDictionaryRepository(meApi, draftRepository);
  });

  test('overview の件数を専用モデルへ変換する', () async {
    when(meApi.v1MeDictionaryOverviewGet()).thenAnswer(
      (_) async => Response(
        data: MyDictionaryOverview(
          definedWordCount: 2,
          draftCount: 3,
          savedWordCount: 4,
          recentDefinitions: const [],
        ),
        requestOptions: RequestOptions(path: '/v1/me/dictionary/overview'),
      ),
    );

    final overview = await repository.fetchOverview();

    expect(overview.definedWordCount, 2);
    expect(overview.draftCount, 3);
    expect(overview.savedWordCount, 4);
    expect(overview.isEmpty, isFalse);
  });

  test('定義済みの言葉を件数付きで cursor pagination する', () async {
    when(
      meApi.v1MeDefinedWordsGet(
        cursor: anyNamed('cursor'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: V1MeDefinedWordsGet200Response(
          items: [
            DefinedWordItem(
              word: WordSummary(id: 'word-id', word: '言葉', reading: 'ことば'),
              publicCount: 2,
              privateCount: 1,
            ),
          ],
          nextCursor: 'next',
        ),
        requestOptions: RequestOptions(path: '/v1/me/defined-words'),
      ),
    );

    final page = await repository.fetchDefinedWords(cursor: 'cursor');

    expect(page.items.single.word, '言葉');
    expect(page.items.single.publicCount, 2);
    expect(page.items.single.privateCount, 1);
    expect(page.nextCursor, 'next');
  });

  test('Draft 一覧は専用 repository の cursor を維持する', () async {
    const draft = DefinitionDraft(
      id: 'draft-id',
      wordId: null,
      word: '',
      wordReading: '',
      isPublic: true,
      definition: '本文だけ',
      isPersisted: true,
    );
    when(
      draftRepository.list(cursor: 'cursor'),
    ).thenAnswer((_) async => (items: [draft], nextCursor: 'next'));

    final page = await repository.fetchDrafts(cursor: 'cursor');

    expect(page.items.single.displayLabel, '本文だけ');
    expect(page.nextCursor, 'next');
  });

  test('保存した言葉は自分の定義有無を保持する', () async {
    when(
      meApi.v1MeSavedWordsGet(
        cursor: anyNamed('cursor'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: V1MeSavedWordsGet200Response(
          items: [
            SavedWordItem(
              word: WordSummary(id: 'word-id', word: '言葉', reading: 'ことば'),
              isDefinedByMe: true,
            ),
          ],
          nextCursor: null,
        ),
        requestOptions: RequestOptions(path: '/v1/me/saved-words'),
      ),
    );

    final page = await repository.fetchSavedWords();

    expect(page.items.single.isDefinedByMe, isTrue);
    expect(page.hasMore, isFalse);
  });
}
