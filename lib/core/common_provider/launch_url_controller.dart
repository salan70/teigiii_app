import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/logger.dart';
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
  Future<void> launchURL(String url, {bool inBaseRoute = true}) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      logger.e('$uri を開けませんでした。');

      final scaffoldMessengerType = inBaseRoute
          ? ScaffoldMessengerType.baseRoute
          : ScaffoldMessengerType.topRoute;

      ref.read(snackBarControllerProvider).showErrorSnackBar(
            'ページを開けませんでした。もう一度お試しください。',
            scaffoldMessengerType,
          );
    }
  }
}
