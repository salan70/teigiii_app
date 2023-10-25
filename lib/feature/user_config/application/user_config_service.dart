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
  Future<void> addMutedUser(String targetUserId) async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();

    try {
      final currentUserId = ref.read(userIdProvider)!;
      await ref.read(userConfigRepositoryProvider).appendMutedUserIdList(
            currentUserId,
            targetUserId,
          );
    } on Exception catch (e) {
      logger.e('ミュート登録時にエラーが発生: $e');
      ref
          .read(snackBarControllerProvider.notifier)
          .showSnackBar('失敗しました。もう一度お試しください。');

      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // この処理はDefinitionServiceに移譲したほうがいいかも
    // 全てのDefinitionFeedTypeを引数とするdefinitionIdListStateNotifierを再生成
    for (final feedType in DefinitionFeedType.values) {
      await ref.read(definitionServiceProvider.notifier).refreshAll(feedType);
    }

    ref.read(snackBarControllerProvider.notifier).showSnackBar('ミュートしました');
    isLoadingOverlayNotifier.finishLoading();
  }
}
