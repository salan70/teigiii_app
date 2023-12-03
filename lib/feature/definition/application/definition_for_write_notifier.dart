import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../definition_list/appication/definition_id_list_state.dart';
import '../../word/application/word_state.dart';
import '../../word/repository/word_repository.dart';
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
    final definitionId = await _executeCreate();

    ref
      ..invalidate(definitionIdListStateNotifierProvider)
      ..invalidate(wordListStateByInitialNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider)
      ..invalidate(wordProvider);

    return definitionId;
  }

  Future<String> _executeCreate() async {
    final definitionForWrite = state.value!;

    final existingCurrentWordId =
        await ref.read(wordRepositoryProvider).findWordId(
              definitionForWrite.trimmedWord,
              definitionForWrite.trimmedWordReading,
            );

    // Word ドキュメントを新たに作成する必要があるかを判定する。
    if (existingCurrentWordId == null) {
      // * 必要ある場合
      return ref
          .read(writeDefinitionRepositoryProvider)
          .createDefinitionAndWord(
            definitionForWrite,
          );
    }

    // * 必要ない場合
    return ref.read(writeDefinitionRepositoryProvider).createDefinition(
          definitionForWrite,
          existingCurrentWordId,
        );
  }

  Future<void> edit() async {
    await _executeUpdate();

    ref
      ..invalidate(definitionProvider(state.value!.id!))
      ..invalidate(definitionIdListStateNotifierProvider)
      ..invalidate(wordListStateByInitialNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider)
      ..invalidate(wordProvider);
  }

  Future<void> _executeUpdate() async {
    final definitionForWrite = state.value!;

    // 編集前の wordId。
    final previousWordId = await ref
        .read(wordRepositoryProvider)
        .findWordId(_initialState.word, _initialState.wordReading);
    if (previousWordId == null) {
      throw Exception('編集前のwordIdがnullです');
    }

    // 編集後のwordId。 initialWordId と同じ可能性あり
    final existingNewWordId = await ref.read(wordRepositoryProvider).findWordId(
          definitionForWrite.trimmedWord,
          definitionForWrite.trimmedWordReading,
        );

    if (existingNewWordId == null) {
      // * 新たにWordを作成する場合
      await ref
          .read(writeDefinitionRepositoryProvider)
          .updateDefinitionAndCreateWord(definitionForWrite, previousWordId);
      return;
    }

    if (previousWordId == existingNewWordId) {
      // * Wordに変更がない場合
      await ref
          .read(writeDefinitionRepositoryProvider)
          .updateDefinition(definitionForWrite);
      return;
    }

    // * 「既にWordがある」かつ「Wordに変更がある」場合
    await ref
        .read(writeDefinitionRepositoryProvider)
        .updateWordChangedDefinition(
          previousWordId,
          existingNewWordId,
          definitionForWrite,
        );
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
