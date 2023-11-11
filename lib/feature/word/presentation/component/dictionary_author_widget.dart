import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/avatar_network_image_widget.dart';
import '../../../../core/router/app_router.dart';
import '../../../user_profile/application/user_profile_state.dart';

class DictionaryAuthorWidget extends ConsumerWidget {
  const DictionaryAuthorWidget({
    super.key,
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTargetUserProfile = ref.watch(userProfileProvider(targetUserId));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Written by',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 16),
        asyncTargetUserProfile.when(
          data: (targetUserProfile) {
            return InkWell(
              onTap: () {
                context.pushRoute(
                  ProfileRoute(
                    targetUserId: targetUserProfile.id,
                  ),
                );
              },
              child: Row(
                children: [
                  AvatarNetworkImageWidget(
                    imageUrl: targetUserProfile.profileImageUrl,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    targetUserProfile.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => const Text('エラーが発生しました'),
        ),
      ],
    );
  }
}
