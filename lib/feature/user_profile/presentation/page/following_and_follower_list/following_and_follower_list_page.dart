import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/to_search_user_button.dart';
import '../../../../../core/common_widget/simple_widget_for_empty.dart';
import '../../../../../core/common_widget/stickey_tab_bar_deligate.dart';
import '../../../../../util/extension/scroll_controller_extension.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../application/user_profile_state.dart';
import '../../../util/user_list_type.dart';
import '../../component/profile_list.dart';

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
                    // 自分のフォロー/フォロー一覧画面の場合は編集ボタンを表示
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
                        if (DefaultTabController.of(context).indexIsChanging) {
                          // * タブを切り替えた場合
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
                ),
                ProfileList(
                  userListType: UserListType.follower,
                  targetUserId: targetUserId,
                  targetDefinitionId: null,
                  emptyWidget: const SimpleWidgetForEmpty(
                    message: 'フォロワーがいません🌴',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
