import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/dialog/loading_dialog.dart';
import '../../feature/user_config/application/user_config_state.dart';

// TODO(me): CircleProgressIndicatorをCupertinoのにしたい
@RoutePage()
class MyLicensePage extends ConsumerWidget {
  const MyLicensePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(appVersionProvider);

    return Scaffold(
      body: appVersion.when(
        data: (appVersion) {
          return LicensePage(
            applicationName: 'Teigiii',
            applicationVersion: appVersion,
          );
        },
        loading: OverlayLoadingWidget.new,
        error: (error, stackTrace) => const Center(child: Text('エラーが発生しました')),
      ),
    );
  }
}
