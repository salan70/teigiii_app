import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/router/app_router.dart';
import '../../user_profile/presentation/avatar_network_image_widget.dart';
import '../domain/user_search_result.dart';

class UserSearchResultTile extends StatelessWidget {
  const UserSearchResultTile({super.key, required this.result});

  final UserSearchResult result;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushRoute(ProfileTopRoute(targetUserId: result.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            AvatarNetworkImageWidget(
              imageUrl: result.avatarUrl,
              userId: result.id,
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'ID ${result.publicId}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
