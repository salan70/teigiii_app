import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/common_provider/toast_controller.dart';
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(toastControllerProvider.notifier).initFToast(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(authServiceProvider);

    return async.when(
      data: (_) {
        final currentUserId = ref.watch(userIdProvider)!;
        return AutoTabsRouter(
          routes: [
            const HomeRouterRoute(),
            IndividualDictionaryRouterRoute(
              children: [
                IndividualDictionaryRoute(
                  targetUserId: currentUserId,
                  isTopRoute: true,
                ),
              ],
            ),
            const EveryoneDictionaryRouterRoute(),
          ],
          builder: (context, child) {
            final tabsRouter = context.tabsRouter;
            return Stack(
              children: [
                Scaffold(
                  body: child,
                  bottomNavigationBar: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.house),
                        activeIcon: Icon(CupertinoIcons.house_fill),
                        label: 'ホーム',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.person),
                        activeIcon: Icon(CupertinoIcons.person_fill),
                        label: 'あなたの辞書',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.person_3),
                        activeIcon: Icon(CupertinoIcons.person_3_fill),
                        label: 'みんなの辞書',
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

class IndexTopRouterRoute {
  const IndexTopRouterRoute();
}
