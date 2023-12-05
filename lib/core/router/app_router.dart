import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../feature/definition/domain/definition.dart';
import '../../feature/definition/domain/definition_for_write.dart';
import '../../feature/definition/presentation/write_definition_base_page.dart';
import '../../feature/definition/util/after_post_navigation_type.dart';
import '../../feature/definition_list/presentation/individual_dictionary_definition_list.dart';
import '../../feature/word/util/dictionary_page_type.dart';
import '../../util/constant/initial_main_group.dart';
import '../page/base_page.dart';
import '../page/definition_detail_page.dart';
import '../page/definition_edit_page.dart';
import '../page/definition_post_page.dart';
import '../page/dictionary_everyone_page.dart';
import '../page/dictionary_individual_page.dart';
import '../page/dictionary_sub_index_page.dart';
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
import '../page/welcome_page.dart';
import '../page/word_list_page.dart';
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
class AppRouter extends _$AppRouter {
  AppRouter(this.ref);

  final Ref ref;

  final List<AdaptiveRoute> commonRouteList = [
    AdaptiveRoute(
      path: 'definition_detail',
      page: DefinitionDetailRoute.page,
    ),
    AdaptiveRoute(
      path: 'user_list_liked',
      page: UserListLikedRoute.page,
    ),
    AdaptiveRoute(
      path: 'word_top',
      page: WordTopRoute.page,
    ),
    AdaptiveRoute(
      path: 'profile_top',
      page: ProfileTopRoute.page,
    ),
    AdaptiveRoute(
      path: 'user_list_following_or_follower',
      page: UserListFollowingOrFollowerRoute.page,
    ),
    AdaptiveRoute(
      path: 'dictionary_sub_index',
      page: DictionarySubIndexRoute.page,
    ),
    AdaptiveRoute(
      path: 'individual_dictionary_definition_list',
      page: IndividualDictionaryDefinitionListRoute.page,
    ),
    AdaptiveRoute(
      path: 'user_search',
      page: UserSearchRoute.page,
    ),
    AdaptiveRoute(
      path: 'user_search_result',
      page: UserSearchResultRoute.page,
    ),
  ];

  @override
  List<AdaptiveRoute> get routes => [
        AdaptiveRoute(
          path: '/welcome',
          page: WelcomeRoute.page,
        ),
        AdaptiveRoute(
          path: '/',
          page: BaseRoute.page,
          guards: [
            ref.read(firstLaunchGuardProvider),
            ref.read(authGuardProvider),
          ],
          children: [
            AdaptiveRoute(
              path: 'home',
              page: HomeRouterRoute.page,
              children: [
                AdaptiveRoute(
                  initial: true,
                  page: HomeRoute.page,
                ),
                AdaptiveRoute(
                  path: 'dictionary_individual',
                  page: DictionaryIndividualRoute.page,
                ),
                ...commonRouteList,
              ],
            ),
            AdaptiveRoute(
              path: 'dictionary_individual',
              page: DictionaryIndividualRouterRoute.page,
              children: [
                AdaptiveRoute(
                  initial: true,
                  page: DictionaryIndividualRoute.page,
                ),
                ...commonRouteList,
              ],
            ),
            AdaptiveRoute(
              path: 'dictionary_everyone',
              page: DictionaryEveryoneRouterRoute.page,
              children: [
                AdaptiveRoute(
                  initial: true,
                  page: DictionaryEveryoneRoute.page,
                ),
                AdaptiveRoute(
                  path: 'word_list',
                  page: WordListRoute.page,
                ),
                AdaptiveRoute(
                  path: 'word_search_result',
                  page: WordSearchResultRoute.page,
                ),
                AdaptiveRoute(
                  path: 'dictionary_individual',
                  page: DictionaryIndividualRoute.page,
                ),
                ...commonRouteList,
              ],
            ),
          ],
        ),
        AdaptiveRoute(
          path: '/setting',
          page: SettingRouterRoute.page,
          fullscreenDialog: true,
          children: [
            AdaptiveRoute(
              initial: true,
              page: SettingRoute.page,
            ),
            AdaptiveRoute(
              path: 'license',
              page: MyLicenseRoute.page,
            ),
            AdaptiveRoute(
              path: 'user_list_muted',
              page: UserListMutedRoute.page,
            ),
          ],
        ),
        AdaptiveRoute(
          path: '/definition_post',
          page: DefinitionPostRoute.page,
          fullscreenDialog: true,
        ),
        AdaptiveRoute(
          path: '/definition_edit',
          page: DefinitionEditRoute.page,
          fullscreenDialog: true,
        ),
        AdaptiveRoute(
          path: '/profile_edit',
          page: ProfileEditRoute.page,
          fullscreenDialog: true,
        ),
        AdaptiveRoute(
          path: '/sign_in_failure',
          page: SignInFailureRoute.page,
          fullscreenDialog: true,
        ),
      ];
}
