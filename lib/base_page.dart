import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'feature/auth/application/auth_service.dart';

// 参考
// https://zenn.dev/flutteruniv_dev/articles/20230427-095829-flutter-auto-route#うまくいくパターン
@RoutePage()
class BaseRouterPage extends AutoRouter {
  const BaseRouterPage({super.key});
}

@RoutePage()
class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
  @override
  Widget build(BuildContext context) {
    final async = ref.watch(authServiceProvider);

    return async.when(
      data: (_) {
        return AutoTabsRouter(
          routes: const [
            HomeRouterRoute(),
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
              ],
            );
          },
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => const Scaffold(
        body: Center(
          child: Text('エラーが発生しました'),
        ),
      ),
    );
  }
}
