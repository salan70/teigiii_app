import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../base_page.dart';
import '../../feature/definition/presentation/page/definition_detail/definition_detail_page.dart';
import '../../feature/definition/presentation/page/home/home_page.dart';
import '../../feature/definition/presentation/page/post_definition/post_definition_page.dart';
import '../../feature/setting/presentation/license_page.dart';
import '../../feature/setting/presentation/setting_page.dart';
import '../../feature/user_profile/presentation/page/following_and_follower_list_page/following_and_follower_list_page.dart';
import '../../feature/user_profile/presentation/page/profile_page/profile_page.dart';
import '../../feature/word/presentation/page/index_second_page/index_second_page.dart';
import '../../feature/word/presentation/page/index_top_page/index_top_page.dart';
import '../../feature/word/presentation/page/search_word_result_page.dart';
import '../../feature/word/presentation/page/word_list_page/word_list_page.dart';
import '../../feature/word/util/initial_main_group.dart';

part 'app_router.g.dart';
part 'app_router.gr.dart';

@riverpod
AppRouter appRouter(AppRouterRef ref) => AppRouter();

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
                AutoRoute(
                  // TODO(me): pathをuserIdにする
                  path: 'profile',
                  page: ProfileRoute.page,
                ),
                AutoRoute(
                  path: 'following_and_follower_list',
                  page: FollowingAndFollowerListRoute.page,
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
                AutoRoute(
                  path: 'following_and_follower_list',
                  page: FollowingAndFollowerListRoute.page,
                ),
              ],
            ),
            AutoRoute(
              path: 'index',
              page: IndexTopRouterRoute.page,
              children: [
                AutoRoute(
                  initial: true,
                  page: IndexTopRoute.page,
                ),
                AutoRoute(
                  path: 'index_second',
                  page: IndexSecondRoute.page,
                ),
                AutoRoute(
                  path: 'word_list',
                  page: WordListRoute.page,
                ),
                AutoRoute(
                  path: 'search_word_result',
                  page: SearchWordResultRoute.page,
                ),
              ],
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
        AutoRoute(
          path: '/post_definition',
          page: PostDefinitionRoute.page,
          fullscreenDialog: true,
        ),
      ];
}
