import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common_provider/launch_url.dart';
import '../../../core/common_widget/button/primary_filled_button.dart';
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
              borderRadius: BorderRadius.circular(8).r,
            ),
            child: Padding(
              padding: REdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    '🤖現在メンテナンス中です🤖'
                    '\n終了予定は${appMaintenance.scheduledEndTime}です。',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'ご不便をおかけし申し訳ございません🙇‍♂\n'
                    '詳しい情報は下記からご確認いただけます。',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16.h),
                  PrimaryFilledButton(
                    onPressed: () {
                      ref.read(launchURLProvider(latestInformationPage));
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
