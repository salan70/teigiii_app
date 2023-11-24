import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/dialog/base_dialog.dart';
import '../application/introduction_service.dart';

class ConfirmAgreementDialog extends ConsumerWidget {
  const ConfirmAgreementDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseDialog(
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          '利用規約とプライバシーポリシーに\n同意しますか？',
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        InkWell(
          onTap: context.popRoute,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '同意しない',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        InkWell(
          onTap: ref.read(introductionServiceProvider.notifier).onAgreePolicy,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '同意する',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
