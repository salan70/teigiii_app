import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/telemetry/perf_screen_observer.dart';

class _TabsTestRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: const PageInfo('TabsHostRoute'),
          children: [
            AutoRoute(
              path: 'home',
              page: const PageInfo('HomeRouterRoute'),
              initial: true,
              children: [
                AutoRoute(
                  path: '',
                  page: const PageInfo('HomeRoute'),
                  initial: true,
                ),
                AutoRoute(
                  path: 'detail',
                  page: const PageInfo('HomeDetailRoute'),
                ),
              ],
            ),
            AutoRoute(
              path: 'dict',
              page: const PageInfo('DictionaryEveryoneRouterRoute'),
              children: [
                AutoRoute(
                  path: '',
                  page: const PageInfo('DictionaryEveryoneRoute'),
                  initial: true,
                ),
              ],
            ),
          ],
        ),
      ];

  @override
  Map<String, PageFactory> get pagesMap => {
        'TabsHostRoute': (data) => AutoRoutePage(
              routeData: data,
              child: const AutoTabsRouter(
                routes: [
                  _HomeRouterRoute(),
                  _DictionaryEveryoneRouterRoute(),
                ],
              ),
            ),
        'HomeRouterRoute': (data) => AutoRoutePage(
              routeData: data,
              child: const AutoRouter(),
            ),
        'HomeRoute': (data) => AutoRoutePage(
              routeData: data,
              child: const Text('HomeRoute'),
            ),
        'HomeDetailRoute': (data) => AutoRoutePage(
              routeData: data,
              child: const Text('HomeDetailRoute'),
            ),
        'DictionaryEveryoneRouterRoute': (data) => AutoRoutePage(
              routeData: data,
              child: const AutoRouter(),
            ),
        'DictionaryEveryoneRoute': (data) => AutoRoutePage(
              routeData: data,
              child: const Text('DictionaryEveryoneRoute'),
            ),
      };
}

class _HomeRouterRoute extends PageRouteInfo<void> {
  const _HomeRouterRoute({List<PageRouteInfo>? children})
      : super('HomeRouterRoute', initialChildren: children);
}

class _DictionaryEveryoneRouterRoute extends PageRouteInfo<void> {
  const _DictionaryEveryoneRouterRoute({List<PageRouteInfo>? children})
      : super('DictionaryEveryoneRouterRoute', initialChildren: children);
}

class _HomeDetailRoute extends PageRouteInfo<void> {
  const _HomeDetailRoute() : super('HomeDetailRoute');
}

Future<void> _pumpFrames(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  tearDown(PerfScreenObserver.sharedMemory.reset);

  testWidgets('タブ切替では wrapper ではなく active leaf route を通知する', (
    tester,
  ) async {
    // * Arrange
    final screens = <String>[];
    final router = _TabsTestRouter();
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router.config(
          navigatorObservers: () => [PerfScreenObserver(screens.add)],
        ),
      ),
    );
    await _pumpFrames(tester);
    expect(find.text('HomeRoute'), findsOneWidget);

    final tabsRouter = router.innerRouterOf<TabsRouter>('TabsHostRoute');
    expect(tabsRouter, isNotNull);
    final homeStack = tabsRouter!.innerRouterOf<StackRouter>(
      'HomeRouterRoute',
    );
    expect(homeStack, isNotNull);
    screens.clear();

    // Home タブで子スタックを積む。
    // push の Future は pop まで完了しないため await しない。
    unawaited(homeStack!.push(const _HomeDetailRoute()));
    await _pumpFrames(tester);
    expect(screens, contains('HomeDetailRoute'));
    screens.clear();

    // * Act
    tabsRouter.setActiveIndex(1);
    await _pumpFrames(tester);
    tabsRouter.setActiveIndex(0);
    await _pumpFrames(tester);

    // * Assert
    // wrapper 名（*RouterRoute）ではなく、表示中の leaf を記録する。
    expect(screens, isNot(contains('HomeRouterRoute')));
    expect(screens, isNot(contains('DictionaryEveryoneRouterRoute')));
    expect(screens, contains('DictionaryEveryoneRoute'));
    expect(screens.last, 'HomeDetailRoute');
  });
}
