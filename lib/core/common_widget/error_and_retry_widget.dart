import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          size: 24.sp,
        ),
        SizedBox(height: 8.h),
        Text(
          'エラーが発生しました。',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8.h),
        Text(
          '再読み込みをお試しください。',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          '繰り返し発生する場合は、運営へお問い合わせください。',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 24.h),
        PrimaryFilledButton(onPressed: onRetry, text: '再読み込み'),
        showInquireButton
            ? Column(
                children: [
                  SizedBox(height: 24.h),
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
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'エラー',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'タップで再読み込み',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
