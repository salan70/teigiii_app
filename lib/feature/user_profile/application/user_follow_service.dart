import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/snack_bar_controller.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../repository/user_follow_repository.dart';
import 'user_profile_state.dart';

part 'user_follow_service.g.dart';

@Riverpod(keepAlive: true)
class UserFollowService extends _$UserFollowService {
  @override
  FutureOr<void> build() {}

  /// ログイン中のuserが[targetUserId]をフォローする
  Future<void> follow(String targetUserId) async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();

    final currentUserId = ref.read(userIdProvider)!;

    try {
      await ref.read(userFollowRepositoryProvider).follow(
            currentUserId,
            targetUserId,
          );
    } on Exception catch (e) {
      logger.e('フォロー時にエラーが発生: $e');
      ref.read(snackBarControllerProvider.notifier).showSnackBar(
            'フォローに失敗しました',
            causeError: true,
          );
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // フォローした/されたユーザーのProviderを再生成
    ref
      ..invalidate(userProfileProvider(currentUserId))
      ..invalidate(userProfileProvider(targetUserId));

    isLoadingOverlayNotifier.finishLoading();
  }
}
