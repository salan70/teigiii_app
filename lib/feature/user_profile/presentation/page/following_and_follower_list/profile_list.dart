import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/cupertino_refresh_indicator.dart';
import '../../../../../core/common_widget/infinite_scroll_bottom_indicator.dart';
import '../../../../../util/logger.dart';
import '../../../application/user_id_list_state.dart';
import '../../../util/profile_feed_type.dart';
import 'profile_tile.dart';

class ProfileList extends ConsumerWidget {
  ProfileList({
    super.key,
    required this.userListType,
    required this.targetUserId,
  });

  final String targetUserId;

  final UserListType userListType;
  final scrollController = ScrollController();
  // エラーが発生してリビルドした際、スクロール位置を保持するためのキー
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserIdListState = ref.watch(
      UserIdListStateNotifierProvider(
        userListType,
        targetUserId: targetUserId,
        definitionId: null,
      ),
    );

    return asyncUserIdListState.when(
      data: (userIdListState) {
        final userIdList = userIdListState.userIdList;

        return NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            // 画面の一番下までスクロールしたかどうかを判定
            if (notification.metrics.extentAfter == 0) {
              ref
                  .read(
                    userIdListStateNotifierProvider(
                      userListType,
                      targetUserId: targetUserId,
                      definitionId: null,
                    ).notifier,
                  )
                  .fetchMore();
              return true;
            }
            return false;
          },
          child: Scrollbar(
            key: globalKey,
            controller: scrollController,
            child: CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  builder: buildCustomRefreshIndicator,
                  onRefresh: () async {
                    ref.invalidate(
                      userIdListStateNotifierProvider(
                        userListType,
                        targetUserId: targetUserId,
                        definitionId: null,
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userIdList.length,
                    itemBuilder: (context, index) {
                      return ProfileTile(
                        targetUserId: userIdList[index],
                      );
                    },
                  ),
                ),
                InfiniteScrollBottomIndicator(hasMore: userIdListState.hasMore),
              ],
            ),
          ),
        );
      },
      error: (error, _) {
        logger.e('$error');

        // 取得済みのデータがない（初回読み込みが失敗した）場合のエラー表示
        // TODO(me): エラー画面を表示させる
        return Center(
          child: Text(
            error.toString(),
          ),
        );
      },
      loading: () {
        return const CupertinoActivityIndicator();
      },
    );
  }
}
