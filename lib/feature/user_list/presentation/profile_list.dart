import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/infinity_scroll_widget.dart';
import '../../auth/application/auth_state.dart';
import '../../user_follow/presentation/component/follow_or_unfollow_button.dart';
import '../../user_profile/presentation/component/profile_tile.dart';
import '../../user_profile/presentation/component/profile_tile_shimmer.dart';
import '../../user_profile/util/user_list_type.dart';
import '../application/user_id_list_state_notifier.dart';

class ProfileList extends ConsumerWidget {
  const ProfileList({
    super.key,
    required this.userListType,
    required this.targetUserId,
    required this.targetDefinitionId,
    required this.emptyWidget,
    this.additionalOnRefresh,
  });

  final UserListType userListType;
  final String? targetUserId;
  final String? targetDefinitionId;
  final Widget? emptyWidget;

  /// スワイプリフレッシュ時、[userIdListStateNotifierProvider] の 
  /// invalidate 以外に行う処理。
  final VoidCallback? additionalOnRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider)!;
    final userIdListProvider = userIdListStateNotifierProvider(
      userListType,
      targetUserId: targetUserId,
      targetDefinitionId: targetDefinitionId,
    );

    return InfinityScrollWidget(
      listStateNotifierProvider: userIdListProvider,
      fetchMore: ref.read(userIdListProvider.notifier).fetchMore,
      tileBuilder: (userId) {
        return ProfileTile(
          targetUserId: userId as String,
          button: currentUserId == userId
              ? const SizedBox.shrink()
              : FollowOrUnfollowButton(targetUserId: userId),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      shimmerTile: const ProfileTileShimmer(),
      shimmerTileNumber: 4,
      emptyWidget: emptyWidget,
      additionalOnRefresh: additionalOnRefresh,
    );
  }
}
