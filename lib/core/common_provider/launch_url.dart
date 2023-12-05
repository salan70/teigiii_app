import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/logger.dart';
import 'toast_controller.dart';

part 'launch_url.g.dart';

// TODO(me): Controller として作成する。
// [launchUrl] との重複を避けるために、[launchURL] と命名
@riverpod
Future<void> launchURL(LaunchURLRef ref, String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    logger.e('$uri を開けませんでした。');
    ref
        .read(toastControllerProvider.notifier)
        .showToast('ページを開けませんでした。もう一度お試しください。');
  }
}
