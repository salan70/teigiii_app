import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/avatar_icon_widget.dart';
import '../../../../../core/common_widget/button/follow_or_unfollow_button.dart';
import '../../../../../core/common_widget/button/secondary_filled_button.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../application/user_profile_state.dart';
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
                  AvatarIconWidget(
                    imageUrl: targetUserProfile.profileImageUrl,
                    avatarSize: AvatarSize.large,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          await context.pushRoute(
                            FollowingAndFollowerListRoute(
                              targetUserId: targetUserProfile.id,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Text(targetUserProfile.followingCount.toString()),
                            const Text('フォロー中'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () async {
                          await context.pushRoute(
                            FollowingAndFollowerListRoute(
                              willShowFollowing: false,
                              targetUserId: targetUserProfile.id,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Text(targetUserProfile.followerCount.toString()),
                            const Text('フォロワー'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                targetUserProfile.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                targetUserProfile.bio,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.topCenter,
                child: currentUserId == targetUserId
                    ? SecondaryFilledButton(
                        text: 'プロフィールを編集する',
                        onPressed: () {},
                      )
                    : FollowOrUnfollowButton(
                        targetUserId: targetUserProfile.id,
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
      loading: ProfileWidgetShimmer.new,
      // TODO(me): 良い感じのエラー画面を作成（ダイアログをオーバーレイで出すのがいいかも）
      error: (error, stackTrace) => const Center(child: Text('エラー')),
    );
  }
}
