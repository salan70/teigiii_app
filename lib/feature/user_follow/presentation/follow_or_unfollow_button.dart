import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/button/filled_button.dart';
import '../../../../core/common_widget/button/outlined_button.dart';
import '../../../../core/common_widget/shimmer_widget.dart';
import '../../../../util/mixin/presentation_mixin.dart';
import '../application/user_follow_service.dart';
import '../application/user_follow_state.dart';

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

class _FollowButton extends ConsumerWidget with PresentationMixin {
  const _FollowButton({
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryFilledButton(
      text: 'フォローする',
      onPressed: () async {
        await executeWithOverlayLoading(
          ref,
          action: () async =>
              ref.read(userFollowServiceProvider).follow(targetUserId),
          errorLogMessage: 'フォローが失敗しました。もう一度お試しください。',
          errorToastMessage: 'フォロー時にエラーが発生。',
        );
      },
    );
  }
}

class _UnfollowButton extends ConsumerWidget with PresentationMixin {
  const _UnfollowButton({
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryOutlinedButton(
      text: 'フォロー解除',
      onPressed: () async {
        await executeWithOverlayLoading(
          ref,
          action: () async =>
              ref.read(userFollowServiceProvider).unfollow(targetUserId),
          errorLogMessage: 'フォロー解除が失敗しました。もう一度お試しください。',
          errorToastMessage: 'フォロー解除時にエラーが発生。',
        );
      },
    );
  }
}
