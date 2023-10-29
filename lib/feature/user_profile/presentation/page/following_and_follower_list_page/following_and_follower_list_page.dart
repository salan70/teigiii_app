import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/stickey_tab_bar_deligate.dart';
import '../../../../auth/application/auth_state.dart';

@RoutePage()
class FollowingAndFollowerListPage extends ConsumerWidget {
  const FollowingAndFollowerListPage({super.key, required this.targetUserId});

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider)!;

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool _) {
              final isMyPage = currentUserId == targetUserId;

              return <Widget>[
                SliverAppBar(
                  forceElevated: true,
                  floating: true,
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
                        Tab(text: '投稿'),
                        Tab(text: 'いいね'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: const TabBarView(
              children: [
                SizedBox(
                  height: 1200,
                  child: Center(child: Text('フォロー中')),
                ),
                SizedBox(
                  height: 1200,
                  child: Center(child: Text('フォロワー')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
