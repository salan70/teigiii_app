import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../base_page.dart';
import '../../feature/definition/domain/definition.dart';
import '../../feature/definition/domain/definition_for_write.dart';
import '../../feature/definition/presentation/page/definition_detail/definition_detail_page.dart';
import '../../feature/definition/presentation/page/edit_definition/edit_definition_page.dart';
import '../../feature/definition/presentation/page/home/home_page.dart';
import '../../feature/definition/presentation/page/post_definition/post_definition_page.dart';
import '../../feature/definition/util/after_post_navigation_type.dart';
import '../../feature/definition/util/write_definition_form_type.dart';
import '../../feature/introduction/presentation/introduction_page.dart';
import '../../feature/setting/presentation/license_page.dart';
import '../../feature/setting/presentation/muted_user_list_page.dart';
import '../../feature/setting/presentation/setting_page.dart';
import '../../feature/user_list/presentation/following_and_follower_list_page.dart';
import '../../feature/user_profile/presentation/page/edit_profile/edit_profile_page.dart';
import '../../feature/user_profile/presentation/page/like_user_page.dart/like_user_page.dart';
import '../../feature/user_profile/presentation/page/profile/profile_page.dart';
import '../../feature/user_profile/presentation/page/search_user/search_user_page.dart';
import '../../feature/user_profile/presentation/page/search_user_result/search_user_result_page.dart';
import '../../feature/word/presentation/page/everyone_dictionary/everyone_dictionary_page.dart';
import '../../feature/word/presentation/page/individual_dictionary/individual_dictionary_page.dart';
import '../../feature/word/presentation/page/individual_dictionary_definition_list/individual_dictionary_definition_list.dart';
import '../../feature/word/presentation/page/initial_sub_group_index/initial_sub_group_index_page.dart';
import '../../feature/word/presentation/page/search_word_result/search_word_result_page.dart';
import '../../feature/word/presentation/page/word_list/word_list_page.dart';
import '../../feature/word/presentation/page/word_top/word_top_page.dart';
import '../../feature/word/util/dictionary_page_type.dart';
import '../../util/constant/initial_main_group.dart';
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
      path: 'like_user_list',
      page: LikeUserRoute.page,
    ),
    AdaptiveRoute(
      path: 'word_top',
      page: WordTopRoute.page,
    ),
    AdaptiveRoute(
      path: 'profile',
      page: ProfileRoute.page,
    ),
    AdaptiveRoute(
      path: 'following_and_follower_list',
      page: FollowingAndFollowerListRoute.page,
    ),
    AdaptiveRoute(
      path: 'initial_sub_group_index',
      page: InitialSubGroupIndexRoute.page,
    ),
    AdaptiveRoute(
      path: 'individual_dictionary_definition_list',
      page: IndividualDictionaryDefinitionListRoute.page,
    ),
    AdaptiveRoute(
      path: 'search_user',
      page: SearchUserRoute.page,
    ),
    AdaptiveRoute(
      path: 'search_user_result',
      page: SearchUserResultRoute.page,
    ),
  ];

  @override
  List<AdaptiveRoute> get routes => [
        AdaptiveRoute(
          path: '/introduction',
          page: IntroductionRoute.page,
        ),
        AdaptiveRoute(
          path: '/',
          page: BaseRoute.page,
          guards: [ref.read(firstLaunchGuardProvider)],
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
                  path: 'individual_dictionary',
                  page: IndividualDictionaryRoute.page,
                ),
                ...commonRouteList,
              ],
            ),
            AdaptiveRoute(
              path: 'individual_dictionary',
              page: IndividualDictionaryRouterRoute.page,
              children: [
                AdaptiveRoute(
                  initial: true,
                  page: IndividualDictionaryRoute.page,
                ),
                ...commonRouteList,
              ],
            ),
            AdaptiveRoute(
              path: 'index',
              page: EveryoneDictionaryRouterRoute.page,
              children: [
                AdaptiveRoute(
                  initial: true,
                  page: EveryoneDictionaryRoute.page,
                ),
                AdaptiveRoute(
                  path: 'word_list',
                  page: WordListRoute.page,
                ),
                AdaptiveRoute(
                  path: 'search_word_result',
                  page: SearchWordResultRoute.page,
                ),
                AdaptiveRoute(
                  path: 'individual_dictionary',
                  page: IndividualDictionaryRoute.page,
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
              path: 'muted_user_list',
              page: MutedUserListRoute.page,
            ),
          ],
        ),
        AdaptiveRoute(
          path: '/post_definition',
          page: PostDefinitionRoute.page,
          fullscreenDialog: true,
        ),
        AdaptiveRoute(
          path: '/edit_definition',
          page: EditDefinitionRoute.page,
          fullscreenDialog: true,
        ),
        AdaptiveRoute(
          path: '/edit_profile',
          page: EditProfileRoute.page,
          fullscreenDialog: true,
        ),
      ];
}
