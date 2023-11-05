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
    EditDefinitionRoute.name: (routeData) {
      final args = routeData.argsAs<EditDefinitionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditDefinitionPage(
          key: args.key,
          initialDefinitionForWrite: args.initialDefinitionForWrite,
        ),
      );
    },
    FollowingAndFollowerListRoute.name: (routeData) {
      final args = routeData.argsAs<FollowingAndFollowerListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FollowingAndFollowerListPage(
          key: args.key,
          willShowFollowing: args.willShowFollowing,
          targetUserId: args.targetUserId,
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
    IndexSecondRoute.name: (routeData) {
      final args = routeData.argsAs<IndexSecondRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IndexSecondPage(
          key: args.key,
          selectedInitialMainGroup: args.selectedInitialMainGroup,
        ),
      );
    },
    IndexTopRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IndexTopPage(),
      );
    },
    IndexTopRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IndexTopRouterPage(),
      );
    },
    MyLicenseRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyLicensePage(),
      );
    },
    PostDefinitionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PostDefinitionPage(),
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
    SearchWordResultRoute.name: (routeData) {
      final args = routeData.argsAs<SearchWordResultRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SearchWordResultPage(
          key: args.key,
          searchWord: args.searchWord,
        ),
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
    WordListRoute.name: (routeData) {
      final args = routeData.argsAs<WordListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WordListPage(
          key: args.key,
          selectedInitialSubGroup: args.selectedInitialSubGroup,
        ),
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
/// [EditDefinitionPage]
class EditDefinitionRoute extends PageRouteInfo<EditDefinitionRouteArgs> {
  EditDefinitionRoute({
    Key? key,
    required DefinitionForWrite initialDefinitionForWrite,
    List<PageRouteInfo>? children,
  }) : super(
          EditDefinitionRoute.name,
          args: EditDefinitionRouteArgs(
            key: key,
            initialDefinitionForWrite: initialDefinitionForWrite,
          ),
          initialChildren: children,
        );

  static const String name = 'EditDefinitionRoute';

  static const PageInfo<EditDefinitionRouteArgs> page =
      PageInfo<EditDefinitionRouteArgs>(name);
}

class EditDefinitionRouteArgs {
  const EditDefinitionRouteArgs({
    this.key,
    required this.initialDefinitionForWrite,
  });

  final Key? key;

  final DefinitionForWrite initialDefinitionForWrite;

  @override
  String toString() {
    return 'EditDefinitionRouteArgs{key: $key, initialDefinitionForWrite: $initialDefinitionForWrite}';
  }
}

/// generated route for
/// [FollowingAndFollowerListPage]
class FollowingAndFollowerListRoute
    extends PageRouteInfo<FollowingAndFollowerListRouteArgs> {
  FollowingAndFollowerListRoute({
    Key? key,
    bool willShowFollowing = true,
    required String targetUserId,
    List<PageRouteInfo>? children,
  }) : super(
          FollowingAndFollowerListRoute.name,
          args: FollowingAndFollowerListRouteArgs(
            key: key,
            willShowFollowing: willShowFollowing,
            targetUserId: targetUserId,
          ),
          initialChildren: children,
        );

  static const String name = 'FollowingAndFollowerListRoute';

  static const PageInfo<FollowingAndFollowerListRouteArgs> page =
      PageInfo<FollowingAndFollowerListRouteArgs>(name);
}

class FollowingAndFollowerListRouteArgs {
  const FollowingAndFollowerListRouteArgs({
    this.key,
    this.willShowFollowing = true,
    required this.targetUserId,
  });

  final Key? key;

  final bool willShowFollowing;

  final String targetUserId;

  @override
  String toString() {
    return 'FollowingAndFollowerListRouteArgs{key: $key, willShowFollowing: $willShowFollowing, targetUserId: $targetUserId}';
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
/// [IndexSecondPage]
class IndexSecondRoute extends PageRouteInfo<IndexSecondRouteArgs> {
  IndexSecondRoute({
    Key? key,
    required InitialMainGroup selectedInitialMainGroup,
    List<PageRouteInfo>? children,
  }) : super(
          IndexSecondRoute.name,
          args: IndexSecondRouteArgs(
            key: key,
            selectedInitialMainGroup: selectedInitialMainGroup,
          ),
          initialChildren: children,
        );

  static const String name = 'IndexSecondRoute';

  static const PageInfo<IndexSecondRouteArgs> page =
      PageInfo<IndexSecondRouteArgs>(name);
}

class IndexSecondRouteArgs {
  const IndexSecondRouteArgs({
    this.key,
    required this.selectedInitialMainGroup,
  });

  final Key? key;

  final InitialMainGroup selectedInitialMainGroup;

  @override
  String toString() {
    return 'IndexSecondRouteArgs{key: $key, selectedInitialMainGroup: $selectedInitialMainGroup}';
  }
}

/// generated route for
/// [IndexTopPage]
class IndexTopRoute extends PageRouteInfo<void> {
  const IndexTopRoute({List<PageRouteInfo>? children})
      : super(
          IndexTopRoute.name,
          initialChildren: children,
        );

  static const String name = 'IndexTopRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IndexTopRouterPage]
class IndexTopRouterRoute extends PageRouteInfo<void> {
  const IndexTopRouterRoute({List<PageRouteInfo>? children})
      : super(
          IndexTopRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'IndexTopRouterRoute';

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
/// [PostDefinitionPage]
class PostDefinitionRoute extends PageRouteInfo<void> {
  const PostDefinitionRoute({List<PageRouteInfo>? children})
      : super(
          PostDefinitionRoute.name,
          initialChildren: children,
        );

  static const String name = 'PostDefinitionRoute';

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
/// [SearchWordResultPage]
class SearchWordResultRoute extends PageRouteInfo<SearchWordResultRouteArgs> {
  SearchWordResultRoute({
    Key? key,
    required String searchWord,
    List<PageRouteInfo>? children,
  }) : super(
          SearchWordResultRoute.name,
          args: SearchWordResultRouteArgs(
            key: key,
            searchWord: searchWord,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchWordResultRoute';

  static const PageInfo<SearchWordResultRouteArgs> page =
      PageInfo<SearchWordResultRouteArgs>(name);
}

class SearchWordResultRouteArgs {
  const SearchWordResultRouteArgs({
    this.key,
    required this.searchWord,
  });

  final Key? key;

  final String searchWord;

  @override
  String toString() {
    return 'SearchWordResultRouteArgs{key: $key, searchWord: $searchWord}';
  }
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

/// generated route for
/// [WordListPage]
class WordListRoute extends PageRouteInfo<WordListRouteArgs> {
  WordListRoute({
    Key? key,
    required InitialSubGroup selectedInitialSubGroup,
    List<PageRouteInfo>? children,
  }) : super(
          WordListRoute.name,
          args: WordListRouteArgs(
            key: key,
            selectedInitialSubGroup: selectedInitialSubGroup,
          ),
          initialChildren: children,
        );

  static const String name = 'WordListRoute';

  static const PageInfo<WordListRouteArgs> page =
      PageInfo<WordListRouteArgs>(name);
}

class WordListRouteArgs {
  const WordListRouteArgs({
    this.key,
    required this.selectedInitialSubGroup,
  });

  final Key? key;

  final InitialSubGroup selectedInitialSubGroup;

  @override
  String toString() {
    return 'WordListRouteArgs{key: $key, selectedInitialSubGroup: $selectedInitialSubGroup}';
  }
}
