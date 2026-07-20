import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/word/application/word_save_controller.dart';
import 'package:teigi_app/feature/word/domain/word.dart';
import 'package:teigi_app/feature/word/repository/word_repository.dart';

class _WordRepositoryStub implements WordRepository {
  _WordRepositoryStub({required this.onSave});

  final Future<void> Function(String wordId) onSave;

  @override
  Future<Word> create({required String word, required String reading}) =>
      throw UnimplementedError();

  @override
  Future<Word?> fetchWordById(String wordId) => throw UnimplementedError();

  @override
  Future<void> save(String wordId) => onSave(wordId);

  @override
  Future<void> unsave(String wordId) => throw UnimplementedError();

  @override
  Future<Word> update({
    required String wordId,
    required String word,
    required String reading,
  }) => throw UnimplementedError();
}

void main() {
  const word = Word(
    id: 'word-1',
    word: '自由',
    reading: 'じゆう',
    initialSubGroupLabel: 'さ行',
    postedDefinitionCount: 1,
  );

  test('保存状態を即時更新してから API を呼ぶ', () async {
    final completer = Completer<void>();
    final repository = _WordRepositoryStub(onSave: (_) => completer.future);
    final container = ProviderContainer(
      overrides: [wordRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final future = container.read(wordSaveControllerProvider).toggle(word);

    expect(container.read(wordSavedOverrideProvider('word-1')), isTrue);
    expect(container.read(wordSaveInProgressProvider('word-1')), isTrue);
    completer.complete();
    await future;
    expect(container.read(wordSaveInProgressProvider('word-1')), isFalse);
  });

  test('API 失敗時は保存表示を元に戻す', () async {
    final repository = _WordRepositoryStub(
      onSave: (_) => throw Exception('save failed'),
    );
    final container = ProviderContainer(
      overrides: [wordRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(wordSaveControllerProvider).toggle(word),
      throwsException,
    );

    expect(container.read(wordSavedOverrideProvider('word-1')), isFalse);
    expect(container.read(wordSaveInProgressProvider('word-1')), isFalse);
  });
}
