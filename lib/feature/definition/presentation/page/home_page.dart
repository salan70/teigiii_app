import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO(me): 設定画面へ遷移
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
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
        body: const TabBarView(
          children: <Widget>[
            Center(child: Text('おすすめ', style: TextStyle(fontSize: 50))),
            Center(child: Text('フォロー中', style: TextStyle(fontSize: 50))),
          ],
        ),
      ),
    );
  }
}
