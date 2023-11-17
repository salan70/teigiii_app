import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/auth/application/auth_state.dart';
import '../../feature/user_profile/application/user_profile_state.dart';
import '../../util/constant/url.dart';
import '../common_provider/launch_url.dart';
import 'button/primary_filled_button.dart';
import 'button/secondary_outlined_button.dart';

class ErrorAndRetryWidget extends ConsumerWidget {
  const ErrorAndRetryWidget({
    super.key,
    required this.onRetry,
    this.showInquireButton = false,
  });

  final VoidCallback onRetry;
  final bool showInquireButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        showInquireButton
            ? Column(
                children: [
                  const SizedBox(height: 24),
                  SecondaryOutlinedButton(
                    onPressed: () {
                      final currentUserId = ref.read(userIdProvider);

                      String? publicId;
                      if (currentUserId != null) {
                        publicId = ref
                            .read(userProfileProvider(currentUserId))
                            .value
                            ?.publicId;
                      }
                      final url = inquireFormUrl(publicId ?? '');

                      ref.read(launchURLProvider(url));
                    },
                    text: '運営へお問い合わせ',
                  ),
                ],
              )
            : const SizedBox.shrink(),
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
