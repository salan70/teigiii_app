import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/analytics/analytics_event.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../auth/application/auth_state.dart';
import '../../definition_list/appication/definition_id_list_state.dart';
import '../../word/application/word_state.dart';
import '../../word_list/application/community_dictionary_index_list_state.dart';
import '../../word_list/application/user_dictionary_index_list_state.dart';
import '../../word_list/application/word_list_state_by_initial.dart';
import '../../word_list/application/word_list_state_by_search_word.dart';
import '../domain/definition_for_write.dart';
import '../repository/write_definition_repository.dart';
import 'definition_state.dart';

part 'definition_for_write_notifier.g.dart';

/// 更新時などTextField等に初期表示したい値がある場合、
/// [definitionForWrite] として渡す。
@riverpod
class DefinitionForWriteNotifier extends _$DefinitionForWriteNotifier {
  @override
  FutureOr<DefinitionForWrite> build(
    DefinitionForWrite? definitionForWrite,
  ) async {
    if (definitionForWrite == null) {
      final currentUserId = ref.read(userIdProvider)!;
      _initialState = DefinitionForWrite.empty(currentUserId);
    } else {
      _initialState = definitionForWrite;
    }

    return _initialState;
  }

  /// 初期状態として渡された [DefinitionForWrite].
  /// 現在の状態と比較するために使用する。
  late final DefinitionForWrite _initialState;

  void changeWord(String word) {
    state = AsyncData(state.value!.copyWith(word: word));
  }

  void changeWordReading(String wordReading) {
    state = AsyncData(state.value!.copyWith(wordReading: wordReading));
  }

  void changePublicState({required bool isPublic}) {
    state = AsyncData(state.value!.copyWith(isPublic: isPublic));
  }

  void changeDefinition(String definition) {
    state = AsyncData(state.value!.copyWith(definition: definition));
  }

  /// 投稿し、投稿した定義のIdを返す。
  Future<String> post() async {
    final definitionForWrite = state.value!;
    final definitionId = await ref
        .read(writeDefinitionRepositoryProvider)
        .createDefinition(definitionForWrite);

    await ref
        .read(analyticsServiceProvider)
        .logEvent(
          AnalyticsEvent.definitionPosted,
          parameters: {
            AnalyticsParam.definitionId: definitionId,
            AnalyticsParam.isPublic: definitionForWrite.isPublic,
          },
        );

    ref
      ..invalidate(definitionIdListStateNotifierProvider)
      ..invalidate(wordListStateByInitialNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider)
      ..invalidate(userDictionaryIndexListStateNotifierProvider)
      ..invalidate(communityDictionaryIndexListStateNotifierProvider)
      ..invalidate(wordProvider);

    return definitionId;
  }

  Future<void> edit() async {
    final definitionForWrite = state.value!;
    await ref
        .read(writeDefinitionRepositoryProvider)
        .updateDefinition(definitionForWrite);

    await ref
        .read(analyticsServiceProvider)
        .logEvent(
          AnalyticsEvent.definitionUpdated,
          parameters: {
            AnalyticsParam.definitionId: definitionForWrite.id!,
            AnalyticsParam.isPublic: definitionForWrite.isPublic,
          },
        );

    ref
      ..invalidate(definitionProvider(definitionForWrite.id!))
      ..invalidate(definitionIdListStateNotifierProvider)
      ..invalidate(wordListStateByInitialNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider)
      ..invalidate(userDictionaryIndexListStateNotifierProvider)
      ..invalidate(communityDictionaryIndexListStateNotifierProvider)
      ..invalidate(wordProvider);
  }

  bool canPost() {
    return state.value!.isValidAllFields();
  }

  bool canEdit() {
    // canPost()を呼んだ方がいいかも
    return state.value!.isValidAllFields() && isChanged();
  }

  bool isChanged() {
    return state.value != _initialState;
  }
}
