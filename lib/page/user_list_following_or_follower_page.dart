import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/button/to_search_user_button.dart';
import '../../../core/common_widget/simple_widget_for_empty.dart';
import '../../../core/common_widget/stickey_tab_bar_deligate.dart';
import '../../../util/extension/scroll_controller_extension.dart';
import '../feature/auth/application/auth_state.dart';
import '../feature/user_follow/application/user_follow_state.dart';
import '../feature/user_list/presentation/profile_list.dart';
import '../feature/user_list/util/user_list_type.dart';
import '../feature/user_profile/application/user_profile_state.dart';

@RoutePage()
class UserListFollowingOrFollowerPage extends ConsumerWidget {
  const UserListFollowingOrFollowerPage({
    super.key,
    required this.initialTab,
    required this.targetUserId,
  });

  /// 最初に表示させるタブ。
  final FollowingAndFollowerListTab initialTab;
  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider)!;

    return DefaultTabController(
      length: 2,
      initialIndex: initialTab.tabIndex,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool _) {
              final isMyPage = currentUserId == targetUserId;

              return <Widget>[
                SliverAppBar(
                  forceElevated: true,
                  floating: true,
                  elevation: 0,
                  title: Consumer(
                    builder: (context, ref, child) {
                      return ref
                          .watch(userProfileProvider(targetUserId))
                          .maybeWhen(
                            data: (userProfile) {
                              return Text(userProfile.name);
                            },
                            orElse: SizedBox.shrink,
                          );
                    },
                  ),
                  actions: [
                    isMyPage
                        ? const ToSearchUserButton()
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
                      onTap: (_) {
                        // * タブを切り替えた場合
                        if (DefaultTabController.of(context).indexIsChanging) {
                          return;
                        }

                        // * 同じタブをタップした場合
                        PrimaryScrollController.of(context).scrollToTop();
                      },
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
                  targetDefinitionId: null,
                  emptyWidget: const SimpleWidgetForEmpty(
                    message: 'フォロー中のユーザーがいません🌱',
                  ),
                  additionalOnRefresh: () =>
                      ref.invalidate(followCountProvider(targetUserId)),
                ),
                ProfileList(
                  userListType: UserListType.follower,
                  targetUserId: targetUserId,
                  targetDefinitionId: null,
                  emptyWidget: const SimpleWidgetForEmpty(
                    message: 'フォロワーがいません🌴',
                  ),
                  additionalOnRefresh: () =>
                      ref.invalidate(followCountProvider(targetUserId)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum FollowingAndFollowerListTab {
  following,
  follower;

  int get tabIndex {
    switch (this) {
      case FollowingAndFollowerListTab.following:
        return 0;
      case FollowingAndFollowerListTab.follower:
        return 1;
    }
  }
}
