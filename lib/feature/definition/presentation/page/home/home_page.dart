import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../core/common_widget/button/to_setting_button.dart';
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ホーム'),
          leading: const ToSettingButton(),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.bell),
              onPressed: () {
                // TODO(me): 通知履歴画面へ遷移
              },
            ),
          ],
          bottom: TabBar(
            labelStyle: Theme.of(context).textTheme.titleMedium,
            indicatorWeight: 3,
            tabs: const <Widget>[
              Tab(text: 'おすすめ'),
              Tab(text: 'フォロー中'),
            ],
          ),
        ),
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
        floatingActionButton: const PostDefinitionFAB(definition: null),
      ),
    );
  }
}
