import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/other_user_action_icon_button.dart';
import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../core/common_widget/stickey_tab_bar_deligate.dart';
import '../../../../../util/logger.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../../definition/presentation/component/definition_list.dart';
import '../../../../definition/util/definition_feed_type.dart';
import '../../../application/user_profile_state.dart';
import 'profile_widget.dart';

@RoutePage()
class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    super.key,
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider)!;
    final asyncTargetUserProfile = ref.watch(userProfileProvider(targetUserId));

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool _) {
              final isMyProfile = currentUserId == targetUserId;

              return <Widget>[
                SliverAppBar(
                  forceElevated: true,
                  floating: true,
                  title: asyncTargetUserProfile.when(
                    data: (targetUserProfile) {
                      return Text(
                        targetUserProfile.name,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                    loading: () => const Text(''),
                    error: (error, _) {
                      logger.e(error);
                      return const Text('エラー');
                    },
                  ),
                  actions: [
                    // 自分のプロフィールの場合は編集ボタンを表示
                    isMyProfile
                        ? IconButton(
                            icon: const Icon(CupertinoIcons.person_add),
                            onPressed: () {
                              // TODO(me): ユーザー検索画面を表示する
                            },
                          )
                        : OtherUserActionIconButton(ownerId: targetUserId),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [ProfileWidget(targetUserId: targetUserId)],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickyTabBarDelegate(
                    tabBar: TabBar(
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: '投稿順'),
                        Tab(text: 'いいね'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                DefinitionList(
                  definitionFeedType:
                      DefinitionFeedType.profileOrderByCreatedAt,
                  targetUserId: targetUserId,
                ),
                DefinitionList(
                  definitionFeedType: DefinitionFeedType.profileLiked,
                  targetUserId: targetUserId,
                ),
              ],
            ),
          ),
          floatingActionButton: const PostDefinitionFAB(definition: null),
        ),
      ),
    );
  }
}
