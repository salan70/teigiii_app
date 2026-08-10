// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [BasePage]
class BaseRoute extends PageRouteInfo<void> {
  const BaseRoute({List<PageRouteInfo>? children})
    : super(BaseRoute.name, initialChildren: children);

  static const String name = 'BaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BasePage();
    },
  );
}

/// generated route for
/// [BaseRouterPage]
class BaseRouterRoute extends PageRouteInfo<void> {
  const BaseRouterRoute({List<PageRouteInfo>? children})
    : super(BaseRouterRoute.name, initialChildren: children);

  static const String name = 'BaseRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BaseRouterPage();
    },
  );
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
         args: DefinitionDetailRouteArgs(key: key, definitionId: definitionId),
         initialChildren: children,
       );

  static const String name = 'DefinitionDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DefinitionDetailRouteArgs>();
      return DefinitionDetailPage(
        key: args.key,
        definitionId: args.definitionId,
      );
    },
  );
}

class DefinitionDetailRouteArgs {
  const DefinitionDetailRouteArgs({this.key, required this.definitionId});

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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DefinitionEditRouteArgs>();
      return DefinitionEditPage(
        key: args.key,
        initialDefinition: args.initialDefinition,
      );
    },
  );
}

class DefinitionEditRouteArgs {
  const DefinitionEditRouteArgs({this.key, required this.initialDefinition});

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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DefinitionPostRouteArgs>();
      return DefinitionPostPage(
        key: args.key,
        initialDefinitionForWrite: args.initialDefinitionForWrite,
        autoFocusForm: args.autoFocusForm,
        afterPostNavigation: args.afterPostNavigation,
      );
    },
  );
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
    : super(DictionaryEveryoneRoute.name, initialChildren: children);

  static const String name = 'DictionaryEveryoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DictionaryEveryonePage();
    },
  );
}

/// generated route for
/// [DictionaryEveryoneRouterPage]
class DictionaryEveryoneRouterRoute extends PageRouteInfo<void> {
  const DictionaryEveryoneRouterRoute({List<PageRouteInfo>? children})
    : super(DictionaryEveryoneRouterRoute.name, initialChildren: children);

  static const String name = 'DictionaryEveryoneRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DictionaryEveryoneRouterPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DictionaryIndividualRouteArgs>();
      return DictionaryIndividualPage(
        key: args.key,
        targetUserId: args.targetUserId,
        isTopRoute: args.isTopRoute,
      );
    },
  );
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
    : super(DictionaryIndividualRouterRoute.name, initialChildren: children);

  static const String name = 'DictionaryIndividualRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DictionaryIndividualRouterPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [HomeRouterPage]
class HomeRouterRoute extends PageRouteInfo<void> {
  const HomeRouterRoute({List<PageRouteInfo>? children})
    : super(HomeRouterRoute.name, initialChildren: children);

  static const String name = 'HomeRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeRouterPage();
    },
  );
}

/// generated route for
/// [MyLicensePage]
class MyLicenseRoute extends PageRouteInfo<void> {
  const MyLicenseRoute({List<PageRouteInfo>? children})
    : super(MyLicenseRoute.name, initialChildren: children);

  static const String name = 'MyLicenseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyLicensePage();
    },
  );
}

/// generated route for
/// [ProfileEditPage]
class ProfileEditRoute extends PageRouteInfo<ProfileEditRouteArgs> {
  ProfileEditRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        ProfileEditRoute.name,
        args: ProfileEditRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ProfileEditRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileEditRouteArgs>(
        orElse: () => const ProfileEditRouteArgs(),
      );
      return ProfileEditPage(key: args.key);
    },
  );
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
         args: ProfileTopRouteArgs(key: key, targetUserId: targetUserId),
         initialChildren: children,
       );

  static const String name = 'ProfileTopRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileTopRouteArgs>();
      return ProfileTopPage(key: args.key, targetUserId: args.targetUserId);
    },
  );
}

class ProfileTopRouteArgs {
  const ProfileTopRouteArgs({this.key, required this.targetUserId});

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
    : super(SettingRoute.name, initialChildren: children);

  static const String name = 'SettingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingPage();
    },
  );
}

/// generated route for
/// [SettingRouterPage]
class SettingRouterRoute extends PageRouteInfo<void> {
  const SettingRouterRoute({List<PageRouteInfo>? children})
    : super(SettingRouterRoute.name, initialChildren: children);

  static const String name = 'SettingRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingRouterPage();
    },
  );
}

/// generated route for
/// [SignInFailurePage]
class SignInFailureRoute extends PageRouteInfo<void> {
  const SignInFailureRoute({List<PageRouteInfo>? children})
    : super(SignInFailureRoute.name, initialChildren: children);

