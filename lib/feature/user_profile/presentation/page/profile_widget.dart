import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/button/main_button.dart';
import '../../../definition/presentation/component/avatar_icon_widget.dart';
import '../../application/user_profile_state.dart';
import 'profile_widget_shimmer.dart';

class ProfileWidget extends ConsumerWidget {
  const ProfileWidget({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserProfile = ref.watch(userProfileProvider(userId));
    return asyncUserProfile.when(
      data: (userProfile) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  AvatarIconWidget(
                    imageUrl: userProfile.profileImageUrl,
                    avatarSize: AvatarSize.large,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Text(userProfile.followingCount.toString()),
                          const Text('フォロー中'),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          Text(userProfile.followerCount.toString()),
                          const Text('フォロワー'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                userProfile.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                userProfile.bio,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.topCenter,
                child: MainTextButton(
                  text: 'フォローする',
                  onPressed: () {},
                ),
              ),
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
