import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/toast_controller.dart';
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
    } on Exception catch (e, stackTrace) {
      logger.e('フォロー時にエラーが発生しました。error: $e, stackTrace: $stackTrace');
      ref
          .read(toastControllerProvider.notifier)
          .showToast('フォローに失敗しました', causeError: true);
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // フォローした/されたユーザーのProviderを再生成
    _invalidateRelatedUserProvider(targetUserId);

    isLoadingOverlayNotifier.finishLoading();
  }

  /// ログイン中のuserが[targetUserId]のフォローを解除する
  Future<void> unfollow(String targetUserId) async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();

    final currentUserId = ref.read(userIdProvider)!;

    try {
      await ref.read(userFollowRepositoryProvider).unfollow(
            currentUserId,
            targetUserId,
          );
    } on Exception catch (e, stackTrace) {
      logger.e('フォロー解除時にエラーが発生しました。error: $e, stackTrace: $stackTrace');
      ref.read(toastControllerProvider.notifier).showToast(
            'フォロー解除に失敗しました',
            causeError: true,
          );
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // UI上でのフォロー/フォロワー数を更新するため、
    // フォローした/されたユーザーのProviderを再生成
    _invalidateRelatedUserProvider(targetUserId);

    isLoadingOverlayNotifier.finishLoading();
  }

  /// ログイン中のユーザーと [targetUserId] の
  /// [followCountProvider], [isFollowingProvider] を再生成する
  void _invalidateRelatedUserProvider(String targetUserId) {
    final currentUserId = ref.read(userIdProvider)!;

    ref
      ..invalidate(followCountProvider(currentUserId))
      ..invalidate(followCountProvider(targetUserId))
      ..invalidate(isFollowingProvider(targetUserId));
  }
}
