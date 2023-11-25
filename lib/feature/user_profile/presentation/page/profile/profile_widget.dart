import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/avatar_network_image_widget.dart';
import '../../../../../core/common_widget/button/follow_or_unfollow_button.dart';
import '../../../../../core/common_widget/button/primary_outlined_button.dart';
import '../../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../util/logger.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../application/user_profile_state.dart';
import 'following_and_follower_count_widget.dart';
import 'profile_widget_shimmer.dart';

class ProfileWidget extends ConsumerWidget {
  const ProfileWidget({super.key, required this.targetUserId});

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTargetUserProfile = ref.watch(userProfileProvider(targetUserId));
    final currentUserId = ref.watch(userIdProvider);

    return asyncTargetUserProfile.when(
      data: (targetUserProfile) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  AvatarNetworkImageWidget(
                    imageUrl: targetUserProfile.profileImageUrl,
                    avatarSize: AvatarSize.large,
                  ),
                  const Spacer(),
                  currentUserId == targetUserId
                      ? PrimaryOutlinedButton(
                          text: 'プロフィールを編集',
                          onPressed: () {
                            context.pushRoute(EditProfileRoute());
                          },
                        )
                      : FollowOrUnfollowButton(
                          targetUserId: targetUserProfile.id,
                        ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                targetUserProfile.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'ID ${targetUserProfile.publicIdForUi}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                targetUserProfile.bio,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FollowingAndFollowerCountWidget(targetUserId: targetUserId),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  await context.pushRoute(
                    IndividualDictionaryRoute(
                      targetUserId: targetUserProfile.id,
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '辞書を見る',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.chevron_forward,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
      loading: () {
        return const ProfileWidgetShimmer();
      },
      error: (error, stackTrace) {
        // エラー発生後の再読み込み中の場合、trueになる
        if (asyncTargetUserProfile.isRefreshing) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CupertinoActivityIndicator(),
          );
        }

        logger.e('ユーザー[$targetUserId]のプロフィールの取得に失敗しました。'
            'error: $error, stackTrace: $stackTrace');
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: ErrorAndRetryWidget(
            onRetry: () => ref.invalidate(userProfileProvider(targetUserId)),
          ),
        );
      },
    );
  }
}
