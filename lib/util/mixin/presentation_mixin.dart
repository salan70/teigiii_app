import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common_provider/is_loading_overlay_state.dart';
import '../../core/common_provider/toast_controller.dart';
import '../constant/default_text_for_ui.dart';
import '../logger.dart';

/// Presentation 層で使用する Mixin。
mixin PresentationMixin {
  /// オーバーレイローディングを伴う処理を実行する。
  ///
  /// [action] 完了時に toast を表示する場合は、
  /// [successToastMessage] に表示するメッセージを指定する。
  ///
  /// [action] でエラー発生時に toast を表示する場合は、
  /// [showErrorToast] に true を指定する。
  ///
  /// エラー発生時に表示する toast に任意のメッセージを指定したい場合は、
  /// [errorToastMessage] を設定する。
  Future<void> executeWithOverlayLoading(
    WidgetRef ref, {
    required Future<void> Function() action,
    required bool showErrorToast,
    String? successToastMessage,
    String errorToastMessage = defaultErrorToastText,
  }) async {
    ref.read(isLoadingOverlayNotifierProvider.notifier).startLoading();

    try {
      await action();

      // 必要があれば、成功した旨の toast を表示する。
      if (successToastMessage != null) {
        ref
            .read(toastControllerProvider.notifier)
            .showToast(successToastMessage);
      }
    } on Exception catch (e, s) {
      logger.e('error: $e, stackTrace: $s');

      // 必要があれば、エラーが発生した旨の toast を表示する。
      if (showErrorToast) {
        ref
            .read(toastControllerProvider.notifier)
            .showToast(errorToastMessage, causeError: true);
      }
    } finally {
      ref.read(isLoadingOverlayNotifierProvider.notifier).finishLoading();
    }
  }
}
