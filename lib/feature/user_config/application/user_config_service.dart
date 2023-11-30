import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/toast_controller.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../repository/user_config_repository.dart';
import 'user_config_state.dart';

part 'user_config_service.g.dart';

@riverpod
class UserConfigService extends _$UserConfigService {
  @override
  FutureOr<void> build() {}

  /// [targetUserId]をミュートする
  Future<void> muteUser(String targetUserId) async {
    await _modifyMutedUserList(
      targetUserId,
      willMute: true,
      toastMessage: 'ミュートしました',
    );
  }

  /// [targetUserId]のミュートを解除削除する
  Future<void> unmuteUser(String targetUserId) async {
    await _modifyMutedUserList(
      targetUserId,
      willMute: false,
      toastMessage: 'ミュート解除しました',
    );
  }

  Future<void> _modifyMutedUserList(
    String targetUserId, {
    required bool willMute,
    required String toastMessage,
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
    } on Exception catch (e, stackTrace) {
      final action = willMute ? 'ミュート登録' : 'ミュート解除';
      logger.e('$action時にエラーが発生しました。 error: $e, stackTrace: $stackTrace');
      ref
          .read(toastControllerProvider.notifier)
          .showToast('失敗しました。もう一度お試しください。', causeError: true);

      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    ref.invalidate(mutedUserIdListProvider);

    ref.read(toastControllerProvider.notifier).showToast(toastMessage);
    isLoadingOverlayNotifier.finishLoading();
  }
}
