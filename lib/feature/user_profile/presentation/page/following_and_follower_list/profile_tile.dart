import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/adaptive_overflow_text.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../util/logger.dart';
import '../../../../definition/presentation/component/avatar_icon_widget.dart';
import '../../../application/user_profile_state.dart';
import 'profile_tile_shimmer.dart';

class ProfileTile extends ConsumerWidget {
  const ProfileTile({
    super.key,
    required this.targetUserId,
    required this.button,
    this.transitionToProfilePage = true,
  });

  final String targetUserId;
  final Widget button;

  /// プロフィールページへの遷移を行うかどうか
  final bool transitionToProfilePage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTargetUserProfile = ref.watch(userProfileProvider(targetUserId));

    return asyncTargetUserProfile.when(
      data: (targetUserProfile) {
        return InkWell(
          onTap: transitionToProfilePage
              ? () async {
                  await context.pushRoute(
                    ProfileRoute(
                      targetUserId: targetUserId,
                    ),
                  );
                }
              : null,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AvatarIconWidget(
                      imageUrl: targetUserProfile.profileImageUrl,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  targetUserProfile.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              button,
                            ],
                          ),
                          const SizedBox(height: 8),
                          AdaptiveOverflowText(
                            text: targetUserProfile.bio,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        logger.e('userId [$targetUserId]の取得時にエラーが発生: $error');
        // TODO(me): エラー時に表示させるTileを作成する
        // 「!」みたいなアイコンと、エラーが発生した旨を表示するのが良さげ
        return const SizedBox();
      },
      loading: () {
        return const ProfileTileShimmer();
      },
    );
  }
}
