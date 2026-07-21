import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/definition/presentation/post_definition_fab.dart';
import '../../feature/definition_list/presentation/definition_list.dart';
import '../../feature/definition_list/util/definition_feed_type.dart';
import '../../feature/timeline/presentation/discover_timeline_list.dart';
import '../../util/extension/scroll_controller_extension.dart';
import '../common_provider/key_provider.dart';
import '../common_widget/button/to_profile_button.dart';
import '../common_widget/button/to_setting_button.dart';
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
            headerSliverBuilder: (BuildContext context, bool _) {
              return <Widget>[
                const SliverAppBar(
                  elevation: 0,
                  title: Text('タイムライン'),
                  leading: ToSettingButton(),
                  actions: [ToProfileButton()],
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickyTabBarDelegate(
                    tabBar: TabBar(
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'おすすめ'),
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
                DiscoverTimelineList(
                  emptyWidget: SimpleEmptyWidget(message: 'おすすめの投稿がありません...'),
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
