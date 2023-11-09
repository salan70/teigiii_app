import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../core/common_widget/button/to_setting_button.dart';
import '../../../../../core/common_widget/stickey_tab_bar_deligate.dart';
import '../../../util/definition_feed_type.dart';
import '../../component/definition_list.dart';

@RoutePage()
class HomeRouterPage extends AutoRouter {
  const HomeRouterPage({super.key});
}

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool _) {
              return <Widget>[
                const SliverAppBar(
                  forceElevated: true,
                  elevation: 0,
                  title: Text('ホーム'),
                  leading: ToSettingButton(),
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
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                DefinitionList(
                  definitionFeedType: DefinitionFeedType.homeRecommend,
                ),
                DefinitionList(
                  definitionFeedType: DefinitionFeedType.homeFollowing,
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
