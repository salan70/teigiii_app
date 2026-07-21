import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/auth/application/auth_state.dart';
import '../../../feature/user_profile/application/user_profile_state.dart';
import '../../../feature/user_profile/presentation/avatar_network_image_widget.dart';
import '../../router/app_router.dart';

class ToProfileButton extends ConsumerWidget {
  const ToProfileButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      return const SizedBox.shrink();
    }

    final asyncProfile = ref.watch(userProfileProvider(userId));

    return asyncProfile.when(
      data: (profile) => IconButton(
        icon: AvatarNetworkImageWidget(
          imageUrl: profile.avatarUrl,
          userId: userId,
          avatarSize: AvatarSize.small,
        ),
        onPressed: () async {
          await context.pushRoute(ProfileTopRoute(targetUserId: userId));
        },
      ),
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
