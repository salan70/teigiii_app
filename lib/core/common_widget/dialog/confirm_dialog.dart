import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'base_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.confirmMessage,
    required this.onConfirm,
    required this.confirmButtonText,
  });

  final String confirmMessage;
  final VoidCallback onConfirm;
  final String confirmButtonText;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      content: Text(confirmMessage, textAlign: TextAlign.center),
      actions: [
        InkWell(
          onTap: () {
            context.popRoute();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'キャンセル',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            await context.popRoute();
            onConfirm();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              confirmButtonText,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
