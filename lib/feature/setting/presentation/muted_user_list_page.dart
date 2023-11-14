import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/button/other_user_action_icon_button.dart';
import '../../../core/common_widget/error_and_retry_widget.dart';
import '../../../util/logger.dart';
import '../../user_config/application/user_config_state.dart';
import '../../user_profile/presentation/page/following_and_follower_list/profile_tile.dart';

@RoutePage()
class MutedUserListPage extends ConsumerWidget {
  const MutedUserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMutedUserIdList = ref.watch(mutedUserIdListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ミュート中のユーザー'),
      ),
      body: asyncMutedUserIdList.when(
        data: (mutedUserIdList) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: ListView.builder(
              itemCount: mutedUserIdList.length,
              itemBuilder: (context, index) {
                final mutedUserId = mutedUserIdList[index];
                return ProfileTile(
                  targetUserId: mutedUserId,
                  button: OtherUserActionIconButton(ownerId: mutedUserId),
                  transitionToProfilePage: false,
                );
              },
            ),
          );
        },
        error: (error, stackTrace) {
          // エラーが発生し、再読み込み中の場合
          if (asyncMutedUserIdList.isRefreshing) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          logger.e('ミュートユーザーの取得に失敗しました。'
              'error: $error, stackTrace: $stackTrace');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Align(
              alignment: Alignment.topCenter,
              child: ErrorAndRetryWidget(
                onRetry: () => ref.invalidate(mutedUserIdListProvider),
              ),
            ),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}
