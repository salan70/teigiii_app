import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget/shimmer_widget.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../util/logger.dart';
import '../../../application/user_profile_state.dart';

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
                  FollowingAndFollowerListRoute(
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
                  SizedBox(width: 4.w),
                  const Text('フォロー中'),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            InkWell(
              onTap: () async {
                await context.pushRoute(
                  FollowingAndFollowerListRoute(
                    willShowFollowing: false,
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
                  SizedBox(width: 4.w),
                  const Text('フォロワー'),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ShimmerWidget.rectangular(width: 16.w, height: 24.h),
          SizedBox(height: 8.h),
          ShimmerWidget.rectangular(width: 48.w, height: 16.h),
          SizedBox(width: 16.w),
          ShimmerWidget.rectangular(width: 16.w, height: 24.h),
          SizedBox(height: 8.w),
          ShimmerWidget.rectangular(width: 48.w, height: 16.h),
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
