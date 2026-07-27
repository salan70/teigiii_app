import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../../../util/logger.dart';
import '../../feature/auth/application/auth_state.dart';
import '../../feature/user_follow/presentation/follow_or_unfollow_button.dart';
import '../../feature/user_profile/presentation/profile_tile.dart';
import '../../feature/user_profile/presentation/profile_tile_shimmer.dart';
import '../../feature/user_search/application/user_search_state.dart';
import '../../feature/user_search/presentation/search_user_text_field.dart';
import '../design_system/design_system.dart';

@RoutePage()
class UserSearchResultPage extends ConsumerWidget {
  const UserSearchResultPage({super.key, required this.searchWord});

  final String searchWord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserProfileByPublicId = ref.watch(
      userIdSearchByPublicIdProvider(searchWord),
    );

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('ユーザーを探す')),
        // 検索欄は DsSearchField が左右 40 を持つ。リスト本文だけ
        // screenHorizontal（16）を付ける（WordSearchResultPage と同じ分離）。
        body: asyncUserProfileByPublicId.when(
          data: (userId) {
            final currentUserId = ref.watch(userIdProvider)!;
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: DsSpacing.section,
                  ),
                  child: SearchUserTextField(defaultText: searchWord),
                ),
                Padding(
                  padding: DsSpacing.screenHorizontalInsets,
                  child: userId == null
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
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: DsSpacing.screenHorizontalInsets,
            child: ProfileTileShimmer(),
          ),
          error: (error, stackTrace) {
            logger.e(
              '[$searchWord]を検索時にエラーが発生しました。'
              'error: $error, stackTrace: $stackTrace',
            );
            return Padding(
              padding: DsSpacing.screenHorizontalInsets,
              child: ErrorAndRetryWidget.cannotInquire(
                onRetry: () =>
                    ref.invalidate(userIdSearchByPublicIdProvider(searchWord)),
              ),
            );
          },
        ),
      ),
    );
  }
}
