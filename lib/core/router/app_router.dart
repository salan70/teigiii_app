import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../base_page.dart';
import '../../feature/definition/domain/definition.dart';
import '../../feature/definition/presentation/page/definition_detail/definition_detail_page.dart';
import '../../feature/definition/presentation/page/home/home_page.dart';
import '../../feature/definition/presentation/page/index/index_page.dart';
import '../../feature/definition/presentation/page/profile/profile_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: BaseRoute.page,
          children: [
            AutoRoute(
              path: 'home',
              page: HomeRouterRoute.page,
              children: [
                AutoRoute(
                  initial: true,
                  page: HomeRoute.page,
                ),
                AutoRoute(
                  path: 'definition_detail',
                  page: DefinitionDetailRoute.page,
                ),
              ],
            ),
            AutoRoute(
              path: 'profile',
              page: ProfileRoute.page,
            ),
            AutoRoute(
              path: 'index',
              page: IndexRoute.page,
            ),
          ],
        ),
      ];
}
