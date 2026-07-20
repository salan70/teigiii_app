import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/auth/application/auth_state.dart';
import '../../util/extension/scroll_controller_extension.dart';
import '../common_provider/key_provider.dart';
import '../common_provider/top_level_scroll_controller_provider.dart';
import '../router/app_router.dart';

// 参考
// https://zenn.dev/flutteruniv_dev/articles/20230427-095829-flutter-auto-route#うまくいくパターン
@RoutePage()
class BaseRouterPage extends AutoRouter {
  const BaseRouterPage({super.key});
}

/// @doc doc/specs/mobile-app-functional-spec.md#2-2-最上位ナビゲーション
@RoutePage()
class BasePage extends ConsumerWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider);
    return currentUserId == null
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : AutoTabsRouter(
            routes: [
              DictionaryIndividualRouterRoute(
                children: [
                  DictionaryIndividualRoute(
                    targetUserId: currentUserId,
                    isTopRoute: true,
                  ),
                ],
              ),
              const DictionaryEveryoneRouterRoute(),
              const HomeRouterRoute(),
            ],
            builder: (context, child) {
              final tabsRouter = context.tabsRouter;
              return WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  body: ScaffoldMessenger(
                    key: ref.watch(
                      scaffoldMessengerKeyProvider(
                        ScaffoldMessengerType.baseRoute,
                      ),
                    ),
                    child: child,
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.menu_book_outlined),
                        activeIcon: Icon(Icons.menu_book),
                        label: 'あなたの辞書',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.people_outline),
                        activeIcon: Icon(Icons.people),
                        label: 'みんなの辞書',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dynamic_feed_outlined),
                        activeIcon: Icon(Icons.dynamic_feed),
                        label: 'タイムライン',
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

                        final scrollController = ref.read(
                          topLevelScrollControllerProvider(
                            TopLevelTab.values[index],
                          ),
                        );
                        if (scrollController.hasClients) {
                          scrollController.scrollToTop();
                        }
                        return;
                      }
                      // 選択中でないタブをTapした場合
                      tabsRouter.setActiveIndex(index);
                    },
                  ),
                ),
              );
            },
          );
  }
}
