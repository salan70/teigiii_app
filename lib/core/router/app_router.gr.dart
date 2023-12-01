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
    DefinitionEditRoute.name: (routeData) {
      final args = routeData.argsAs<DefinitionEditRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DefinitionEditPage(
          key: args.key,
          initialDefinition: args.initialDefinition,
        ),
      );
    },
    DefinitionPostRoute.name: (routeData) {
      final args = routeData.argsAs<DefinitionPostRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DefinitionPostPage(
          key: args.key,
          initialDefinitionForWrite: args.initialDefinitionForWrite,
          autoFocusForm: args.autoFocusForm,
          afterPostNavigation: args.afterPostNavigation,
        ),
      );
    },
    DictionaryEveryoneRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DictionaryEveryonePage(),
      );
    },
    DictionaryEveryoneRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DictionaryEveryoneRouterPage(),
      );
    },
    DictionaryIndividualRoute.name: (routeData) {
      final args = routeData.argsAs<DictionaryIndividualRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DictionaryIndividualPage(
          key: args.key,
          targetUserId: args.targetUserId,
          isTopRoute: args.isTopRoute,
        ),
      );
    },
    DictionaryIndividualRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DictionaryIndividualRouterPage(),
      );
    },
    DictionarySubIndexRoute.name: (routeData) {
      final args = routeData.argsAs<DictionarySubIndexRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DictionarySubIndexPage(
          key: args.key,
          selectedInitialMainGroup: args.selectedInitialMainGroup,
          dictionaryPageType: args.dictionaryPageType,
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
    IndividualDictionaryDefinitionListRoute.name: (routeData) {
      final args =
          routeData.argsAs<IndividualDictionaryDefinitionListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: IndividualDictionaryDefinitionListPage(
          key: args.key,
          targetUserId: args.targetUserId,
          initialSubGroup: args.initialSubGroup,
        ),
      );
    },
    IntroductionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IntroductionPage(),
      );
    },
    MyLicenseRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyLicensePage(),
      );
    },
    ProfileEditRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileEditRouteArgs>(
          orElse: () => const ProfileEditRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfileEditPage(key: args.key),
      );
    },
    ProfileTopRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileTopRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfileTopPage(
          key: args.key,
          targetUserId: args.targetUserId,
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
    UserListFollowingOrFollowerRoute.name: (routeData) {
      final args = routeData.argsAs<UserListFollowingOrFollowerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserListFollowingOrFollowerPage(
          key: args.key,
          initialTab: args.initialTab,
          targetUserId: args.targetUserId,
        ),
      );
    },
    UserListLikedRoute.name: (routeData) {
      final args = routeData.argsAs<UserListLikedRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserListLikedPage(
          key: args.key,
          definitionId: args.definitionId,
        ),
      );
    },
    UserListMutedRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserListMutedPage(),
      );
    },
    UserSearchRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserSearchPage(),
      );
    },
    UserSearchResultRoute.name: (routeData) {
      final args = routeData.argsAs<UserSearchResultRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserSearchResultPage(
          key: args.key,
          searchWord: args.searchWord,
        ),
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
    WordSearchResultRoute.name: (routeData) {
      final args = routeData.argsAs<WordSearchResultRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WordSearchResultPage(
          key: args.key,
          searchWord: args.searchWord,
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
/// [DefinitionEditPage]
class DefinitionEditRoute extends PageRouteInfo<DefinitionEditRouteArgs> {
  DefinitionEditRoute({
    Key? key,
    required Definition initialDefinition,
    List<PageRouteInfo>? children,
  }) : super(
          DefinitionEditRoute.name,
          args: DefinitionEditRouteArgs(
            key: key,
            initialDefinition: initialDefinition,
          ),
          initialChildren: children,
        );

  static const String name = 'DefinitionEditRoute';

  static const PageInfo<DefinitionEditRouteArgs> page =
      PageInfo<DefinitionEditRouteArgs>(name);
}

class DefinitionEditRouteArgs {
  const DefinitionEditRouteArgs({
    this.key,
    required this.initialDefinition,
  });

  final Key? key;

  final Definition initialDefinition;

  @override
  String toString() {
    return 'DefinitionEditRouteArgs{key: $key, initialDefinition: $initialDefinition}';
  }
}

/// generated route for
/// [DefinitionPostPage]
class DefinitionPostRoute extends PageRouteInfo<DefinitionPostRouteArgs> {
  DefinitionPostRoute({
    Key? key,
    required DefinitionForWrite? initialDefinitionForWrite,
    required WriteDefinitionFormType? autoFocusForm,
    AfterPostNavigationType afterPostNavigation = AfterPostNavigationType.pop,
    List<PageRouteInfo>? children,
  }) : super(
          DefinitionPostRoute.name,
          args: DefinitionPostRouteArgs(
            key: key,
            initialDefinitionForWrite: initialDefinitionForWrite,
            autoFocusForm: autoFocusForm,
            afterPostNavigation: afterPostNavigation,
          ),
          initialChildren: children,
        );

  static const String name = 'DefinitionPostRoute';

  static const PageInfo<DefinitionPostRouteArgs> page =
      PageInfo<DefinitionPostRouteArgs>(name);
}

class DefinitionPostRouteArgs {
  const DefinitionPostRouteArgs({
    this.key,
    required this.initialDefinitionForWrite,
    required this.autoFocusForm,
    this.afterPostNavigation = AfterPostNavigationType.pop,
  });

  final Key? key;

  final DefinitionForWrite? initialDefinitionForWrite;

  final WriteDefinitionFormType? autoFocusForm;

  final AfterPostNavigationType afterPostNavigation;

  @override
  String toString() {
    return 'DefinitionPostRouteArgs{key: $key, initialDefinitionForWrite: $initialDefinitionForWrite, autoFocusForm: $autoFocusForm, afterPostNavigation: $afterPostNavigation}';
  }
}

/// generated route for
/// [DictionaryEveryonePage]
class DictionaryEveryoneRoute extends PageRouteInfo<void> {
  const DictionaryEveryoneRoute({List<PageRouteInfo>? children})
      : super(
          DictionaryEveryoneRoute.name,
          initialChildren: children,
        );

  static const String name = 'DictionaryEveryoneRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DictionaryEveryoneRouterPage]
class DictionaryEveryoneRouterRoute extends PageRouteInfo<void> {
  const DictionaryEveryoneRouterRoute({List<PageRouteInfo>? children})
      : super(
          DictionaryEveryoneRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'DictionaryEveryoneRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DictionaryIndividualPage]
class DictionaryIndividualRoute
    extends PageRouteInfo<DictionaryIndividualRouteArgs> {
  DictionaryIndividualRoute({
    Key? key,
    required String targetUserId,
    bool isTopRoute = false,
    List<PageRouteInfo>? children,
  }) : super(
          DictionaryIndividualRoute.name,
          args: DictionaryIndividualRouteArgs(
            key: key,
            targetUserId: targetUserId,
            isTopRoute: isTopRoute,
          ),
          initialChildren: children,
        );

  static const String name = 'DictionaryIndividualRoute';

  static const PageInfo<DictionaryIndividualRouteArgs> page =
      PageInfo<DictionaryIndividualRouteArgs>(name);
}

class DictionaryIndividualRouteArgs {
  const DictionaryIndividualRouteArgs({
    this.key,
    required this.targetUserId,
    this.isTopRoute = false,
  });

  final Key? key;

  final String targetUserId;

  final bool isTopRoute;

  @override
  String toString() {
    return 'DictionaryIndividualRouteArgs{key: $key, targetUserId: $targetUserId, isTopRoute: $isTopRoute}';
  }
}

/// generated route for
/// [DictionaryIndividualRouterPage]
class DictionaryIndividualRouterRoute extends PageRouteInfo<void> {
  const DictionaryIndividualRouterRoute({List<PageRouteInfo>? children})
      : super(
          DictionaryIndividualRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'DictionaryIndividualRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DictionarySubIndexPage]
class DictionarySubIndexRoute
    extends PageRouteInfo<DictionarySubIndexRouteArgs> {
  DictionarySubIndexRoute({
    Key? key,
    required InitialMainGroup selectedInitialMainGroup,
    required DictionaryPageType dictionaryPageType,
    required String? targetUserId,
    List<PageRouteInfo>? children,
  }) : super(
          DictionarySubIndexRoute.name,
          args: DictionarySubIndexRouteArgs(
            key: key,
            selectedInitialMainGroup: selectedInitialMainGroup,
            dictionaryPageType: dictionaryPageType,
            targetUserId: targetUserId,
          ),
          initialChildren: children,
        );

  static const String name = 'DictionarySubIndexRoute';

  static const PageInfo<DictionarySubIndexRouteArgs> page =
      PageInfo<DictionarySubIndexRouteArgs>(name);
}

class DictionarySubIndexRouteArgs {
  const DictionarySubIndexRouteArgs({
    this.key,
    required this.selectedInitialMainGroup,
    required this.dictionaryPageType,
    required this.targetUserId,
  });

  final Key? key;

  final InitialMainGroup selectedInitialMainGroup;

  final DictionaryPageType dictionaryPageType;

  final String? targetUserId;

  @override
  String toString() {
    return 'DictionarySubIndexRouteArgs{key: $key, selectedInitialMainGroup: $selectedInitialMainGroup, dictionaryPageType: $dictionaryPageType, targetUserId: $targetUserId}';
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
/// [IndividualDictionaryDefinitionListPage]
class IndividualDictionaryDefinitionListRoute
    extends PageRouteInfo<IndividualDictionaryDefinitionListRouteArgs> {
  IndividualDictionaryDefinitionListRoute({
    Key? key,
    required String targetUserId,
    required InitialSubGroup initialSubGroup,
    List<PageRouteInfo>? children,
  }) : super(
          IndividualDictionaryDefinitionListRoute.name,
          args: IndividualDictionaryDefinitionListRouteArgs(
            key: key,
            targetUserId: targetUserId,
            initialSubGroup: initialSubGroup,
          ),
          initialChildren: children,
        );

  static const String name = 'IndividualDictionaryDefinitionListRoute';

  static const PageInfo<IndividualDictionaryDefinitionListRouteArgs> page =
      PageInfo<IndividualDictionaryDefinitionListRouteArgs>(name);
}

class IndividualDictionaryDefinitionListRouteArgs {
  const IndividualDictionaryDefinitionListRouteArgs({
    this.key,
    required this.targetUserId,
    required this.initialSubGroup,
  });

  final Key? key;

  final String targetUserId;

  final InitialSubGroup initialSubGroup;

  @override
  String toString() {
    return 'IndividualDictionaryDefinitionListRouteArgs{key: $key, targetUserId: $targetUserId, initialSubGroup: $initialSubGroup}';
  }
}

/// generated route for
/// [IntroductionPage]
class IntroductionRoute extends PageRouteInfo<void> {
  const IntroductionRoute({List<PageRouteInfo>? children})
      : super(
          IntroductionRoute.name,
          initialChildren: children,
        );

  static const String name = 'IntroductionRoute';

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
/// [ProfileEditPage]
class ProfileEditRoute extends PageRouteInfo<ProfileEditRouteArgs> {
  ProfileEditRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileEditRoute.name,
          args: ProfileEditRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ProfileEditRoute';

  static const PageInfo<ProfileEditRouteArgs> page =
      PageInfo<ProfileEditRouteArgs>(name);
}

class ProfileEditRouteArgs {
  const ProfileEditRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'ProfileEditRouteArgs{key: $key}';
  }
}

/// generated route for
/// [ProfileTopPage]
class ProfileTopRoute extends PageRouteInfo<ProfileTopRouteArgs> {
  ProfileTopRoute({
    Key? key,
    required String targetUserId,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileTopRoute.name,
          args: ProfileTopRouteArgs(
            key: key,
            targetUserId: targetUserId,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileTopRoute';

  static const PageInfo<ProfileTopRouteArgs> page =
      PageInfo<ProfileTopRouteArgs>(name);
}

class ProfileTopRouteArgs {
  const ProfileTopRouteArgs({
    this.key,
    required this.targetUserId,
  });

  final Key? key;

  final String targetUserId;

  @override
  String toString() {
    return 'ProfileTopRouteArgs{key: $key, targetUserId: $targetUserId}';
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
/// [UserListFollowingOrFollowerPage]
class UserListFollowingOrFollowerRoute
    extends PageRouteInfo<UserListFollowingOrFollowerRouteArgs> {
  UserListFollowingOrFollowerRoute({
    Key? key,
    required FollowingAndFollowerListTab initialTab,
    required String targetUserId,
    List<PageRouteInfo>? children,
  }) : super(
          UserListFollowingOrFollowerRoute.name,
          args: UserListFollowingOrFollowerRouteArgs(
            key: key,
            initialTab: initialTab,
            targetUserId: targetUserId,
          ),
          initialChildren: children,
        );

  static const String name = 'UserListFollowingOrFollowerRoute';

  static const PageInfo<UserListFollowingOrFollowerRouteArgs> page =
      PageInfo<UserListFollowingOrFollowerRouteArgs>(name);
}

class UserListFollowingOrFollowerRouteArgs {
  const UserListFollowingOrFollowerRouteArgs({
    this.key,
    required this.initialTab,
    required this.targetUserId,
  });

  final Key? key;

  final FollowingAndFollowerListTab initialTab;

  final String targetUserId;

  @override
  String toString() {
    return 'UserListFollowingOrFollowerRouteArgs{key: $key, initialTab: $initialTab, targetUserId: $targetUserId}';
  }
}

/// generated route for
/// [UserListLikedPage]
class UserListLikedRoute extends PageRouteInfo<UserListLikedRouteArgs> {
  UserListLikedRoute({
    Key? key,
    required String definitionId,
    List<PageRouteInfo>? children,
  }) : super(
          UserListLikedRoute.name,
          args: UserListLikedRouteArgs(
            key: key,
            definitionId: definitionId,
          ),
          initialChildren: children,
        );

  static const String name = 'UserListLikedRoute';

  static const PageInfo<UserListLikedRouteArgs> page =
      PageInfo<UserListLikedRouteArgs>(name);
}

class UserListLikedRouteArgs {
  const UserListLikedRouteArgs({
    this.key,
    required this.definitionId,
  });

  final Key? key;

  final String definitionId;

  @override
  String toString() {
    return 'UserListLikedRouteArgs{key: $key, definitionId: $definitionId}';
  }
}

/// generated route for
/// [UserListMutedPage]
class UserListMutedRoute extends PageRouteInfo<void> {
  const UserListMutedRoute({List<PageRouteInfo>? children})
      : super(
          UserListMutedRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserListMutedRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserSearchPage]
class UserSearchRoute extends PageRouteInfo<void> {
  const UserSearchRoute({List<PageRouteInfo>? children})
      : super(
          UserSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserSearchRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserSearchResultPage]
class UserSearchResultRoute extends PageRouteInfo<UserSearchResultRouteArgs> {
  UserSearchResultRoute({
    Key? key,
    required String searchWord,
    List<PageRouteInfo>? children,
  }) : super(
          UserSearchResultRoute.name,
          args: UserSearchResultRouteArgs(
            key: key,
            searchWord: searchWord,
          ),
          initialChildren: children,
        );

  static const String name = 'UserSearchResultRoute';

  static const PageInfo<UserSearchResultRouteArgs> page =
      PageInfo<UserSearchResultRouteArgs>(name);
}

class UserSearchResultRouteArgs {
  const UserSearchResultRouteArgs({
    this.key,
    required this.searchWord,
  });

  final Key? key;

  final String searchWord;

  @override
  String toString() {
    return 'UserSearchResultRouteArgs{key: $key, searchWord: $searchWord}';
  }
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
/// [WordSearchResultPage]
class WordSearchResultRoute extends PageRouteInfo<WordSearchResultRouteArgs> {
  WordSearchResultRoute({
    Key? key,
    required String searchWord,
    List<PageRouteInfo>? children,
  }) : super(
          WordSearchResultRoute.name,
          args: WordSearchResultRouteArgs(
            key: key,
            searchWord: searchWord,
          ),
          initialChildren: children,
        );

  static const String name = 'WordSearchResultRoute';

  static const PageInfo<WordSearchResultRouteArgs> page =
      PageInfo<WordSearchResultRouteArgs>(name);
}

class WordSearchResultRouteArgs {
  const WordSearchResultRouteArgs({
    this.key,
    required this.searchWord,
  });

  final Key? key;

  final String searchWord;

  @override
  String toString() {
    return 'WordSearchResultRouteArgs{key: $key, searchWord: $searchWord}';
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
