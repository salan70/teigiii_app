import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/common_provider/dialog_controller.dart';
import '../core/common_provider/launch_url.dart';
import '../core/common_widget/button/filled_button.dart';
import '../feature/introduction/presentation/confirm_agreement_dialog.dart';
import '../util/constant/url.dart';

@RoutePage()
class IntroductionPage extends ConsumerWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const SizedBox(height: 24),
              Text(
                'ようこそ！',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Text(
                '思うがままに\n言葉を定義しちゃってください😆',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              PrimaryFilledButton(
                onPressed: () {
                  ref.read(dialogControllerProvider).show(
                        const ConfirmAgreementDialog(),
                      );
                },
                text: 'はじめる',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => ref.read(launchURLProvider(termPageUrl)),
                    child: Text(
                      '利用規約',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                  const Text(' と '),
                  InkWell(
                    onTap: () =>
                        ref.read(launchURLProvider(privacyPolicyPageUrl)),
                    child: Text(
                      'プライバシーポリシー',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
