import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/common_widget/avatar_icon_widget.dart';
import 'core/common_widget/shimmer_widget.dart';
import 'core/router/app_router.dart';
import 'feature/auth/application/auth_service.dart';
import 'feature/auth/application/auth_state.dart';
import 'feature/user_profile/application/user_profile_state.dart';

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
                    selectedItemColor: Theme.of(context).colorScheme.onSurface,
                    elevation: 0.1,
                    selectedFontSize: 12,
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.house),
                        activeIcon: Icon(CupertinoIcons.house_fill),
                        label: 'ホーム',
                      ),
                      BottomNavigationBarItem(
                        icon: Consumer(
                          builder: (context, ref, child) {
                            final asyncTargetUserProfile =
                                ref.watch(userProfileProvider(currentUserId));
                            return asyncTargetUserProfile.when(
                              data: (targetUserProfile) {
                                return AvatarIconWidget(
                                  imageUrl: targetUserProfile.profileImageUrl,
                                  avatarSize: AvatarSize.small,
                                );
                              },
                              loading: () => const ShimmerWidget.circular(
                                width: 36,
                                height: 36,
                              ),
                              error: (error, stackTrace) {
                                return const SizedBox.shrink();
                              },
                            );
                          },
                        ),
                        label: 'マイ辞書',
                      ),
                      const BottomNavigationBarItem(
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
