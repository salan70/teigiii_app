import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/common_widget/avatar_network_image_widget.dart';
import '../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../core/router/app_router.dart';
import '../../../../util/logger.dart';
import '../application/user_profile_state.dart';

class DictionaryAuthorWidget extends ConsumerWidget {
  const DictionaryAuthorWidget({
    super.key,
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTargetUserProfile = ref.watch(userProfileProvider(targetUserId));

    return asyncTargetUserProfile.when(
      data: (targetUserProfile) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Written by',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(16),
            InkWell(
              onTap: () {
                context.pushRoute(
                  ProfileTopRoute(
                    targetUserId: targetUserProfile.id,
                  ),
                );
              },
              child: Row(
                children: [
                  AvatarNetworkImageWidget(
                    imageUrl: targetUserProfile.profileImageUrl,
                  ),
                  const Gap(16),
                  Text(
                    targetUserProfile.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, stackTrace) {
        // エラー発生後の再読み込み中の場合、trueになる
        if (asyncTargetUserProfile.isRefreshing) {
          return const Center(child: CupertinoActivityIndicator());
        }

        logger.e('ユーザー[$targetUserId]の取得に失敗しました。'
            'error: $error, stackTrace: $stackTrace');
        return Center(
          child: SimpleErrorAndRetryWidget(
            onRetry: () => ref.invalidate(userProfileProvider(targetUserId)),
          ),
        );
      },
    );
  }
}
