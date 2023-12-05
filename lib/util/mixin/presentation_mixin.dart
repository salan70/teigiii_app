import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common_provider/is_loading_overlay_state.dart';
import '../../core/common_provider/key_provider.dart';
import '../../core/common_provider/snack_bar_controller.dart';
import '../constant/default_text_for_ui.dart';
import '../logger.dart';

/// Presentation 層で使用する Mixin.
mixin PresentationMixin {
  /// オーバーレイローディングを伴い、
  /// エラー発生時に SnackBar を表示する処理を実行する。
  ///
  /// [inBaseRouteBeforeAction], [inBaseRouteAfterAction] に応じて、
  /// 表示する ScaffoldMessenger を決定する。
  ///
  /// エラー発生時に表示する toast に任意のメッセージを指定したい場合は、
  /// [errorToastMessage] を設定する。
  Future<void> executeWithOverlayLoading(
    WidgetRef ref, {
    required Future<void> Function() action,
    bool inBaseRouteBeforeAction = true,
    bool inBaseRouteAfterAction = true,
    String? successToastMessage,
    String errorToastMessage = defaultErrorToastText,
  }) async {
    ref.read(isLoadingOverlayNotifierProvider.notifier).startLoading();

    try {
      await action();

      // 必要があれば、成功した旨の toast を表示する。
      if (successToastMessage != null) {
        final scaffoldMessengerType = inBaseRouteAfterAction
            ? ScaffoldMessengerType.baseRoute
            : ScaffoldMessengerType.topRoute;
        ref
            .read(snackBarControllerProvider)
            .showSuccessSnackBar(successToastMessage, scaffoldMessengerType);
      }
    } on Exception catch (e, s) {
      logger.e('error: $e, stackTrace: $s');

      final scaffoldMessengerType = inBaseRouteBeforeAction
          ? ScaffoldMessengerType.baseRoute
          : ScaffoldMessengerType.topRoute;
      ref
          .read(snackBarControllerProvider)
          .showErrorSnackBar(errorToastMessage, scaffoldMessengerType);
    } finally {
      ref.read(isLoadingOverlayNotifierProvider.notifier).finishLoading();
    }
  }
}
