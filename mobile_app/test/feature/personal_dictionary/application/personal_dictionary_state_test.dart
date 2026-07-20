import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/personal_dictionary/application/personal_dictionary_state.dart';
import 'package:teigi_app/feature/personal_dictionary/domain/personal_dictionary.dart';
import 'package:teigi_app/feature/personal_dictionary/repository/personal_dictionary_repository.dart';

import 'personal_dictionary_state_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PersonalDictionaryRepository>()])
void main() {
  final repository = MockPersonalDictionaryRepository();
  late ProviderContainer container;

  setUp(() {
    reset(repository);
    container = ProviderContainer(
      overrides: [
        personalDictionaryRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('定義済み一覧は初回取得後に nextCursor を使って連結する', () async {
    const first = DefinedWord(
      id: 'word-1',
      word: '一',
      reading: 'いち',
      publicCount: 1,
      privateCount: 0,
    );
    const second = DefinedWord(
      id: 'word-2',
      word: '二',
      reading: 'に',
      publicCount: 0,
      privateCount: 1,
    );
    when(repository.fetchDefinedWords()).thenAnswer(
      (_) async => const PagedItems(items: [first], nextCursor: 'next'),
    );
    when(repository.fetchDefinedWords(cursor: 'next')).thenAnswer(
      (_) async => const PagedItems(items: [second], nextCursor: null),
    );

    expect((await container.read(definedWordListProvider.future)).items, [
      first,
    ]);
    await container.read(definedWordListProvider.notifier).fetchMore();

    final result = container.read(definedWordListProvider).requireValue;
    expect(result.items, [first, second]);
    expect(result.hasMore, isFalse);
  });

  test('追加取得に失敗しても取得済みの一覧を保持する', () async {
    const first = DefinedWord(
      id: 'word-1',
      word: '一',
      reading: 'いち',
      publicCount: 1,
      privateCount: 0,
    );
    when(repository.fetchDefinedWords()).thenAnswer(
      (_) async => const PagedItems(items: [first], nextCursor: 'next'),
    );
    when(
      repository.fetchDefinedWords(cursor: 'next'),
    ).thenThrow(Exception('network error'));

    await container.read(definedWordListProvider.future);
    await container.read(definedWordListProvider.notifier).fetchMore();

    final result = container.read(definedWordListProvider);
    expect(result.hasError, isTrue);
    expect(result.valueOrNull?.items, [first]);
  });
}
