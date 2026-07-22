import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/analytics/analytics_event.dart';
import 'package:teigi_app/feature/word/application/word_save_controller.dart';
import 'package:teigi_app/feature/word/domain/word.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';

import '../../../mock/fake_analytics.dart';
import 'word_save_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WordRepository>()])
void main() {
  final mockWordRepository = MockWordRepository();
  late ProviderContainer container;
  late FakeAnalyticsClient fakeAnalytics;

  const word = Word(
    id: 'word-1',
    word: 'テスト',
    reading: 'てすと',
    initialSubGroupLabel: 'た行',
    postedDefinitionCount: 1,
  );

  setUp(() {
    fakeAnalytics = FakeAnalyticsClient();
    container = ProviderContainer(
      overrides: [
        wordRepositoryProvider.overrideWithValue(mockWordRepository),
        ...analyticsTestOverrides(fakeAnalytics),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() => reset(mockWordRepository));

  test('未保存 → 保存成功で word_saved を送る', () async {
    await container
        .read(wordSaveControllerProvider)
        .toggle(word.copyWith(isSavedByMe: false));

    verify(mockWordRepository.save(word.id)).called(1);
    expect(fakeAnalytics.loggedEvents.single.name, AnalyticsEvent.wordSaved);
  });

  test('保存済 → 解除成功で word_unsaved を送る', () async {
    await container
        .read(wordSaveControllerProvider)
        .toggle(word.copyWith(isSavedByMe: true));

    verify(mockWordRepository.unsave(word.id)).called(1);
    expect(fakeAnalytics.loggedEvents.single.name, AnalyticsEvent.wordUnsaved);
  });

  test('保存失敗時は analytics を送らない', () async {
    when(mockWordRepository.save(any)).thenThrow(Exception('fail'));

    await container
        .read(wordSaveControllerProvider)
        .toggle(word.copyWith(isSavedByMe: false));

    expect(fakeAnalytics.loggedEvents, isEmpty);
  });
}
