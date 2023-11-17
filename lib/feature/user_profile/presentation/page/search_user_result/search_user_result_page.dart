import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget/button/follow_or_unfollow_button.dart';
import '../../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../../util/logger.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../application/user_profile_state.dart';
import '../../component/search_user_text_field.dart';
import '../following_and_follower_list/profile_tile.dart';
import '../following_and_follower_list/profile_tile_shimmer.dart';

@RoutePage()
class SearchUserResultPage extends ConsumerWidget {
  const SearchUserResultPage({super.key, required this.searchWord});

  final String searchWord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserProfileByPublicId =
        ref.watch(userIdSearchByPublicIdProvider(searchWord));

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ユーザーを探す'),
        ),
        body: Padding(
          padding: REdgeInsets.only(left: 16, right: 16),
          child: asyncUserProfileByPublicId.when(
            data: (userId) {
              final currentUserId = ref.watch(userIdProvider)!;
              return ListView(
                children: [
                  Padding(
                    padding: REdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 36,
                    ),
                    child: SearchUserTextField(defaultText: searchWord),
                  ),
                  userId == null
                      ? Center(
                          child: Text(
                            'ユーザーが見つかりませんでした',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : ProfileTile(
                          targetUserId: userId,
                          button: currentUserId == userId
                              ? const SizedBox.shrink()
                              : FollowOrUnfollowButton(targetUserId: userId),
                        ),
                ],
              );
            },
            loading: ProfileTileShimmer.new,
            error: (error, stackTrace) {
              logger.e('[$searchWord]を検索時にエラーが発生しました。'
                  'error: $error, stackTrace: $stackTrace');
              return ErrorAndRetryWidget(
                onRetry: () =>
                    ref.invalidate(userIdSearchByPublicIdProvider(searchWord)),
              );
            },
          ),
        ),
      ),
    );
  }
}
