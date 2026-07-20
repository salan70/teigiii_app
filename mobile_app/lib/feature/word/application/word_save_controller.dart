import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/word.dart';
import '../repository/word_repository.dart';

final wordSavedOverrideProvider = StateProvider.family<bool?, String>(
  (ref, wordId) => null,
);

final wordSaveInProgressProvider = StateProvider.family<bool, String>(
  (ref, wordId) => false,
);

final wordSaveControllerProvider = Provider<WordSaveController>(
  WordSaveController.new,
);

class WordSaveController {
  WordSaveController(this.ref);

  final Ref ref;

  Future<void> toggle(Word word) async {
    final inProgress = ref.read(wordSaveInProgressProvider(word.id));
    if (inProgress) {
      return;
    }

    final savedState = ref.read(wordSavedOverrideProvider(word.id).notifier);
    final previous = savedState.state ?? word.isSavedByMe;
    final next = !previous;
    savedState.state = next;
    ref.read(wordSaveInProgressProvider(word.id).notifier).state = true;

    try {
      final repository = ref.read(wordRepositoryProvider);
      if (next) {
        await repository.save(word.id);
      } else {
        await repository.unsave(word.id);
      }
    } catch (_) {
      savedState.state = previous;
      rethrow;
    } finally {
      ref.read(wordSaveInProgressProvider(word.id).notifier).state = false;
    }
  }
}
