import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button/primary_filled_button.dart';

class ErrorAndRetryWidget extends StatelessWidget {
  const ErrorAndRetryWidget({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.exclamationmark_circle_fill,
          color: Theme.of(context).colorScheme.error,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          'エラーが発生しました。',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '再読み込みをお試しください。',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          '繰り返し発生する場合は、運営へお問い合わせください。',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        PrimaryFilledButton(onPressed: onRetry, text: '再読み込み'),
      ],
    );
  }
}

/// [ErrorAndRetryWidget]の簡易版
class SimpleErrorAndRetryWidget extends StatelessWidget {
  const SimpleErrorAndRetryWidget({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRetry,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.exclamationmark_circle_fill,
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'エラー',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'タップで再読み込み',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
