import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/definition/presentation/post_definition_fab.dart';
import '../../feature/definition_list/presentation/definition_list.dart';
import '../../feature/definition_list/util/definition_feed_type.dart';
import '../../util/extension/scroll_controller_extension.dart';
import '../common_provider/key_provider.dart';
import '../common_provider/top_level_scroll_controller_provider.dart';
import '../common_widget/button/to_global_search_button.dart';
import '../common_widget/simple_empty_widget.dart';
import '../common_widget/stickey_tab_bar_deligate.dart';

@RoutePage()
class HomeRouterPage extends AutoRouter {
  const HomeRouterPage({super.key});
}

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            key: ref.watch(globalKeyProvider),
            controller: ref.watch(
              topLevelScrollControllerProvider(TopLevelTab.timeline),
            ),
            headerSliverBuilder: (BuildContext context, bool _) {
              return <Widget>[
                const SliverAppBar(
                  elevation: 0,
                  title: Text('タイムライン'),
                  automaticallyImplyLeading: false,
                  actions: [ToGlobalSearchButton()],
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickyTabBarDelegate(
                    tabBar: TabBar(
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: '見つける'),
                        Tab(text: 'フォロー中'),
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
            body: const TabBarView(
              children: <Widget>[
                DefinitionList(
                  definitionFeedType: DefinitionFeedType.homeRecommend,
                  emptyWidget: SimpleEmptyWidget(message: '新しい活動がありません。'),
                ),
                DefinitionList(
                  definitionFeedType: DefinitionFeedType.homeFollowing,
                  emptyWidget: SimpleEmptyWidget(
                    message: 'フォローしたユーザーの投稿が表示されます🏄‍♂',
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: const PostDefinitionFAB(),
      ),
    );
  }
}
