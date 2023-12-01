import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/common_provider/key_provider.dart';
import '../core/common_provider/toast_controller.dart';
import '../core/common_widget/dialog/loading_dialog.dart';
import '../core/common_widget/error_and_retry_widget.dart';
import '../core/router/app_router.dart';
import '../feature/auth/application/auth_service.dart';
import '../feature/auth/application/auth_state.dart';
import '../util/extension/scroll_controller_extension.dart';
import '../util/logger.dart';

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
  /// ユーザーの初期処理が完了したかどうか
  bool _doneInit = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(toastControllerProvider.notifier).initFToast(context);
      await ref.read(authServiceProvider.notifier).onAppLaunch();
      setState(() {
        _doneInit = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(authServiceProvider);

    return async.when(
      data: (_) {
        if (!ref.watch(isSignedInProvider)) {
          // * サインインしていない場合
          return const Scaffold(body: OverlayLoadingWidget());
        }

        // * サインインしている場合
        // 本当は [async] のstateで制御したかったが、
        // 処理の途中でAsyncLoadingが勝手にAsyncDataになるため、
        // [_doneInit] を作成して制御している
        if (!_doneInit) {
          return const Scaffold(body: OverlayLoadingWidget());
        }
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
      },
      loading: () => const Scaffold(body: OverlayLoadingWidget()),
      error: (error, stack) {
        logger.e('サインイン時にエラーが発生しました。'
            ' error: $error, stackTrace: $stack');
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ErrorAndRetryWidget(
                  onRetry: () async {
                    setState(() {
                      _doneInit = false;
                    });
                    await ref.read(authServiceProvider.notifier).onAppLaunch();
                    setState(() {
                      _doneInit = true;
                    });
                  },
                  showInquireButton: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
