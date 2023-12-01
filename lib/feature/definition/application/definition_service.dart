import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/toast_controller.dart';
import '../../../util/logger.dart';
import '../../definition_like/repository/like_definition_repository.dart';
import '../../definition_list/appication/definition_id_list_state.dart';
import '../../word/application/word_list_state_by_initial.dart';
import '../../word/application/word_list_state_by_search_word.dart';
import '../../word/application/word_state.dart';
import '../domain/definition.dart';
import '../repository/write_definition_repository.dart';
import '../util/definition_post_type.dart';
import 'definition_state.dart';

part 'definition_service.g.dart';

@riverpod
class DefinitionService extends _$DefinitionService {
  @override
  FutureOr<void> build() {}

  Future<void> deleteDefinition(Definition definition) async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();
    final toastNotifier = ref.read(toastControllerProvider.notifier);

    try {
      await ref
          .read(writeDefinitionRepositoryProvider)
          .deleteDefinition(definition.id, definition.wordId);

      // 紐づくいいねを削除
      await ref.read(likeDefinitionRepositoryProvider).deleteLikeByDefinitionId(
            definition.id,
          );
    } on Exception catch (e, stackTrace) {
      logger.e(
        '定義[${definition.id}]を削除時にエラーが発生 error: $e, stackTrace: $stackTrace',
      );
      toastNotifier.showToast(
        'エラーが発生しました。もう一度お試しください。',
        causeError: true,
      );
      isLoadingOverlayNotifier.finishLoading();

      // 例外が発生したことをpresentationに伝えるため、rethrowする
      rethrow;
    }

    ref
      ..invalidate(definitionIdListStateNotifierProvider)
      ..invalidate(wordListStateByInitialNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider)
      ..invalidate(wordProvider(definition.wordId));

    // uiでのラグを回避するため、wordが再生成されるまで待機する
    await ref.read(wordProvider(definition.wordId).future);

    isLoadingOverlayNotifier.finishLoading();
    toastNotifier.showToast('削除しました');
  }

  Future<void> updatePostType(Definition definition) async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();
    final toastNotifier = ref.read(toastControllerProvider.notifier);

    try {
      await ref.read(writeDefinitionRepositoryProvider).updatePostType(
            definitionId: definition.id,
            isPublic: !definition.isPublic,
          );
    } on Exception catch (e, stackTrace) {
      logger.e('公開設定更新時にエラーが発生 error: $e, stackTrace: $stackTrace');
      toastNotifier.showToast(
        'エラーが発生しました。もう一度お試しください。',
        causeError: true,
      );
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // 遷移元の画面を更新するためにinvalidateする
    ref.invalidate(definitionProvider(definition.id));

    isLoadingOverlayNotifier.finishLoading();
    final afterUpdatePostType = definition.isPublic
        ? DefinitionPostType.private
        : DefinitionPostType.public;
    toastNotifier.showToast(afterUpdatePostType.completeChangeMessage);
  }
}
