import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/dialog/base_dialog.dart';
import '../../../core/router/app_router.dart';
import '../repository/is_first_launch_repository.dart';

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
          onTap: () async {
            // TODO(me):  repository 層に依存しないようにしたい。
            // ただ、そのために application 層にクラスを作るのも微妙な感じがする。
            await ref.read(isFirstLaunchRepositoryProvider).saveFirstLaunch();

            // todo: trackingうんたらのダイアログ出す。

            if (!context.mounted) {
              return;
            }
            await context.pushRoute(const BaseRoute());
          },
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
