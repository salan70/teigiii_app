import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/router/app_router.dart';
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
          leading: IconButton(
            icon: const Icon(CupertinoIcons.gear_solid),
            onPressed: () async {
              await context.navigateTo(
                const HomeRouterRoute(
                  children: [
                    SettingRoute(),
                  ],
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.bell),
              onPressed: () {
                // TODO(me): 通知履歴画面へ遷移
              },
            ),
          ],
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
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
      ),
    );
  }
}
