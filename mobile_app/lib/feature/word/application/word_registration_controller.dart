import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../timeline/application/discover_timeline_state.dart';
import '../../word_list/application/community_dictionary_index_list_state.dart';
import '../../word_list/application/word_list_state_by_search_word.dart';
import '../domain/word_registration.dart';
import '../repository/word_repository.dart';

part 'word_registration_controller.g.dart';

@riverpod
WordRegistrationController wordRegistrationController(
  WordRegistrationControllerRef ref,
) => WordRegistrationController(ref);

/// 言葉の明示登録を実行するコントローラ。
class WordRegistrationController {
  WordRegistrationController(this.ref);

  final Ref ref;

  /// [word] と [reading] の言葉を明示登録する。
  ///
  /// 一覧の再取得は、実際に見え方が変わる結果のときだけ行う。
  Future<WordRegistration> register({
    required String word,
    required String reading,
  }) async {
    final registration = await ref
        .read(wordRepositoryProvider)
        .create(word: word, reading: reading);

    if (registration.outcome != WordRegistrationOutcome.alreadyPublic) {
      ref
        ..invalidate(communityDictionaryIndexListStateNotifierProvider)
        ..invalidate(discoverTimelineStateNotifierProvider)
        ..invalidate(wordListStateBySearchWordNotifierProvider);
    }
    return registration;
  }
}
