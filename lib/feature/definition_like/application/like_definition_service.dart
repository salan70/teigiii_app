import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/toast_controller.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../../definition/application/definition_state.dart';
import '../../definition/domain/definition.dart';
import '../repository/like_definition_repository.dart';

part 'like_definition_service.g.dart';

@riverpod
LikeDefinitionService likeDefinitionService(LikeDefinitionServiceRef ref) =>
    LikeDefinitionService(ref);

class LikeDefinitionService {
  LikeDefinitionService(this.ref);

  final Ref ref;

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
      await ref.read(likeDefinitionRepositoryProvider).unlikeDefinition(
            definition.id,
            userId,
          );
      return;
    }

    // いいね登録
    await ref.read(likeDefinitionRepositoryProvider).likeDefinition(
          definition.id,
          userId,
        );
  }
}
