import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/logger.dart';
import '../analytics/analytics_event.dart';
import '../analytics/analytics_link_type.dart';
import '../analytics/analytics_service.dart';
import 'key_provider.dart';
import 'snack_bar_controller.dart';

part 'launch_url_controller.g.dart';

@riverpod
LaunchUrlController launchUrlController(LaunchUrlControllerRef ref) =>
    LaunchUrlController(ref);

class LaunchUrlController {
  LaunchUrlController(this.ref);

  final Ref ref;

  // `launchUrl` との重複を避けるために、このような命名にしている。
  /// [url] を開く。
  ///
  /// 呼び出し元が `BaseRoute` 内でない（ `BottomNavBar` を表示していない）場合は、
  /// [inBaseRoute] を `false` にする。
  ///
  /// [linkType] を渡すと `external_link_opened` の分類を明示できる
  ///（未指定時は URL から推定）。
  Future<void> launchURL(
    String url, {
    bool inBaseRoute = true,
    String? linkType,
  }) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      logger.e('$uri を開けませんでした。');

      final scaffoldMessengerType = inBaseRoute
          ? ScaffoldMessengerType.baseRoute
          : ScaffoldMessengerType.topRoute;

      ref
          .read(snackBarControllerProvider)
          .showErrorSnackBar(
            'ページを開けませんでした。もう一度お試しください。',
            scaffoldMessengerType,
          );
      return;
    }

    final resolvedLinkType = inferAnalyticsLinkType(
      url,
      explicitLinkType: linkType,
    );
    if (resolvedLinkType != null) {
      await ref
          .read(analyticsServiceProvider)
          .logEvent(
            AnalyticsEvent.externalLinkOpened,
            parameters: {AnalyticsParam.linkType: resolvedLinkType},
          );
    }
  }
}
