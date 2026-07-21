import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/introduction/presentation/confirm_agreement_dialog.dart';
import '../../util/constant/url.dart';
import '../common_provider/dialog_controller.dart';
import '../common_provider/launch_url_controller.dart';
import '../common_widget/button/filled_button.dart';

/// @doc doc/specs/mobile-app-functional-spec.md#14-初回利用
@RoutePage()
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/introduction_icon/introduction_icon.png',
                    width: 180,
                    height: 180,
                  ),
                  const Gap(24),
                  Text(
                    '言葉を、自分の言葉で残す辞書です',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Gap(12),
                  Text(
                    '気づいた言葉と、そのときの意味を\nあなたの辞書に残せます。',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Gap(32),
                  PrimaryFilledButton(
                    onPressed: () {
                      ref
                          .read(dialogControllerProvider)
                          .show(const ConfirmAgreementDialog());
                    },
                    text: 'はじめる',
                  ),
                  const Gap(16),
                  _PolicyLinks(ref: ref),
                  const Gap(24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicyLinks extends StatelessWidget {
  const _PolicyLinks({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    TextStyle? linkStyle() => Theme.of(context).textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      decoration: TextDecoration.underline,
    );

    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        InkWell(
          onTap: () => ref
              .read(launchUrlControllerProvider)
              .launchURL(termPageUrl, inBaseRoute: false),
          child: Text('利用規約', style: linkStyle()),
        ),
        const Text(' と '),
        InkWell(
          onTap: () => ref
              .read(launchUrlControllerProvider)
              .launchURL(privacyPolicyPageUrl, inBaseRoute: false),
          child: Text('プライバシーポリシー', style: linkStyle()),
        ),
      ],
    );
  }
}
