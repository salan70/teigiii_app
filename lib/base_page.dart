import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'feature/auth/application/auth_service.dart';
import 'feature/auth/application/auth_state.dart';

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
        // TODO(me): 雑に!使ってるが、問題ないか確認する
        final currentUserId = ref.watch(userIdProvider)!;
        return AutoTabsRouter(
          routes: [
            const HomeRouterRoute(),
            ProfileRouterRoute(
              children: [
                ProfileRoute(targetUserId: currentUserId, isHome: true),
              ],
            ),
            const IndexTopRouterRoute(),
          ],
          builder: (context, child) {
            final tabsRouter = context.tabsRouter;
            return Stack(
              children: [
                Scaffold(
                  body: child,
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 0.1,
                    selectedFontSize: 12,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.house),
                        activeIcon: Icon(CupertinoIcons.house_fill),
                        label: 'ホーム',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.person),
                        activeIcon: Icon(CupertinoIcons.person_fill),
                        label: 'マイページ',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.search),
                        label: 'さがす',
                      ),
                    ],
                    currentIndex: tabsRouter.activeIndex,
                    onTap: (index) {
                      // 選択中のタブをTapした場合
                      if (tabsRouter.activeIndex == index) {
                        // ネストされたルーターのスタック情報を破棄
                        tabsRouter
                            .innerRouterOf<StackRouter>(tabsRouter.current.name)
                            ?.popUntilRoot();

                        return;
                      }
                      // 選択中でないタブをTapした場合
                      tabsRouter.setActiveIndex(index);
                    },
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
