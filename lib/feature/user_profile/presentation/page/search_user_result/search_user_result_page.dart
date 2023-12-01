import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../../util/logger.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../../user_follow/presentation/component/follow_or_unfollow_button.dart';
import '../../../application/user_profile_state.dart';
import '../../component/profile_tile.dart';
import '../../component/profile_tile_shimmer.dart';
import '../../component/search_user_text_field.dart';

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
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: asyncUserProfileByPublicId.when(
            data: (userId) {
              final currentUserId = ref.watch(userIdProvider)!;
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
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
