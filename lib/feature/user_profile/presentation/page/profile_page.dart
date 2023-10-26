import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_state.dart';
import '../../../definition/presentation/component/definition_list.dart';
import '../../../definition/util/definition_feed_type.dart';
import 'profile_widget.dart';

@RoutePage()
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(me): 雑に!使ってるが、問題ないか確認する
    final userId = ref.watch(userIdProvider)!;

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool _) {
              return <Widget>[
                const SliverAppBar(
                  forceElevated: true,
                  floating: true,
                  title: Text('プロフィール'),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [ProfileWidget(userId: userId)],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
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
            body: TabBarView(
              children: [
                DefinitionList(
                  definitionFeedType: DefinitionFeedType.homeRecommend,
                ),
                DefinitionList(
                  definitionFeedType: DefinitionFeedType.homeFollowing,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// SliverPersistentHeaderDelegateが必要なため、SliverPersistentHeaderを
/// 継承したクラスを作成
/// 参考: https://zenn.dev/wakanao/articles/0ff4bc3f08f34a#_tabsection()について
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate({required this.tabBar});

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.3,
          ),
        ),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
