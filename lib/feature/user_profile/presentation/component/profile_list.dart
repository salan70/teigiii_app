import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/button/follow_or_unfollow_button.dart';
import '../../../../core/common_widget/infinity_scroll_widget.dart';
import '../../../auth/application/auth_state.dart';
import '../../application/user_id_list_state.dart';
import '../../util/profile_feed_type.dart';
import '../page/following_and_follower_list/profile_tile.dart';
import '../page/following_and_follower_list/profile_tile_shimmer.dart';

class ProfileList extends ConsumerWidget {
  const ProfileList({
    super.key,
    required this.userListType,
    required this.targetUserId,
    required this.targetDefinitionId,
  });

  final UserListType userListType;
  final String? targetUserId;
  final String? targetDefinitionId;

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
      fetchMore: ref.watch(userIdListProvider.notifier).fetchMore,
      tileBuilder: (userId) {
        return ProfileTile(
          targetUserId: userId as String,
          button: currentUserId == userId
              ? const SizedBox.shrink()
              : FollowOrUnfollowButton(targetUserId: userId),
        );
      },
      shimmerTile: const ProfileTileShimmer(),
      shimmerTileNumber: 4,
    );
  }
}
