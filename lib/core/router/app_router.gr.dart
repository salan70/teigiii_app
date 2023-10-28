// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    BaseRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BasePage(),
      );
    },
    BaseRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BaseRouterPage(),
      );
    },
    DefinitionDetailRoute.name: (routeData) {
      final args = routeData.argsAs<DefinitionDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DefinitionDetailPage(
          key: args.key,
          definitionId: args.definitionId,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    HomeRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeRouterPage(),
      );
    },
    IndexRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IndexPage(),
      );
    },
    MyLicenseRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyLicensePage(),
      );
    },
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfilePage(
          key: args.key,
          targetUserId: args.targetUserId,
          isHome: args.isHome,
        ),
      );
    },
    ProfileRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileRouterPage(),
      );
    },
    SettingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingPage(),
      );
    },
    SettingRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingRouterPage(),
      );
    },
  };
}

/// generated route for
/// [BasePage]
class BaseRoute extends PageRouteInfo<void> {
  const BaseRoute({List<PageRouteInfo>? children})
      : super(
          BaseRoute.name,
          initialChildren: children,
        );

  static const String name = 'BaseRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BaseRouterPage]
class BaseRouterRoute extends PageRouteInfo<void> {
  const BaseRouterRoute({List<PageRouteInfo>? children})
      : super(
          BaseRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'BaseRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DefinitionDetailPage]
class DefinitionDetailRoute extends PageRouteInfo<DefinitionDetailRouteArgs> {
  DefinitionDetailRoute({
    Key? key,
    required String definitionId,
    List<PageRouteInfo>? children,
  }) : super(
          DefinitionDetailRoute.name,
          args: DefinitionDetailRouteArgs(
            key: key,
            definitionId: definitionId,
          ),
          initialChildren: children,
        );

  static const String name = 'DefinitionDetailRoute';

  static const PageInfo<DefinitionDetailRouteArgs> page =
      PageInfo<DefinitionDetailRouteArgs>(name);
}

class DefinitionDetailRouteArgs {
  const DefinitionDetailRouteArgs({
    this.key,
    required this.definitionId,
  });

  final Key? key;

  final String definitionId;

  @override
  String toString() {
    return 'DefinitionDetailRouteArgs{key: $key, definitionId: $definitionId}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeRouterPage]
class HomeRouterRoute extends PageRouteInfo<void> {
  const HomeRouterRoute({List<PageRouteInfo>? children})
      : super(
          HomeRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IndexPage]
class IndexRoute extends PageRouteInfo<void> {
  const IndexRoute({List<PageRouteInfo>? children})
      : super(
          IndexRoute.name,
          initialChildren: children,
        );

  static const String name = 'IndexRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyLicensePage]
class MyLicenseRoute extends PageRouteInfo<void> {
  const MyLicenseRoute({List<PageRouteInfo>? children})
      : super(
          MyLicenseRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyLicenseRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    Key? key,
    required String targetUserId,
    bool isHome = false,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            key: key,
            targetUserId: targetUserId,
            isHome: isHome,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<ProfileRouteArgs> page =
      PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    required this.targetUserId,
    this.isHome = false,
  });

  final Key? key;

  final String targetUserId;

  final bool isHome;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, targetUserId: $targetUserId, isHome: $isHome}';
  }
}

/// generated route for
/// [ProfileRouterPage]
class ProfileRouterRoute extends PageRouteInfo<void> {
  const ProfileRouterRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingPage]
class SettingRoute extends PageRouteInfo<void> {
  const SettingRoute({List<PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingRouterPage]
class SettingRouterRoute extends PageRouteInfo<void> {
  const SettingRouterRoute({List<PageRouteInfo>? children})
      : super(
          SettingRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
