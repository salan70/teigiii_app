import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition/application/definition_for_write_notifier.dart';
import 'package:teigi_app/feature/definition/domain/definition_for_write.dart';
import 'package:teigi_app/feature/definition/repository/write_definition_repository.dart';
import 'package:teigi_app/feature/word_list/application/user_dictionary_index_list_state.dart';
import 'package:teigi_app/feature/word_list/domain/word_list_state.dart';
import 'package:teigi_app/feature/word_list/repository/user_dictionary_word_repository.dart';

class _FakeWriteDefinitionRepository implements WriteDefinitionRepository {
  @override
  Future<String> createDefinition(DefinitionForWrite definitionForWrite) async {
    return 'new-definition-id';
  }

  @override
  Future<void> updateDefinition(DefinitionForWrite definitionForWrite) async {}

  @override
  Future<void> deleteDefinition(String definitionId) async {}

  @override
  Future<void> updatePostType({
    required String definitionId,
    required bool isPublic,
  }) async {}
}

class _FakeUserDictionaryWordRepository
    implements UserDictionaryWordRepository {
  int fetchMyDefinedWordsCallCount = 0;

  @override
  Future<WordListState> fetchMyDefinedWords(String? cursor) async {
    fetchMyDefinedWordsCallCount++;
    return const WordListState(
      list: [],
      nextCursor: null,
      hasMore: false,
    );
  }

  @override
  Future<WordListState> fetchUserDictionary(
    String userId,
    String? cursor,
  ) async {
    return const WordListState(
      list: [],
      nextCursor: null,
      hasMore: false,
    );
  }

  @override
  Future<WordListState> fetchMySavedWords(String? cursor) async {
    return const WordListState(
      list: [],
      nextCursor: null,
      hasMore: false,
    );
  }
}

void main() {
  const currentUserId = 'current-user';

  late ProviderContainer container;
  late _FakeUserDictionaryWordRepository userDictionaryRepository;

  setUp(() {
    userDictionaryRepository = _FakeUserDictionaryWordRepository();
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => currentUserId),
        writeDefinitionRepositoryProvider.overrideWithValue(
          _FakeWriteDefinitionRepository(),
        ),
        userDictionaryWordRepositoryProvider.overrideWithValue(
          userDictionaryRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  test('post 後に自分の辞書一覧が再取得される', () async {
    final dictionaryProvider =
        userDictionaryIndexListStateNotifierProvider(currentUserId);
    final subscription = container.listen(
      dictionaryProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await container.read(dictionaryProvider.future);
    expect(userDictionaryRepository.fetchMyDefinedWordsCallCount, 1);

    final notifier = container.read(
      definitionForWriteNotifierProvider(null).notifier,
    );
    await container.read(definitionForWriteNotifierProvider(null).future);
    notifier
      ..changeWord('二日目のカレー')
      ..changeWordReading('ふつかめのかれー')
      ..changeDefinition('作ってから一晩経ったカレー。');

    await notifier.post();
    await container.read(dictionaryProvider.future);

    expect(userDictionaryRepository.fetchMyDefinedWordsCallCount, 2);
  });
}
