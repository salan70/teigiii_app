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
          initialDefinition: args.initialDefinition,
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
    IndividualDictionaryRoute.name: (routeData) {
      final args = routeData.argsAs<IndividualDictionaryRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IndividualDictionaryPage(
          key: args.key,
          targetUserId: args.targetUserId,
          isTopRoute: args.isTopRoute,
        ),
      );
    },
    IndividualDictionaryRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IndividualDictionaryRouterPage(),
      );
    },
    LikeUserRoute.name: (routeData) {
      final args = routeData.argsAs<LikeUserRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LikeUserPage(
          key: args.key,
          definitionId: args.definitionId,
        ),
      );
    },
    MutedUserListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MutedUserListPage(),
      );
    },
    MyLicenseRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyLicensePage(),
      );
    },
    PostDefinitionRoute.name: (routeData) {
      final args = routeData.argsAs<PostDefinitionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostDefinitionPage(
          key: args.key,
          initialDefinition: args.initialDefinition,
          autoFocusForm: args.autoFocusForm,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfilePage(
          key: args.key,
          targetUserId: args.targetUserId,
        ),
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
    WordTopRoute.name: (routeData) {
      final args = routeData.argsAs<WordTopRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WordTopPage(
          key: args.key,
          wordId: args.wordId,
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
    required Definition initialDefinition,
    List<PageRouteInfo>? children,
  }) : super(
          EditDefinitionRoute.name,
          args: EditDefinitionRouteArgs(
            key: key,
            initialDefinition: initialDefinition,
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
    required this.initialDefinition,
  });

  final Key? key;

  final Definition initialDefinition;

  @override
  String toString() {
    return 'EditDefinitionRouteArgs{key: $key, initialDefinition: $initialDefinition}';
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
/// [IndividualDictionaryPage]
class IndividualDictionaryRoute
    extends PageRouteInfo<IndividualDictionaryRouteArgs> {
  IndividualDictionaryRoute({
    Key? key,
    required String targetUserId,
    bool isTopRoute = false,
    List<PageRouteInfo>? children,
  }) : super(
          IndividualDictionaryRoute.name,
          args: IndividualDictionaryRouteArgs(
            key: key,
            targetUserId: targetUserId,
            isTopRoute: isTopRoute,
          ),
          initialChildren: children,
        );

  static const String name = 'IndividualDictionaryRoute';

  static const PageInfo<IndividualDictionaryRouteArgs> page =
      PageInfo<IndividualDictionaryRouteArgs>(name);
}

class IndividualDictionaryRouteArgs {
  const IndividualDictionaryRouteArgs({
    this.key,
    required this.targetUserId,
    this.isTopRoute = false,
  });

  final Key? key;

  final String targetUserId;

  final bool isTopRoute;

  @override
  String toString() {
    return 'IndividualDictionaryRouteArgs{key: $key, targetUserId: $targetUserId, isTopRoute: $isTopRoute}';
  }
}

/// generated route for
/// [IndividualDictionaryRouterPage]
class IndividualDictionaryRouterRoute extends PageRouteInfo<void> {
  const IndividualDictionaryRouterRoute({List<PageRouteInfo>? children})
      : super(
          IndividualDictionaryRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'IndividualDictionaryRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LikeUserPage]
class LikeUserRoute extends PageRouteInfo<LikeUserRouteArgs> {
  LikeUserRoute({
    Key? key,
    required String definitionId,
    List<PageRouteInfo>? children,
  }) : super(
          LikeUserRoute.name,
          args: LikeUserRouteArgs(
            key: key,
            definitionId: definitionId,
          ),
          initialChildren: children,
        );

  static const String name = 'LikeUserRoute';

  static const PageInfo<LikeUserRouteArgs> page =
      PageInfo<LikeUserRouteArgs>(name);
}

class LikeUserRouteArgs {
  const LikeUserRouteArgs({
    this.key,
    required this.definitionId,
  });

  final Key? key;

  final String definitionId;

  @override
  String toString() {
    return 'LikeUserRouteArgs{key: $key, definitionId: $definitionId}';
  }
}

/// generated route for
/// [MutedUserListPage]
class MutedUserListRoute extends PageRouteInfo<void> {
  const MutedUserListRoute({List<PageRouteInfo>? children})
      : super(
          MutedUserListRoute.name,
          initialChildren: children,
        );

  static const String name = 'MutedUserListRoute';

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
class PostDefinitionRoute extends PageRouteInfo<PostDefinitionRouteArgs> {
  PostDefinitionRoute({
    Key? key,
    required Definition? initialDefinition,
    required WriteDefinitionFormType? autoFocusForm,
    List<PageRouteInfo>? children,
  }) : super(
          PostDefinitionRoute.name,
          args: PostDefinitionRouteArgs(
            key: key,
            initialDefinition: initialDefinition,
            autoFocusForm: autoFocusForm,
          ),
          initialChildren: children,
        );

  static const String name = 'PostDefinitionRoute';

  static const PageInfo<PostDefinitionRouteArgs> page =
      PageInfo<PostDefinitionRouteArgs>(name);
}

class PostDefinitionRouteArgs {
  const PostDefinitionRouteArgs({
    this.key,
    required this.initialDefinition,
    required this.autoFocusForm,
  });

  final Key? key;

  final Definition? initialDefinition;

  final WriteDefinitionFormType? autoFocusForm;

  @override
  String toString() {
    return 'PostDefinitionRouteArgs{key: $key, initialDefinition: $initialDefinition, autoFocusForm: $autoFocusForm}';
  }
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    Key? key,
    required String targetUserId,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            key: key,
            targetUserId: targetUserId,
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
  });

  final Key? key;

  final String targetUserId;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, targetUserId: $targetUserId}';
  }
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

/// generated route for
/// [WordTopPage]
class WordTopRoute extends PageRouteInfo<WordTopRouteArgs> {
  WordTopRoute({
    Key? key,
    required String wordId,
    List<PageRouteInfo>? children,
  }) : super(
          WordTopRoute.name,
          args: WordTopRouteArgs(
            key: key,
            wordId: wordId,
          ),
          initialChildren: children,
        );

  static const String name = 'WordTopRoute';

  static const PageInfo<WordTopRouteArgs> page =
      PageInfo<WordTopRouteArgs>(name);
}

class WordTopRouteArgs {
  const WordTopRouteArgs({
    this.key,
    required this.wordId,
  });

  final Key? key;

  final String wordId;

  @override
  String toString() {
    return 'WordTopRouteArgs{key: $key, wordId: $wordId}';
  }
}
