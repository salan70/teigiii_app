import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_provider/launch_url.dart';
import '../../../core/common_widget/button/primary_filled_button.dart';
import '../../../util/constant/url.dart';

/// 端末のバックキーや画面操作を受け付けないWidget
///
/// 透明のWidgetで囲い、ダイアログ表示を模している
class OverlayForceUpdateDialog extends ConsumerWidget {
  const OverlayForceUpdateDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '新たなバージョンが配信されています。\nアップデートをお願いします',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  PrimaryFilledButton(
                    onPressed: () {
                      switch (defaultTargetPlatform) {
                        case TargetPlatform.iOS:
                          ref.read(launchURLProvider(appStoreUrl));
                          return;
                        case TargetPlatform.android:
                          ref.read(launchURLProvider(googlePlayStoreUrl));
                          return;

                        case TargetPlatform.fuchsia:
                        case TargetPlatform.linux:
                        case TargetPlatform.macOS:
                        case TargetPlatform.windows:
                          throw UnsupportedError(
                            '想定外のプラットフォームです。 defaultTargetPlatform: $defaultTargetPlatform',
                          );
                      }
                    },
                    text: 'アップデートする',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
