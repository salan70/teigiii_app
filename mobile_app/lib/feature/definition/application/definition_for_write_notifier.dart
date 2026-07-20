import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../definition_list/appication/definition_id_list_state.dart';
import '../../personal_dictionary/application/personal_dictionary_state.dart';
import '../../word/application/word_state.dart';
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
      throw ArgumentError('Editing requires an existing definition');
    }
    _initialState = definitionForWrite;
    return definitionForWrite;
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

  Future<void> edit() async {
    await ref
        .read(writeDefinitionRepositoryProvider)
        .updateDefinition(state.value!);

    ref
      ..invalidate(definitionProvider(state.value!.id!))
      ..invalidate(definitionIdListStateNotifierProvider)
      ..invalidate(definedWordListProvider)
      ..invalidate(personalDictionaryOverviewProvider)
      ..invalidate(wordListStateByInitialNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider)
      ..invalidate(wordProvider);
  }

  bool canEdit() {
    // canPost()を呼んだ方がいいかも
    return state.value!.isValidAllFields() && isChanged();
  }

  bool isChanged() {
    return state.value != _initialState;
  }
}
