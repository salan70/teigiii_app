import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/common_widget/adaptive_overflow_text.dart';
import '../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../core/router/app_router.dart';
import '../../../../util/exception/database_exception.dart';
import '../../../../util/logger.dart';
import '../application/user_profile_state.dart';
import 'avatar_network_image_widget.dart';
import 'profile_tile_shimmer.dart';

class ProfileTile extends ConsumerWidget {
  const ProfileTile({
    super.key,
    required this.targetUserId,
    required this.button,
    this.transitionToProfilePage = true,
  });

  final String targetUserId;

  // TODO(me): enumで表示するpageの種類を定義し、このWidget内で対応するボタンを配置するほうが良さそう

  /// 右側に表示させるボタン
  /// フォロー/アンフォローボタンや、ミュート解除などを行うボタンを想定
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
                    ProfileTopRoute(
                      targetUserId: targetUserId,
                    ),
                  );
                }
              : null,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AvatarNetworkImageWidget(
                      imageUrl: targetUserProfile.profileImageUrl,
                    ),
                    const Gap(8),
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
                              const Gap(4),
                              button,
                            ],
                          ),
                          const Gap(8),
                          AdaptiveOverflowText(
                            text: targetUserProfile.bio,
                            maxLines: 5,
                          ),
                          const Gap(8),
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
        // ユーザーが存在しない場合
        if (error == const DatabaseException(DatabaseExceptionCode.notFound)) {
          logger.i('user:[$targetUserId]は存在しません');
          return Column(
            children: [
              Row(
                children: [
                  const Gap(20),
                  Icon(
                    CupertinoIcons.exclamationmark_circle_fill,
                    color: Theme.of(context).colorScheme.error,
                    size: 40,
                  ),
                  const Gap(16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(16),
                        Text('存在しないユーザーです。\n削除された可能性があります。'),
                        Gap(16),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          );
        }

        // エラー発生後の再読み込み中の場合、trueになる
        if (asyncTargetUserProfile.isRefreshing) {
          return const Column(
            children: [
              Gap(16),
              CupertinoActivityIndicator(),
              Gap(24),
              Divider(),
            ],
          );
        }

        logger.e(
          'userId [$targetUserId]の取得時にエラーが発生: $error, stackTrace: $stackTrace',
        );
        return Column(
          children: [
            const Gap(16),
            SimpleErrorAndRetryWidget(
              onRetry: () => ref.invalidate(userProfileProvider(targetUserId)),
            ),
            const Gap(16),
            const Divider(),
          ],
        );
      },
      loading: () => const ProfileTileShimmer(),
    );
  }
}
