import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../util/mixin/presentation_mixin.dart';
import '../common_widget/error_and_retry_widget.dart';
import '../router/app_router.dart';

@RoutePage()
class SignInFailurePage extends ConsumerWidget with PresentationMixin {
  const SignInFailurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ErrorAndRetryWidget(
                // BaseRoute に遷移する際に AuthGuard でログインの処理を行うため、
                // ここでは BaseRoute に遷移するだけにしている。
                // 問題ありそうだったら、ここでログイン処理を行うようにする。
                onRetry: () async => context.pushRoute(const BaseRoute()),
                showInquireButton: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
