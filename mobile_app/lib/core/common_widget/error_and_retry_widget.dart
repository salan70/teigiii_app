import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/auth/application/auth_state.dart';
import '../../feature/user_profile/application/user_profile_state.dart';
import '../../util/constant/url.dart';
import '../common_provider/launch_url_controller.dart';
import '../design_system/component/ds_feedback.dart';

/// エラー表示に問い合わせ導線を足したもの。
///
/// 見た目の仕様は [DsErrorView] が持つ。ここは問い合わせ URL の組み立てと
/// 認証・プロフィール状態への依存だけを担う。
class ErrorAndRetryWidget extends ConsumerWidget {
  /// お問い合わせボタンを表示しない [ErrorAndRetryWidget].
  const ErrorAndRetryWidget.cannotInquire({super.key, required this.onRetry})
    : showInquireButton = false,
      inBaseRoute = null;

  /// お問い合わせボタンを表示する [ErrorAndRetryWidget].
  const ErrorAndRetryWidget.canInquire({
    super.key,
    required this.onRetry,
    required this.inBaseRoute,
  }) : showInquireButton = true;

  /// リトライ時の処理。
  final VoidCallback onRetry;

  /// お問い合わせボタンを表示するかどうか。
  final bool showInquireButton;

  /// 表示する Page が BaseRoute 内かどうか。（ BottomNavBar を表示するかどうか。）
  final bool? inBaseRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!showInquireButton) {
      return DsErrorView.standard(onRetry: onRetry);
    }

    return DsErrorView.standard(
      onRetry: onRetry,
      secondaryActionText: '運営へお問い合わせ',
      onSecondaryAction: () {
        final currentUserId = ref.read(userIdProvider);

        String? publicId;
        if (currentUserId != null) {
          publicId = ref
              .read(userProfileProvider(currentUserId))
              .value
              ?.publicId;
        }
        final url = inquireFormUrl(publicId ?? '');

        // `showInquireButton` が true の場合、
        // `inBaseRoute` は必ず null ではない。
        ref
            .read(launchUrlControllerProvider)
            .launchURL(url, inBaseRoute: inBaseRoute!);
      },
    );
  }
}

/// [ErrorAndRetryWidget] の簡易版。
@Deprecated('DsErrorView.compact を使う。全参照の移行後に削除する (#278)')
class SimpleErrorAndRetryWidget extends StatelessWidget {
  const SimpleErrorAndRetryWidget({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return DsErrorView.compact(onRetry: onRetry);
  }
}
