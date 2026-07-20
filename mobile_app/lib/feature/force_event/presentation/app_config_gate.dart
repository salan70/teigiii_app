import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/dialog/loading_dialog.dart';
import '../../../core/common_widget/error_and_retry_widget.dart';
import '../domain/app_config.dart';
import 'overlay_in_maintenance_dialog.dart';

class AppConfigGate extends StatelessWidget {
  const AppConfigGate({
    super.key,
    required this.asyncAppConfig,
    required this.onRetry,
    required this.child,
  });

  final AsyncValue<AppConfig> asyncAppConfig;
  final VoidCallback onRetry;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return asyncAppConfig.when(
      loading: () => const Scaffold(body: OverlayLoadingWidget()),
      error: (_, _) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ErrorAndRetryWidget.canInquire(
                onRetry: onRetry,
                inBaseRoute: false,
              ),
            ),
          ],
        ),
      ),
      data: (appConfig) {
        final appMaintenance = appConfig.toAppMaintenance();
        if (!appMaintenance.inMaintenance) {
          return child;
        }
        return Stack(
          children: [
            child,
            OverlayInMaintenanceDialog(appMaintenance: appMaintenance),
          ],
        );
      },
    );
  }
}
