import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/snack_bar_controller.dart';
import '../../../core/router/app_router.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../../word/repository/word_repository.dart';
import '../domain/definition_for_write.dart';
import '../repository/definition_repository.dart';

part 'definition_for_write_notifier.g.dart';

@riverpod
class DefinitionForWriteNotifier extends _$DefinitionForWriteNotifier {
  @override
  FutureOr<DefinitionForWrite> build(String? definitionId) async {
    final currentUserId = ref.read(userIdProvider)!;
    return DefinitionForWrite(
      id: definitionId,
      authorId: currentUserId,
      wordId: null,
      word: '',
      wordReading: '',
      isPublic: true,
      definition: '',
    );
  }

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
    final snackBarNotifier = ref.read(snackBarControllerProvider.notifier);

    try {
      final existingWordId = await ref.read(wordRepositoryProvider).findWordId(
            definitionForWrite.word,
            definitionForWrite.wordReading,
          );
      state = AsyncData(definitionForWrite.copyWith(wordId: existingWordId));

      await ref
          .read(definitionRepositoryProvider)
          .createDefinitionAndMaybeWord(definitionForWrite);
    } on Exception catch (e) {
      logger.e('定義投稿時にエラーが発生 error: $e');
      snackBarNotifier.showSnackBar('投稿が失敗しました。もう一度お試しください。', causeError: true);
      isLoadingOverlayNotifier.finishLoading();
    }

    // TODO(me): 適宜providerをinvalidateする

    // TODO(me): 画面がカクつくのなんとかする
    isLoadingOverlayNotifier.finishLoading();
    await ref.read(appRouterProvider).pop();
    snackBarNotifier.showSnackBar('投稿しました！', causeError: false);
  }
}
