import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/analytics/analytics_event.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../word_list/application/saved_word_list_state.dart';
import '../domain/word.dart';
import '../repository/word_repository.dart';

part 'word_save_controller.g.dart';

/// 楽観的更新用の保存状態オーバーライド（null = API 値を使用）。
@riverpod
class WordSavedOverrideNotifier extends _$WordSavedOverrideNotifier {
  @override
  bool? build(String wordId) => null;

  // ignore: use_setters_to_change_properties
  void set(bool? value) => state = value;
}

/// 保存操作の進行中フラグ。
@riverpod
class WordSaveInProgressNotifier extends _$WordSaveInProgressNotifier {
  @override
  bool build(String wordId) => false;

  // ignore: use_setters_to_change_properties
  void set({required bool value}) => state = value;
}

@riverpod
WordSaveController wordSaveController(WordSaveControllerRef ref) =>
    WordSaveController(ref);

/// 言葉の保存 / 解除を楽観的更新で制御するコントローラ。
class WordSaveController {
  WordSaveController(this.ref);

  final Ref ref;

  Future<void> toggle(Word word) async {
    if (ref.read(wordSaveInProgressNotifierProvider(word.id))) {
      return;
    }

    final override = ref.read(wordSavedOverrideNotifierProvider(word.id));
    final currentSaved = override ?? word.isSavedByMe;

    ref
        .read(wordSaveInProgressNotifierProvider(word.id).notifier)
        .set(value: true);
    ref
        .read(wordSavedOverrideNotifierProvider(word.id).notifier)
        .set(!currentSaved);

    try {
      if (currentSaved) {
        await ref.read(wordRepositoryProvider).unsave(word.id);
        await ref
            .read(analyticsServiceProvider)
            .logEvent(
              AnalyticsEvent.wordUnsaved,
              parameters: {AnalyticsParam.wordId: word.id},
            );
      } else {
        await ref.read(wordRepositoryProvider).save(word.id);
        await ref
            .read(analyticsServiceProvider)
            .logEvent(
              AnalyticsEvent.wordSaved,
              parameters: {AnalyticsParam.wordId: word.id},
            );
      }
      // keepAlive の保存一覧キャッシュを同期する。
      ref.invalidate(savedWordListStateNotifierProvider);
    } on Exception catch (_) {
      ref
          .read(wordSavedOverrideNotifierProvider(word.id).notifier)
          .set(currentSaved);
    } finally {
      ref
          .read(wordSaveInProgressNotifierProvider(word.id).notifier)
          .set(value: false);
    }
  }
}
