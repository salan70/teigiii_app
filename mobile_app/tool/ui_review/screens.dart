import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teigi_app/core/page/definition_detail_page.dart';
import 'package:teigi_app/core/page/definition_edit_page.dart';
import 'package:teigi_app/core/page/definition_post_page.dart';
import 'package:teigi_app/core/page/dictionary_everyone_page.dart';
import 'package:teigi_app/core/page/dictionary_individual_page.dart';
import 'package:teigi_app/core/page/home_page.dart';
import 'package:teigi_app/core/page/license_page.dart';
import 'package:teigi_app/core/page/profile_edit_page.dart';
import 'package:teigi_app/core/page/profile_top_page.dart';
import 'package:teigi_app/core/page/setting_page.dart';
import 'package:teigi_app/core/page/sign_in_failure_page.dart';
import 'package:teigi_app/core/page/user_list_following_or_follower_page.dart';
import 'package:teigi_app/core/page/user_list_liked_page.dart';
import 'package:teigi_app/core/page/user_list_muted_page.dart';
import 'package:teigi_app/core/page/user_search_page.dart';
import 'package:teigi_app/core/page/user_search_result_page.dart';
import 'package:teigi_app/core/page/user_word_definition_list_page.dart';
import 'package:teigi_app/core/page/welcome_page.dart';
import 'package:teigi_app/core/page/word_registration_page.dart';
import 'package:teigi_app/core/page/word_search_result_page.dart';
import 'package:teigi_app/core/page/word_top_page.dart';
import 'package:teigi_app/feature/definition/application/definition_state.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition/domain/definition_for_write.dart';
import 'package:teigi_app/feature/definition/presentation/write_definition_base_page.dart';
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart';
import 'package:teigi_app/feature/timeline/application/discover_timeline_state.dart';
import 'package:teigi_app/feature/user_config/application/user_config_state.dart';
import 'package:teigi_app/feature/user_list/application/user_id_list_state_notifier.dart';
import 'package:teigi_app/feature/user_list/util/user_list_type.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';
import 'package:teigi_app/feature/user_search/application/user_search_state.dart';
import 'package:teigi_app/feature/word_list/application/community_dictionary_index_list_state.dart';
import 'package:teigi_app/feature/word_list/application/saved_word_list_state.dart';
import 'package:teigi_app/feature/word_list/application/user_dictionary_index_list_state.dart';
import 'package:teigi_app/feature/word_list/application/word_list_state_by_search_word.dart';

import 'fixtures.dart';
import 'scenario.dart';

/// 状態 ID と非同期状態の対応。ほとんどの画面は 4 状態を共有する。
const _modes = {
  'default': Mode.data,
  'empty': Mode.empty,
  'loading': Mode.loading,
  'error': Mode.error,
};

/// 4 状態それぞれについて、[build] で [Scenario] を作る表を返す。
Map<String, ScenarioBuilder> _byMode(Scenario Function(Mode mode) build) => {
  for (final entry in _modes.entries) entry.key: () => build(entry.value),
};

Scenario _page(Widget widget, List<Override> overrides) =>
    Scenario(widget: widget, overrides: [...signedIn, ...overrides]);

