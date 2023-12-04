import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/common_provider/launch_url.dart';
import '../../../core/common_widget/button/filled_button.dart';
import '../../../util/constant/url.dart';
import '../domain/app_maintenance.dart';

/// 端末のバックキーや画面操作を受け付けないWidget
///
/// 透明のWidgetで囲い、ダイアログ表示を模している
class OverlayInMaintenanceDialog extends ConsumerWidget {
  const OverlayInMaintenanceDialog({super.key, required this.appMaintenance});

  final AppMaintenance appMaintenance;

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
                  const Gap(8),
                  Text(
                    '🤖現在メンテナンス中です🤖'
                    '\n終了予定は${appMaintenance.scheduledEndTime}です。',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(16),
                  Text(
                    'ご不便をおかけし申し訳ございません🙇‍♂\n'
                    '詳しい情報は下記からご確認いただけます。',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(16),
                  PrimaryFilledButton(
                    onPressed: () {
                      ref.read(launchURLProvider(latestInformationPageUrl));
                    },
                    text: '最新情報を確認する',
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
