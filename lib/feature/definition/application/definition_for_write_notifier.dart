import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/toast_controller.dart';
import '../../../core/router/app_router.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../../word/repository/word_repository.dart';
import '../domain/definition_for_write.dart';
import '../repository/write_definition_repository.dart';
import 'definition_id_list_state.dart';
import 'definition_state.dart';

part 'definition_for_write_notifier.g.dart';

/// 更新時などTextField等に初期表示したい値がある場合、
/// [definitionForWrite]として渡すこと
///
/// ない場合はnullを渡すこと
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

  /// 初期状態として渡された[DefinitionForWrite].
  /// 現在の状態と比較するために使用する
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

  Future<void> post() async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();
    final toastNotifier = ref.read(toastControllerProvider.notifier);

    try {
      await _executeCreate();
    } on Exception catch (e, stackTrace) {
      logger.e('定義投稿時にエラーが発生 error: $e, stackTrace: $stackTrace');
      toastNotifier.showToast(
        '投稿できませんでした。もう一度お試しください。',
        causeError: true,
      );
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    ref.invalidate(definitionIdListStateNotifierProvider);

    isLoadingOverlayNotifier.finishLoading();
    await ref.read(appRouterProvider).pop();
    toastNotifier.showToast('投稿しました！');
  }

  Future<void> _executeCreate() async {
    final definitionForWrite = state.value!;

    final existingCurrentWordId =
        await ref.read(wordRepositoryProvider).findWordId(
              definitionForWrite.trimmedWord,
              definitionForWrite.trimmedWordReading,
            );

    // Wordドキュメントを新たに作成する必要があるかを判定
    if (existingCurrentWordId == null) {
      // * 必要ある場合
      await ref.read(writeDefinitionRepositoryProvider).createDefinitionAndWord(
            definitionForWrite,
          );
      return;
    }

    // * 必要ない場合
    await ref.read(writeDefinitionRepositoryProvider).createDefinition(
          definitionForWrite,
          existingCurrentWordId,
        );
  }

  Future<void> edit() async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();

    final definitionForWrite = state.value!;
    final toastNotifier = ref.read(toastControllerProvider.notifier);

    try {
      await _executeUpdate();
    } on Exception catch (e, stackTrace) {
      logger.e('定義編集時にエラーが発生 error: $e, stackTrace: $stackTrace');
      toastNotifier.showToast(
        '保存できませんでした。もう一度お試しください。',
        causeError: true,
      );
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    ref
      ..invalidate(definitionProvider(definitionForWrite.id!))
      ..invalidate(definitionIdListStateNotifierProvider);

    isLoadingOverlayNotifier.finishLoading();
    await ref.read(appRouterProvider).pop();
    toastNotifier.showToast('保存しました！');
  }

  Future<void> _executeUpdate() async {
    final definitionForWrite = state.value!;

    // 編集前のwordId
    final previousWordId = await ref
        .read(wordRepositoryProvider)
        .findWordId(_initialState.word, _initialState.wordReading);
    if (previousWordId == null) {
      throw Exception('編集前のwordIdがnullです');
    }

    // 編集後のwordId。 [initialWordId] と同じ可能性あり
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
