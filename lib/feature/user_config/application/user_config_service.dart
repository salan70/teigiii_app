import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/snack_bar_controller.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../../definition/application/definition_service.dart';
import '../../definition/util/definition_feed_type.dart';
import '../repository/user_config_repository.dart';

part 'user_config_service.g.dart';

@Riverpod(keepAlive: true)
class UserConfigService extends _$UserConfigService {
  @override
  FutureOr<void> build() {}

  /// [targetUserId]をミュートする
  Future<void> muteUser(String targetUserId) async {
    await _modifyMutedUserList(
      targetUserId,
      willMute: true,
      snackBarMessage: 'ミュートしました',
    );
  }

  /// [targetUserId]のミュートを解除削除する
  Future<void> unmuteUser(String targetUserId) async {
    await _modifyMutedUserList(
      targetUserId,
      willMute: false,
      snackBarMessage: 'ミュート解除しました',
    );
  }

  Future<void> _modifyMutedUserList(
    String targetUserId, {
    required bool willMute,
    required String snackBarMessage,
  }) async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();

    try {
      final currentUserId = ref.read(userIdProvider)!;
      if (willMute) {
        await ref.read(userConfigRepositoryProvider).appendMutedUserIdList(
              currentUserId,
              targetUserId,
            );
      } else {
        await ref.read(userConfigRepositoryProvider).removeMutedUserIdList(
              currentUserId,
              targetUserId,
            );
      }
    } on Exception catch (e) {
      final action = willMute ? 'ミュート登録' : 'ミュート解除';
      logger.e('$action時にエラーが発生: $e');
      ref
          .read(snackBarControllerProvider.notifier)
          .showSnackBar('失敗しました。もう一度お試しください。', causeError: true);

      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // この処理はDefinitionServiceに移譲したほうがいいかも
    // 全てのDefinitionFeedTypeを引数とするdefinitionIdListStateNotifierを再生成
    for (final feedType in DefinitionFeedType.values) {
      await ref.read(definitionServiceProvider.notifier).refreshAll(feedType);
    }

    ref.read(snackBarControllerProvider.notifier).showSnackBar(snackBarMessage, causeError: false);
    isLoadingOverlayNotifier.finishLoading();
  }
}