  static const String name = 'SignInFailureRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignInFailurePage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserListFollowingOrFollowerRouteArgs>();
      return UserListFollowingOrFollowerPage(
        key: args.key,
        initialTab: args.initialTab,
        targetUserId: args.targetUserId,
      );
    },
  );
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
         args: UserListLikedRouteArgs(key: key, definitionId: definitionId),
         initialChildren: children,
       );

  static const String name = 'UserListLikedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserListLikedRouteArgs>();
      return UserListLikedPage(key: args.key, definitionId: args.definitionId);
    },
  );
}

class UserListLikedRouteArgs {
  const UserListLikedRouteArgs({this.key, required this.definitionId});

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
    : super(UserListMutedRoute.name, initialChildren: children);

  static const String name = 'UserListMutedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserListMutedPage();
    },
  );
}

/// generated route for
/// [UserSearchPage]
class UserSearchRoute extends PageRouteInfo<void> {
  const UserSearchRoute({List<PageRouteInfo>? children})
    : super(UserSearchRoute.name, initialChildren: children);

  static const String name = 'UserSearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserSearchPage();
    },
  );
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
         args: UserSearchResultRouteArgs(key: key, searchWord: searchWord),
         initialChildren: children,
       );

  static const String name = 'UserSearchResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserSearchResultRouteArgs>();
      return UserSearchResultPage(key: args.key, searchWord: args.searchWord);
    },
  );
}

class UserSearchResultRouteArgs {
  const UserSearchResultRouteArgs({this.key, required this.searchWord});

  final Key? key;

  final String searchWord;

  @override
  String toString() {
    return 'UserSearchResultRouteArgs{key: $key, searchWord: $searchWord}';
  }
}

/// generated route for
/// [UserWordDefinitionListPage]
class UserWordDefinitionListRoute
    extends PageRouteInfo<UserWordDefinitionListRouteArgs> {
  UserWordDefinitionListRoute({
    Key? key,
    required String targetUserId,
    required String wordId,
    required String wordLabel,
    List<PageRouteInfo>? children,
  }) : super(
         UserWordDefinitionListRoute.name,
         args: UserWordDefinitionListRouteArgs(
           key: key,
           targetUserId: targetUserId,
           wordId: wordId,
           wordLabel: wordLabel,
         ),
         initialChildren: children,
       );

  static const String name = 'UserWordDefinitionListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserWordDefinitionListRouteArgs>();
      return UserWordDefinitionListPage(
        key: args.key,
        targetUserId: args.targetUserId,
        wordId: args.wordId,
        wordLabel: args.wordLabel,
      );
    },
  );
}

class UserWordDefinitionListRouteArgs {
  const UserWordDefinitionListRouteArgs({
    this.key,
    required this.targetUserId,
    required this.wordId,
    required this.wordLabel,
  });

  final Key? key;

  final String targetUserId;

  final String wordId;

  final String wordLabel;

  @override
  String toString() {
    return 'UserWordDefinitionListRouteArgs{key: $key, targetUserId: $targetUserId, wordId: $wordId, wordLabel: $wordLabel}';
  }
}

/// generated route for
/// [WelcomePage]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WelcomePage();
    },
  );
}

/// generated route for
/// [WordRegistrationPage]
class WordRegistrationRoute extends PageRouteInfo<WordRegistrationRouteArgs> {
  WordRegistrationRoute({
    Key? key,
    String? initialWord,
    List<PageRouteInfo>? children,
  }) : super(
         WordRegistrationRoute.name,
         args: WordRegistrationRouteArgs(key: key, initialWord: initialWord),
         initialChildren: children,
       );

  static const String name = 'WordRegistrationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WordRegistrationRouteArgs>(
        orElse: () => const WordRegistrationRouteArgs(),
      );
      return WordRegistrationPage(key: args.key, initialWord: args.initialWord);
    },
  );
}

class WordRegistrationRouteArgs {
  const WordRegistrationRouteArgs({this.key, this.initialWord});

  final Key? key;

  final String? initialWord;

  @override
  String toString() {
    return 'WordRegistrationRouteArgs{key: $key, initialWord: $initialWord}';
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
         args: WordSearchResultRouteArgs(key: key, searchWord: searchWord),
         initialChildren: children,
       );

  static const String name = 'WordSearchResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WordSearchResultRouteArgs>();
      return WordSearchResultPage(key: args.key, searchWord: args.searchWord);
    },
  );
}

class WordSearchResultRouteArgs {
  const WordSearchResultRouteArgs({this.key, required this.searchWord});

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
         args: WordTopRouteArgs(key: key, wordId: wordId),
         initialChildren: children,
       );

  static const String name = 'WordTopRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WordTopRouteArgs>();
      return WordTopPage(key: args.key, wordId: args.wordId);
    },
  );
}

class WordTopRouteArgs {
  const WordTopRouteArgs({this.key, required this.wordId});

  final Key? key;

  final String wordId;

  @override
  String toString() {
    return 'WordTopRouteArgs{key: $key, wordId: $wordId}';
  }
}
