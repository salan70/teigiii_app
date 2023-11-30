import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_provider/dialog_controller.dart';
import '../../../core/common_widget/button/filled_button.dart';
import '../../../core/common_widget/dialog/confirm_dialog.dart';
import '../../../core/router/app_router.dart';
import '../../auth/application/auth_service.dart';

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> showCompleteDeleteAccountDialog() async {
      ref.read(dialogControllerProvider.notifier).show(
            WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: const Text('削除が完了しました。', textAlign: TextAlign.center),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'ご利用ありがとうございました。',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '新たにアカウントを作成する場合は、\n「新規作成」ボタンをタップしてください',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    PrimaryFilledButton(
                      onPressed: () async {
                        await context.navigateTo(const BaseRoute());
                        await ref
                            .read(authServiceProvider.notifier)
                            .onAppLaunch();
                      },
                      text: '新規作成',
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: true,
          );
    }

    Future<void> showFinalConfirmDialog() async {
      ref.read(dialogControllerProvider.notifier).show(
            ConfirmDialog(
              confirmMessage: '最終確認です。\n本当にアカウントを削除しても\nよろしいですか？',
              onConfirm: () async {
                await ref.read(authServiceProvider.notifier).deleteUser();
                await showCompleteDeleteAccountDialog();
              },
              confirmButtonText: '削除する',
            ),
          );
    }

    Future<void> showInitialConfirmDialog() async {
      ref.read(dialogControllerProvider.notifier).show(
            ConfirmDialog(
              confirmMessage: '全ての投稿が削除されます。\n本当にアカウントを削除しても\nよろしいですか？',
              onConfirm: showFinalConfirmDialog,
              confirmButtonText: '削除する',
            ),
          );
    }

    return GestureDetector(
      onTap: showInitialConfirmDialog,
      child: Text(
        'アカウント削除',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}
