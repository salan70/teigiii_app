import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/snack_bar_controller.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../domain/definition.dart';
import '../repository/write_definition_repository.dart';
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
    } on Exception catch (e) {
      logger.e('いいね登録もしくは解除時にエラーが発生: $e');
      ref
          .read(snackBarControllerProvider.notifier)
          .showSnackBar('失敗しました。もう一度お試しください。', causeError: true);

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
}