/// 画面の状態。キーは `targets.json` の対象 ID と状態 ID。
///
/// 通信を伴う provider は、[Mode] に応じて固定値・空・未完了・例外を返す
/// fake に差し替える。`screen.base` は対象外（`targets.json` の excluded 参照）。
final Map<String, Map<String, ScenarioBuilder>> screenScenarios = {
  'screen.welcome': {'default': () => const Scenario(widget: WelcomePage())},
  'screen.sign_in_failure': {
    'default': () => const Scenario(widget: SignInFailurePage()),
  },
  'screen.home': _byMode(
    (mode) => _page(const HomePage(), [
      discoverTimelineStateNotifierProvider.overrideWith(
        () => FakeTimeline(mode),
      ),
      definitionFeed(DefinitionFeedType.homeFollowing, mode),
      ...definitionRows(),
    ]),
  ),
  'screen.dictionary_individual': _byMode(
    (mode) => _page(
      const DictionaryIndividualPage(targetUserId: meId, isTopRoute: true),
      [
        ...profiles(),
        userDictionaryIndexListStateNotifierProvider(
          meId,
        ).overrideWith(() => FakeUserIndex(mode)),
      ],
    ),
  ),
  'screen.dictionary_everyone': _byMode(
    (mode) => _page(const DictionaryEveryonePage(), [
      communityDictionaryIndexListStateNotifierProvider.overrideWith(
        () => FakeCommunityIndex(mode),
      ),
    ]),
  ),
  'screen.word_top': {
    ..._byMode(
      (mode) => _page(const WordTopPage(wordId: 'word-1'), [
        wordOf(Mode.data),
        definitionFeed(
          DefinitionFeedType.wordTopOrderByCreatedAt,
          mode,
          wordId: 'word-1',
        ),
        definitionFeed(
          DefinitionFeedType.wordTopOrderByLikesCount,
          mode,
          wordId: 'word-1',
        ),
        ...definitionRows(),
      ]),
    ),
    'not-found': () =>
        _page(const WordTopPage(wordId: 'word-1'), [wordOf(Mode.empty)]),
  },
  'screen.word_search_result': _byMode(
    (mode) => _page(const WordSearchResultPage(searchWord: 'カレー'), [
      wordListStateBySearchWordNotifierProvider(
        'カレー',
      ).overrideWith(() => FakeSearchResult(mode)),
    ]),
  ),
  'screen.word_registration': {
    'default': () => _page(const WordRegistrationPage(), const []),
    'with-initial-word': () =>
        _page(const WordRegistrationPage(initialWord: '二日目のカレー'), const []),
  },
  'screen.definition_detail': {
    'default': () => _page(
      const DefinitionDetailPage(definitionId: 'def-1'),
      definitionRows(),
    ),
    'own': () => _page(
      const DefinitionDetailPage(definitionId: 'def-2'),
      definitionRows(),
    ),
    'loading': () => _page(const DefinitionDetailPage(definitionId: 'def-1'), [
      definitionProvider(
        'def-1',
      ).overrideWith((ref) => Completer<Definition>().future),
    ]),
    'error': () => _page(const DefinitionDetailPage(definitionId: 'def-1'), [
      definitionProvider('def-1').overrideWith((ref) async {
        throw Exception('UI レビュー用のエラー');
      }),
    ]),
  },
  'screen.definition_post': {
    'empty-form': () => _page(
      const DefinitionPostPage(
        initialDefinitionForWrite: null,
        autoFocusForm: null,
      ),
      const [],
    ),
    'with-word': () => _page(
      DefinitionPostPage(
        initialDefinitionForWrite: DefinitionForWrite.fromWord(
          sampleWord,
          meId,
        ),
        autoFocusForm: WriteDefinitionFormType.definition,
      ),
      const [],
    ),
  },
  'screen.definition_edit': {
    'default': () => _page(
      DefinitionEditPage(initialDefinition: sampleDefinitions[1]),
      const [],
    ),
  },
  'screen.profile_top': {
    ..._byMode(
      (mode) => _page(const ProfileTopPage(targetUserId: meId), [
        ...profiles(),
        definitionFeed(
          DefinitionFeedType.profileOrderByCreatedAt,
          mode,
          targetUserId: meId,
        ),
        definitionFeed(
          DefinitionFeedType.profileLiked,
          mode,
          targetUserId: meId,
        ),
        savedWordListStateNotifierProvider.overrideWith(
          () => FakeSavedWords(mode),
        ),
        ...definitionRows(),
      ]),
    ),
    'other-user': () => _page(const ProfileTopPage(targetUserId: otherId), [
      ...profiles(),
      definitionFeed(
        DefinitionFeedType.profileOrderByCreatedAt,
        Mode.data,
        targetUserId: otherId,
      ),
      definitionFeed(
        DefinitionFeedType.profileLiked,
        Mode.data,
        targetUserId: otherId,
      ),
      ...definitionRows(),
    ]),
  },
  'screen.profile_edit': {
    'default': () => _page(ProfileEditPage(), profiles()),
    'loading': () => _page(ProfileEditPage(), [
      userProfileProvider(
        meId,
      ).overrideWith((ref) => Completer<UserProfile>().future),
    ]),
  },
  'screen.setting': {
    'default': () => _page(const SettingPage(), [
      appVersionProvider.overrideWith((ref) async => '1.2.3'),
      ...profiles(),
    ]),
  },
  'screen.license': {
    'default': () => _page(const MyLicensePage(), [
      appVersionProvider.overrideWith((ref) async => '1.2.3'),
    ]),
    'loading': () => _page(const MyLicensePage(), [
      appVersionProvider.overrideWith((ref) => Completer<String>().future),
    ]),
  },
  'screen.user_search': {
    'default': () => _page(const UserSearchPage(), const []),
  },
  'screen.user_search_result': {
    'found': () => _page(const UserSearchResultPage(searchWord: '123456789'), [
      ...profiles(),
      userIdSearchByPublicIdProvider(
        '123456789',
      ).overrideWith((ref) async => otherId),
    ]),
    'not-found': () =>
        _page(const UserSearchResultPage(searchWord: '123456789'), [
          userIdSearchByPublicIdProvider(
            '123456789',
          ).overrideWith((ref) async => null),
        ]),
  },
  'screen.user_list_following_or_follower': {
    for (final tab in FollowingAndFollowerListTab.values)
      for (final mode in [Mode.data, Mode.empty])
        '${tab.name}${mode == Mode.empty ? '-empty' : ''}': () => _page(
          UserListFollowingOrFollowerPage(initialTab: tab, targetUserId: meId),
          [
            ...profiles(),
            for (final type in [UserListType.following, UserListType.follower])
              userIdListStateNotifierProvider(
                type,
                targetUserId: meId,
                targetDefinitionId: null,
              ).overrideWith(() => FakeUserIdList(mode)),
          ],
        ),
  },
  'screen.user_list_liked': _byMode(
    (mode) => _page(const UserListLikedPage(definitionId: 'def-1'), [
      ...profiles(),
      userIdListStateNotifierProvider(
        UserListType.liked,
        targetUserId: null,
        targetDefinitionId: 'def-1',
      ).overrideWith(() => FakeUserIdList(mode)),
    ]),
  ),
  'screen.user_list_muted': _byMode(
    (mode) => _page(const UserListMutedPage(), [
      ...profiles(),
      mutedUserIdListProvider.overrideWith((ref) async {
        return pick<List<String>>(
          mode,
          data: const [otherId, 'user-3'],
          empty: const [],
        );
      }),
    ]),
  ),
  'screen.user_word_definition_list': _byMode(
    (mode) => _page(
      const UserWordDefinitionListPage(
        targetUserId: meId,
        wordId: 'word-1',
        wordLabel: '二日目のカレー',
      ),
      [
        definitionFeed(
          DefinitionFeedType.userWordDefinitions,
          mode,
          wordId: 'word-1',
          targetUserId: meId,
        ),
        ...definitionRows(),
      ],
    ),
  ),
};
