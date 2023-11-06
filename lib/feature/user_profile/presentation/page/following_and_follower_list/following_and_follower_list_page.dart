import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/stickey_tab_bar_deligate.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../util/profile_feed_type.dart';
import 'profile_list.dart';

@RoutePage()
class FollowingAndFollowerListPage extends ConsumerWidget {
  const FollowingAndFollowerListPage({
    super.key,
    this.willShowFollowing = true,
    required this.targetUserId,
  });

  final bool willShowFollowing;
  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider)!;

    return DefaultTabController(
      length: 2,
      initialIndex: willShowFollowing ? 0 : 1,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool _) {
              final isMyPage = currentUserId == targetUserId;

              return <Widget>[
                SliverAppBar(
                  forceElevated: true,
                  floating: true,
                  elevation: 0,
                  // TODO(me): ユーザー名を表示させる
                  title: const Text('プロフィール'),
                  actions: [
                    // 自分のフォロー/フォロー一覧画面の場合は編集ボタンを表示
                    isMyPage
                        ? IconButton(
                            icon: const Icon(CupertinoIcons.person_add),
                            onPressed: () {
                              // TODO(me): ユーザー検索画面を表示する
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickyTabBarDelegate(
                    tabBar: TabBar(
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'フォロー中'),
                        Tab(text: 'フォロワー'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                ProfileList(
                  userListType: UserListType.following,
                  targetUserId: targetUserId,
                ),
                ProfileList(
                  userListType: UserListType.follower,
                  targetUserId: targetUserId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
