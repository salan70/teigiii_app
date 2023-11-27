import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/user_profile/application/user_follow_service.dart';
import '../../../feature/user_profile/application/user_profile_state.dart';
import '../shimmer_widget.dart';
import 'primary_filled_button.dart';
import 'primary_outlined_button.dart';

class FollowOrUnfollowButton extends ConsumerWidget {
  const FollowOrUnfollowButton({
    super.key,
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFollowing = ref.watch(isFollowingProvider(targetUserId));

    return isFollowing.maybeWhen(
      data: (isFollowing) {
        return isFollowing
            ? _UnfollowButton(targetUserId: targetUserId)
            : _FollowButton(targetUserId: targetUserId);
      },
      orElse: () => ShimmerWidget.circular(
        width: 144,
        height: 40,
        shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
      ),
    );
  }
}

class _FollowButton extends ConsumerWidget {
  const _FollowButton({
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryFilledButton(
      text: 'フォローする',
      onPressed: () async {
        await ref.read(userFollowServiceProvider.notifier).follow(targetUserId);
      },
    );
  }
}

class _UnfollowButton extends ConsumerWidget {
  const _UnfollowButton({
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryOutlinedButton(
      text: 'フォロー解除',
      onPressed: () async {
        await ref
            .read(userFollowServiceProvider.notifier)
            .unfollow(targetUserId);
      },
    );
  }
}
