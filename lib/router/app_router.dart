import 'package:auto_route/auto_route.dart';

import '../base_page.dart';
import '../feature/definition/presentation/page/home_page.dart';
import '../feature/definition/presentation/page/index_page.dart';
import '../feature/definition/presentation/page/profile_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: BaseRoute.page,
          initial: true,
          children: [
            AutoRoute(page: HomeRoute.page),
            AutoRoute(page: ProfileRoute.page),
            AutoRoute(page: IndexRoute.page),
          ],
        ),
      ];
}
