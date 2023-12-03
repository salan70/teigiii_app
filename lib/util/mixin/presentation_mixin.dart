import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common_provider/is_loading_overlay_state.dart';
import '../../core/common_provider/toast_controller.dart';
import '../constant/default_text_for_ui.dart';
import '../logger.dart';

// TODO(me): トーストではなく、SnackBar を表示するようにする。

/// Presentation 層で使用する Mixin.
mixin PresentationMixin {
  /// オーバーレイローディングを伴い、
  /// エラー発生時に toast を表示する処理を実行する。
  ///
  /// エラー発生時に表示する toast に任意のメッセージを指定したい場合は、
  /// [errorToastMessage] を設定する。
  Future<void> executeWithOverlayLoading(
    WidgetRef ref, {
    required Future<void> Function() action,
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

      ref
          .read(toastControllerProvider.notifier)
          .showToast(errorToastMessage, causeError: true);
    } finally {
      ref.read(isLoadingOverlayNotifierProvider.notifier).finishLoading();
    }
  }
}
