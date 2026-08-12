import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/auth/application/account_link_service.dart';
import '../../feature/auth/domain/auth_provider_type.dart';
import '../../feature/introduction/presentation/confirm_agreement_dialog.dart';
import '../../util/constant/url.dart';
import '../../util/mixin/presentation_mixin.dart';
import '../common_provider/dialog_controller.dart';
import '../common_provider/launch_url_controller.dart';
import '../design_system/design_system.dart';

@RoutePage()
class WelcomePage extends ConsumerWidget with PresentationMixin {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> restore(AuthProviderType provider) async {
      await executeWithOverlayLoading(
        ref,
        inBaseRouteBeforeAction: false,
        inBaseRouteAfterAction: false,
        action: () => ref.read(accountLinkServiceProvider).signIn(provider),
      );
    }

    Future<void> showRestoreProviderDialog() async {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => DsDialog(
          content: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DsSpacing.containerContent,
            ),
            child: Text(
              '以前のアカウントでサインインして\nデータを復元します。',
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            DsOutlinedButton.tertiary(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                restore(AuthProviderType.apple);
              },
              text: 'Apple',
            ),
            DsFilledButton.primary(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                restore(AuthProviderType.google);
              },
              text: 'Google',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/images/introduction_icon/introduction_icon.png',
                    ).image,
                  ),
                ),
              ),
              const Gap(24),
              Text('ようこそ！', style: Theme.of(context).textTheme.titleLarge),
              const Gap(24),
              Text(
                '思うがままに\n言葉を定義しちゃってください😆',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Gap(24),
              DsFilledButton.primary(
                onPressed: () {
                  ref
                      .read(dialogControllerProvider)
                      .show(const ConfirmAgreementDialog());
                },
                text: 'はじめる',
              ),
              const Gap(DsSpacing.item),
              DsOutlinedButton.tertiary(
                onPressed: () => ref
                    .read(dialogControllerProvider)
                    .show(
                      ConfirmAgreementDialog(
                        onAgreed: showRestoreProviderDialog,
                      ),
                    ),
                text: '以前のデータを復元',
              ),
              const Gap(DsSpacing.item),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => ref
                        .read(launchUrlControllerProvider)
                        .launchURL(termPageUrl, inBaseRoute: false),
                    child: Text(
                      '利用規約',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text(' と '),
                  InkWell(
                    onTap: () => ref
                        .read(launchUrlControllerProvider)
                        .launchURL(privacyPolicyPageUrl, inBaseRoute: false),
                    child: Text(
                      'プライバシーポリシー',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
