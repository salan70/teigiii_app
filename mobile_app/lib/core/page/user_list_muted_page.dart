import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../util/logger.dart';
import '../../feature/user_config/application/user_config_state.dart';
import '../../feature/user_config/presentation/other_user_action_icon_button.dart';
import '../../feature/user_profile/presentation/profile_tile.dart';
import '../design_system/design_system.dart';

@RoutePage()
class UserListMutedPage extends ConsumerWidget {
  const UserListMutedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMutedUserIdList = ref.watch(mutedUserIdListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ミュート中のユーザー')),
      body: asyncMutedUserIdList.when(
        data: (mutedUserIdList) {
          if (mutedUserIdList.isEmpty) {
            return const DsEmptyView(message: 'ミュート中のユーザーはいません。🌻');
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: mutedUserIdList.length,
              itemBuilder: (context, index) {
                final mutedUserId = mutedUserIdList[index];
                return ProfileTile(
                  targetUserId: mutedUserId,
                  button: OtherUserActionIconButton(
                    ownerId: mutedUserId,
                    inBaseRoute: false,
                  ),
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.topCenter,
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          logger.e(
            'ミュートユーザーの取得に失敗しました。'
            'error: $error, stackTrace: $stackTrace',
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.topCenter,
              child: ErrorAndRetryWidget.cannotInquire(
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
