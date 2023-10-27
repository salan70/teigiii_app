import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../base_page.dart';
import '../../feature/definition/presentation/page/definition_detail/definition_detail_page.dart';
import '../../feature/definition/presentation/page/home/home_page.dart';
import '../../feature/definition/presentation/page/index/index_page.dart';
import '../../feature/setting/presentation/license_page.dart';
import '../../feature/setting/presentation/setting_page.dart';
import '../../feature/user_profile/presentation/page/profile_page.dart';

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
                  // TODO(me): pathをdefinitionIdにする
                  path: 'definition_detail',
                  page: DefinitionDetailRoute.page,
                ),
              ],
            ),
            AutoRoute(
              path: 'profile',
              page: ProfileRouterRoute.page,
              children: [
                AutoRoute(
                  initial: true,
                  page: ProfileRoute.page,
                ),
                AutoRoute(
                  // TODO(me): pathをdefinitionIdにする
                  path: 'definition_detail',
                  page: DefinitionDetailRoute.page,
                ),
              ],
            ),
            AutoRoute(
              path: 'index',
              page: IndexRoute.page,
            ),
          ],
        ),
        AutoRoute(
          path: '/setting',
          page: SettingRouterRoute.page,
          fullscreenDialog: true,
          children: [
            AutoRoute(
              initial: true,
              page: SettingRoute.page,
            ),
            AutoRoute(
              path: 'license',
              page: MyLicenseRoute.page,
            ),
          ],
        ),
      ];
}
