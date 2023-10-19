import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/common_provider/is_loading_overlay_state.dart';
import 'core/common_widget/loading_dialog.dart';
import 'core/router/app_router.dart';

// 参考
// https://zenn.dev/flutteruniv_dev/articles/20230427-095829-flutter-auto-route#うまくいくパターン
@RoutePage()
class BaseRouterPage extends AutoRouter {
  const BaseRouterPage({super.key});
}

@RoutePage()
class BasePage extends ConsumerWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        ProfileRoute(),
        IndexRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = context.tabsRouter;
        return Stack(
          children: [
            Scaffold(
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
            ),
            if (ref.watch(isLoadingOverlayNotifierProvider))
              const OverlayLoadingWidget(),
          ],
        );
      },
    );
  }
}
