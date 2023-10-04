import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'router/app_router.dart';

// 参考
// https://zenn.dev/flutteruniv_dev/articles/20230427-095829-flutter-auto-route#うまくいくパターン
@RoutePage()
class BaseRouterPage extends AutoRouter {
  const BaseRouterPage({super.key});
}

@RoutePage()
class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        ProfileRoute(),
        IndexRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = context.tabsRouter;
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            selectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'ホーム',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'マイページ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'さがす',
              ),
            ],
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
          ),
        );
      },
    );
  }
}
