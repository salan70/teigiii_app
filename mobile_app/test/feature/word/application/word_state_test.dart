import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/word/application/word_state.dart';
import 'package:teigi_app/feature/word/domain/word.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';

import 'word_state_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WordRepository>()])
void main() {
  test('公開定義0件の言葉も言葉ページで取得できる', () async {
    final repository = MockWordRepository();
    const word = Word(
      id: 'word-1',
      word: '自由',
      reading: 'じゆう',
      initialSubGroupLabel: 'さ行',
      postedDefinitionCount: 0,
    );
    when(repository.fetchWordById('word-1')).thenAnswer((_) async => word);
    final container = ProviderContainer(
      overrides: [wordRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final result = await container.read(wordProvider('word-1').future);

    expect(result, word);
  });
}
