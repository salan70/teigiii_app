import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/common_widget/shimmer_widget.dart';
import '../../../../core/router/app_router.dart';
import '../../../../util/logger.dart';
import '../../../core/page/user_list_following_or_follower_page.dart';
import '../application/user_follow_state.dart';

class FollowingAndFollowerCountWidget extends ConsumerWidget {
  const FollowingAndFollowerCountWidget({
    super.key,
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFollowCount = ref.watch(followCountProvider(targetUserId));

    return asyncFollowCount.when(
      data: (followCount) {
        return Row(
          children: [
            InkWell(
              onTap: () async {
                await context.pushRoute(
                  UserListFollowingOrFollowerRoute(
                    initialTab: FollowingAndFollowerListTab.following,
                    targetUserId: targetUserId,
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    followCount.followingCount.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Gap(4),
                  const Text('フォロー中'),
                ],
              ),
            ),
            const Gap(16),
            InkWell(
              onTap: () async {
                await context.pushRoute(
                  UserListFollowingOrFollowerRoute(
                    initialTab: FollowingAndFollowerListTab.follower,
                    targetUserId: targetUserId,
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    followCount.followerCount.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Gap(4),
                  const Text('フォロワー'),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ShimmerWidget.rectangular(width: 16, height: 24),
          Gap(8),
          ShimmerWidget.rectangular(width: 48, height: 16),
          Gap(16),
          ShimmerWidget.rectangular(width: 16, height: 24),
          Gap(8),
          ShimmerWidget.rectangular(width: 48, height: 16),
        ],
      ),
      error: (error, stackTrace) {
        logger.e(
          'followCountの取得時にエラーが発生しました。 error: $error, stackTrace: $stackTrace',
        );
        // フォローカウントのみのエラーはユーザーへの影響が少ないため、何も表示しない
        // フォローカウント以外にもエラーが有る場合、他画面でエラーが表示される想定
        return const SizedBox.shrink();
      },
    );
  }
}
