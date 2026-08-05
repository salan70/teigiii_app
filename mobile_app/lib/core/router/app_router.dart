import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../feature/definition/domain/definition.dart';
import '../../feature/definition/domain/definition_for_write.dart';
import '../../feature/definition/presentation/write_definition_base_page.dart';
import '../../feature/definition/util/after_post_navigation_type.dart';
import '../page/base_page.dart';
import '../page/definition_detail_page.dart';
import '../page/definition_edit_page.dart';
import '../page/definition_post_page.dart';
import '../page/dictionary_everyone_page.dart';
import '../page/dictionary_individual_page.dart';
import '../page/home_page.dart';
import '../page/license_page.dart';
import '../page/profile_edit_page.dart';
import '../page/profile_top_page.dart';
import '../page/setting_page.dart';
import '../page/sign_in_failure_page.dart';
import '../page/user_list_following_or_follower_page.dart';
import '../page/user_list_liked_page.dart';
import '../page/user_list_muted_page.dart';
import '../page/user_search_page.dart';
import '../page/user_search_result_page.dart';
import '../page/user_word_definition_list_page.dart';
import '../page/welcome_page.dart';
import '../page/word_registration_page.dart';
import '../page/word_search_result_page.dart';
import '../page/word_top_page.dart';
import 'auth_guard.dart';
import 'first_launch_guard.dart';

part 'app_router.g.dart';
part 'app_router.gr.dart';

@riverpod
Raw<AppRouter> appRouter(AppRouterRef ref) => AppRouter(ref);

// TODO(me): 一部Routeのpathにidを含める
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this.ref);

  final Ref ref;

  final List<AutoRoute> commonRouteList = [
    AdaptiveRoute<dynamic>(
      path: 'definition_detail',
      page: DefinitionDetailRoute.page,
    ),
    AdaptiveRoute<dynamic>(
      path: 'user_list_liked',
      page: UserListLikedRoute.page,
    ),
    AdaptiveRoute<dynamic>(path: 'word_top', page: WordTopRoute.page),
    AdaptiveRoute<dynamic>(
      path: 'user_word_definition_list',
      page: UserWordDefinitionListRoute.page,
    ),
    AdaptiveRoute<dynamic>(path: 'profile_top', page: ProfileTopRoute.page),
    AdaptiveRoute<dynamic>(
      path: 'user_list_following_or_follower',
      page: UserListFollowingOrFollowerRoute.page,
    ),
    AdaptiveRoute<dynamic>(path: 'user_search', page: UserSearchRoute.page),
    AdaptiveRoute<dynamic>(
      path: 'user_search_result',
      page: UserSearchResultRoute.page,
    ),
  ];

  /// 全画面モーダルの上に積むためのルート。[commonRouteList] と同じ画面を root にも置く。
  ///
  /// `/word_registration` などのモーダルは root 直下にあり、タブ配下の nested router を
  /// 持たない。これがないとモーダル上からの push が破棄済みの nested router に落ち、
  /// 白画面になる（#306）。
  final List<AutoRoute> modalStackRouteList = [
    AdaptiveRoute<dynamic>(
      path: '/modal/definition_detail',
      page: DefinitionDetailRoute.page,
    ),
    AdaptiveRoute<dynamic>(
      path: '/modal/user_list_liked',
      page: UserListLikedRoute.page,
    ),
    AdaptiveRoute<dynamic>(path: '/modal/word_top', page: WordTopRoute.page),
    AdaptiveRoute<dynamic>(
      path: '/modal/profile_top',
      page: ProfileTopRoute.page,
    ),
    AdaptiveRoute<dynamic>(
      path: '/modal/user_list_following_or_follower',
      page: UserListFollowingOrFollowerRoute.page,
    ),
    AdaptiveRoute<dynamic>(
      path: '/modal/user_word_definition_list',
      page: UserWordDefinitionListRoute.page,
    ),
  ];

  @override
  List<AutoRoute> get routes => [
    AdaptiveRoute<dynamic>(path: '/welcome', page: WelcomeRoute.page),
    AdaptiveRoute<dynamic>(
      path: '/',
      page: BaseRoute.page,
      guards: [ref.read(firstLaunchGuardProvider), ref.read(authGuardProvider)],
      children: [
        AdaptiveRoute<dynamic>(
          path: 'home',
          page: HomeRouterRoute.page,
          children: [
            AdaptiveRoute<dynamic>(initial: true, page: HomeRoute.page),
            AdaptiveRoute<dynamic>(
              path: 'dictionary_individual',
              page: DictionaryIndividualRoute.page,
            ),
            ...commonRouteList,
          ],
        ),
        AdaptiveRoute<dynamic>(
          path: 'dictionary_individual',
          page: DictionaryIndividualRouterRoute.page,
          children: [
            AdaptiveRoute<dynamic>(
              initial: true,
              page: DictionaryIndividualRoute.page,
            ),
            ...commonRouteList,
          ],
        ),
        AdaptiveRoute<dynamic>(
          path: 'dictionary_everyone',
          page: DictionaryEveryoneRouterRoute.page,
          children: [
            AdaptiveRoute<dynamic>(
              initial: true,
              page: DictionaryEveryoneRoute.page,
            ),
            AdaptiveRoute<dynamic>(
              path: 'word_search_result',
              page: WordSearchResultRoute.page,
            ),
            AdaptiveRoute<dynamic>(
              path: 'dictionary_individual',
              page: DictionaryIndividualRoute.page,
            ),
            ...commonRouteList,
          ],
        ),
      ],
    ),
    AdaptiveRoute<dynamic>(
      path: '/setting',
      page: SettingRouterRoute.page,
      fullscreenDialog: true,
      children: [
        AdaptiveRoute<dynamic>(initial: true, page: SettingRoute.page),
        AdaptiveRoute<dynamic>(path: 'license', page: MyLicenseRoute.page),
        AdaptiveRoute<dynamic>(
          path: 'user_list_muted',
          page: UserListMutedRoute.page,
        ),
      ],
    ),
    AdaptiveRoute<dynamic>(
      path: '/definition_post',
      page: DefinitionPostRoute.page,
      fullscreenDialog: true,
    ),
    AdaptiveRoute<dynamic>(
      path: '/word_registration',
      page: WordRegistrationRoute.page,
      fullscreenDialog: true,
    ),
    AdaptiveRoute<dynamic>(
      path: '/definition_edit',
      page: DefinitionEditRoute.page,
      fullscreenDialog: true,
    ),
    AdaptiveRoute<dynamic>(
      path: '/profile_edit',
      page: ProfileEditRoute.page,
      fullscreenDialog: true,
    ),
    AdaptiveRoute<dynamic>(
      path: '/sign_in_failure',
      page: SignInFailureRoute.page,
      fullscreenDialog: true,
    ),
    ...modalStackRouteList,
  ];
}
