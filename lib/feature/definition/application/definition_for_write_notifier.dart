import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/toast_controller.dart';
import '../../../core/router/app_router.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../../word/repository/word_repository.dart';
import '../domain/definition_for_write.dart';
import '../repository/write_definition_repository.dart';
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
      _initialState = const DefinitionForWrite(
        id: null,
        word: '',
        wordReading: '',
        isPublic: true,
        definition: '',
      );
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

    final definitionForWrite = state.value!;
    final toastNotifier = ref.read(toastControllerProvider.notifier);

    try {
      final existingWordId = await ref.read(wordRepositoryProvider).findWordId(
            definitionForWrite.word,
            definitionForWrite.wordReading,
          );
      final currentUserId = ref.read(userIdProvider)!;

      await ref
          .read(writeDefinitionRepositoryProvider)
          .createDefinitionAndMaybeWord(
            currentUserId,
            existingWordId,
            definitionForWrite,
          );
    } on Exception catch (e) {
      logger.e('定義投稿時にエラーが発生 error: $e');
      toastNotifier.showToast(
        '投稿できませんでした。もう一度お試しください。',
        causeError: true,
      );
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // TODO(me): 適宜providerをinvalidateする

    // TODO(me): 画面がカクつくのなんとかする
    isLoadingOverlayNotifier.finishLoading();
    await ref.read(appRouterProvider).pop();
    toastNotifier.showToast('投稿しました！');
  }

  Future<void> edit() async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();

    final definitionForWrite = state.value!;
    final toastNotifier = ref.read(toastControllerProvider.notifier);

    try {
      final existingWordId = await ref.read(wordRepositoryProvider).findWordId(
            definitionForWrite.word,
            definitionForWrite.wordReading,
          );

      await ref
          .read(writeDefinitionRepositoryProvider)
          .updateDefinitionAndMaybeCreateWord(
            existingWordId,
            definitionForWrite,
          );
    } on Exception catch (e) {
      logger.e('定義編集時にエラーが発生 error: $e');
      toastNotifier.showToast(
        '保存できませんでした。もう一度お試しください。',
        causeError: true,
      );
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // 遷移元の画面を更新するためにinvalidateする
    ref.invalidate(definitionProvider(definitionForWrite.id!));

    isLoadingOverlayNotifier.finishLoading();
    await ref.read(appRouterProvider).pop();
    toastNotifier.showToast('保存しました！');
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
