import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/toast_controller.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../domain/definition.dart';
import '../repository/write_definition_repository.dart';
import '../util/definition_post_type.dart';
import 'definition_state.dart';

part 'definition_service.g.dart';

@riverpod
class DefinitionService extends _$DefinitionService {
  @override
  FutureOr<void> build() {}

  /// いいねをタップした際の処理
  Future<void> tapLike(Definition definition) async {
    // 二度押し防止とUX向上のため、オーバーレイローディングを表示させる
    // そのため、state = AsyncLoadingをしない
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();

    try {
      await _updateLikeStatus(definition);
    } on Exception catch (e, stackTrace) {
      logger.e('いいね登録もしくは解除時にエラーが発生。error: $e, stackTrace: $stackTrace');
      ref
          .read(toastControllerProvider.notifier)
          .showToast('失敗しました。もう一度お試しください。', causeError: true);

      isLoadingOverlayNotifier.finishLoading();
      // 例外が発生したことをpresentationに伝えるため、rethrowする
      rethrow;
    }

    // いいね登録/解除したDefinitionを保持するProviderを再生成
    ref.invalidate(definitionProvider(definition.id));
    isLoadingOverlayNotifier.finishLoading();
  }

  /// いいね登録/解除を行う
  Future<void> _updateLikeStatus(Definition definition) async {
    final userId = ref.read(userIdProvider)!;

    if (definition.isLikedByUser) {
      // いいね解除
      await ref.read(writeDefinitionRepositoryProvider).unlikeDefinition(
            definition.id,
            userId,
          );
      return;
    }

    // いいね登録
    await ref.read(writeDefinitionRepositoryProvider).likeDefinition(
          definition.id,
          userId,
        );
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
