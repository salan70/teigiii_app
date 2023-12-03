import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/auth/application/auth_state.dart';
import '../../util/extension/scroll_controller_extension.dart';
import '../common_provider/key_provider.dart';
import '../common_provider/toast_controller.dart';
import '../router/app_router.dart';

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
    final currentUserId = ref.watch(userIdProvider);
    return currentUserId == null
        ? const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        : AutoTabsRouter(
            routes: [
              const HomeRouterRoute(),
              DictionaryIndividualRouterRoute(
                children: [
                  DictionaryIndividualRoute(
                    targetUserId: currentUserId,
                    isTopRoute: true,
                  ),
                ],
              ),
              const DictionaryEveryoneRouterRoute(),
            ],
            builder: (context, child) {
              final tabsRouter = context.tabsRouter;
              return Stack(
                children: [
                  WillPopScope(
                    onWillPop: () async => false,
                    child: Scaffold(
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
                                .innerRouterOf<StackRouter>(
                                  tabsRouter.current.name,
                                )
                                ?.popUntilRoot();

                            PrimaryScrollController.of(
                              ref.read(globalKeyProvider).currentContext!,
                            ).scrollToTop();
                            return;
                          }
                          // 選択中でないタブをTapした場合
                          tabsRouter.setActiveIndex(index);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
  }
}
