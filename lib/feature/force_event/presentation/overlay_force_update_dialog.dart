import 'package:flutter/material.dart';

import '../../../core/common_widget/button/primary_filled_button.dart';

/// 端末のバックキーや画面操作を受け付けないWidget
///
/// 透明のWidgetで囲い、ダイアログ表示を模している
class OverlayForceUpdateDialog extends StatelessWidget {
  const OverlayForceUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                      // TODO(me): Storeに遷移させる
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
