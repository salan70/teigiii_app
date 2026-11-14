import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition/application/definition_state.dart';
import 'package:teigi_app/feature/definition/domain/definition.dart';
import 'package:teigi_app/feature/definition_list/application/definition_list_state.dart';
import 'package:teigi_app/feature/definition_list/domain/definition_list_state.dart';
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart';
import 'package:teigi_app/feature/timeline/application/discover_timeline_state.dart';
import 'package:teigi_app/feature/timeline/domain/discover_feed_entry.dart';
import 'package:teigi_app/feature/timeline/domain/discover_feed_list_state.dart';
import 'package:teigi_app/feature/timeline/domain/registered_word_activity.dart';
import 'package:teigi_app/feature/user_list/application/user_id_list_state_notifier.dart';
import 'package:teigi_app/feature/user_list/domain/user_id_list_state.dart';
import 'package:teigi_app/feature/user_list/util/user_list_type.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';
import 'package:teigi_app/feature/word/application/word_state.dart';
import 'package:teigi_app/feature/word/domain/word.dart';
import 'package:teigi_app/feature/word_list/application/community_dictionary_index_list_state.dart';
import 'package:teigi_app/feature/word_list/application/saved_word_list_state.dart';
import 'package:teigi_app/feature/word_list/application/user_dictionary_index_list_state.dart';
import 'package:teigi_app/feature/word_list/application/word_list_state_by_search_word.dart';
import 'package:teigi_app/feature/word_list/domain/dictionary_index_entry.dart';
import 'package:teigi_app/feature/word_list/domain/dictionary_index_list_state.dart';
import 'package:teigi_app/feature/word_list/domain/word_list_state.dart';

/// 画面の非同期状態。`targets.json` の状態 ID（`default` / `empty` / `loading` /
/// `error`）に対応する。
enum Mode { data, empty, loading, error }

/// [mode] に応じた非同期の結果を返す。
///
/// loading は完了しない Future、error は例外にする。
FutureOr<T> pick<T>(Mode mode, {required T data, required T empty}) {
  switch (mode) {
    case Mode.data:
      return data;
    case Mode.empty:
      return empty;
    case Mode.loading:
      return Completer<T>().future;
    case Mode.error:
      throw Exception('UI レビュー用のエラー');
  }
}

const meId = 'user-me';
const otherId = 'user-other';

UserProfile profileOf(
  String id, {
  String name = 'たろう',
  String bio = '言葉の定義を集めています。',
  int following = 12,
  int follower = 34,
  bool isFollowedByMe = false,
}) => UserProfile(
  id: id,
  publicId: '123456789',
  name: name,
  bio: bio,
  avatarUrl: null,
  followingCount: following,
  followerCount: follower,
  isFollowedByMe: isFollowedByMe,
  croppedFile: null,
);

final _createdAt = DateTime(2026, 1, 15, 21, 30);

Definition definitionOf(
  String id, {
  String word = '二日目のカレー',
  String reading = 'ふつかめのかれー',
  String body = '作ってから一晩経ったカレー。具材に味がしみて、ばり美味い。',
  String authorId = otherId,
  String authorName = 'はなこ',
  int likes = 3,
  bool liked = false,
}) => Definition(
  id: id,
  wordId: 'word-1',
  word: word,
  wordReading: reading,
  authorId: authorId,
  authorName: authorName,
  authorImageUrl: null,
  definition: body,
  isPublic: true,
  likesCount: likes,
  isLikedByUser: liked,
  createdAt: _createdAt,
);

final sampleDefinitions = [
  definitionOf('def-1'),
  definitionOf(
    'def-2',
    body: '短い定義。',
    authorId: meId,
    authorName: 'たろう',
    likes: 0,
  ),
  definitionOf(
    'def-3',
    body:
        'とても長い定義の例。折り返しや行数の制限がどう見えるかを確かめるために、'
        '文章を長めに続ける。これは 3 行を超えるように書いている。',
    likes: 128,
    liked: true,
  ),
];

const sampleWord = Word(
  id: 'word-1',
  word: '二日目のカレー',
  reading: 'ふつかめのかれー',
  initialSubGroupLabel: 'は行',
  postedDefinitionCount: 3,
);

const _sampleWords = [
  sampleWord,
  Word(
    id: 'word-2',
    word: '余白',
    reading: 'よはく',
    initialSubGroupLabel: 'や行',
    postedDefinitionCount: 1,
  ),
  Word(
    id: 'word-3',
    word: '朝活',
    reading: 'あさかつ',
    initialSubGroupLabel: 'あ行',
    postedDefinitionCount: 0,
  ),
];

const _sampleIndex = DictionaryIndexListState(
  list: [
    DictionaryIndexEntry.sectionHeader('あ行'),
    DictionaryIndexEntry.word(
      Word(
        id: 'word-3',
        word: '朝活',
        reading: 'あさかつ',
        initialSubGroupLabel: 'あ行',
        postedDefinitionCount: 0,
      ),
    ),
    DictionaryIndexEntry.sectionHeader('は行'),
    DictionaryIndexEntry.word(sampleWord),
    DictionaryIndexEntry.sectionHeader('や行'),
    DictionaryIndexEntry.word(
      Word(
        id: 'word-2',
        word: '余白',
        reading: 'よはく',
        initialSubGroupLabel: 'や行',
        postedDefinitionCount: 1,
      ),
    ),
  ],
  allWords: _sampleWords,
  nextCursor: null,
  hasMore: false,
);

const _emptyIndex = DictionaryIndexListState(
  list: [],
  allWords: [],
  nextCursor: null,
  hasMore: false,
);

final _sampleDefinitionList = DefinitionListState(
  list: sampleDefinitions,
  nextCursor: null,
  hasMore: false,
);

const _emptyDefinitionList = DefinitionListState(
  list: [],
  nextCursor: null,
  hasMore: false,
);

// ---------------------------------------------------------------- fake

class FakeDefinitionList extends DefinitionListStateNotifier {
  FakeDefinitionList(this.mode);
  final Mode mode;

  @override
  FutureOr<DefinitionListState> build(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
  }) => pick(mode, data: _sampleDefinitionList, empty: _emptyDefinitionList);
}

class FakeTimeline extends DiscoverTimelineStateNotifier {
  FakeTimeline(this.mode);
  final Mode mode;

  @override
  FutureOr<DiscoverFeedListState> build() => pick(
    mode,
    data: DiscoverFeedListState(
      list: [
        DiscoverFeedEntry.definition(sampleDefinitions[0]),
        DiscoverFeedEntry.wordRegistered(
          RegisteredWordActivity(
            wordId: 'word-2',
            word: '余白',
            reading: 'よはく',
            occurredAt: _createdAt,
          ),
        ),
        DiscoverFeedEntry.definition(sampleDefinitions[2]),
      ],
      nextCursor: null,
      hasMore: false,
    ),
    empty: const DiscoverFeedListState(
      list: [],
      nextCursor: null,
      hasMore: false,
    ),
  );
}

class FakeCommunityIndex extends CommunityDictionaryIndexListStateNotifier {
  FakeCommunityIndex(this.mode);
  final Mode mode;

  @override
  FutureOr<DictionaryIndexListState> build() =>
      pick(mode, data: _sampleIndex, empty: _emptyIndex);
}

class FakeUserIndex extends UserDictionaryIndexListStateNotifier {
  FakeUserIndex(this.mode);
  final Mode mode;

  @override
  FutureOr<DictionaryIndexListState> build(String targetUserId) =>
      pick(mode, data: _sampleIndex, empty: _emptyIndex);
}

class FakeSavedWords extends SavedWordListStateNotifier {
  FakeSavedWords(this.mode);
  final Mode mode;

  @override
  FutureOr<WordListState> build() => pick(
    mode,
    data: const WordListState(
      list: _sampleWords,
      nextCursor: null,
      hasMore: false,
    ),
    empty: const WordListState(list: [], nextCursor: null, hasMore: false),
  );
}

class FakeSearchResult extends WordListStateBySearchWordNotifier {
  FakeSearchResult(this.mode);
  final Mode mode;

  @override
  FutureOr<WordListState> build(String searchWord) => pick(
    mode,
    data: const WordListState(
      list: _sampleWords,
      nextCursor: null,
      hasMore: false,
    ),
    empty: const WordListState(list: [], nextCursor: null, hasMore: false),
  );
}

class FakeUserIdList extends UserIdListStateNotifier {
  FakeUserIdList(this.mode);
  final Mode mode;

  @override
  FutureOr<UserIdListState> build(
    UserListType userListType, {
    required String? targetUserId,
    required String? targetDefinitionId,
  }) => pick(
    mode,
    data: const UserIdListState(
      list: [otherId, 'user-3', 'user-4'],
      nextCursor: null,
      hasMore: false,
    ),
    empty: const UserIdListState(list: [], nextCursor: null, hasMore: false),
  );
}

// ---------------------------------------------------------------- override

/// 自分でログインしている状態。ほとんどの画面で必要になる。
final List<Override> signedIn = [userIdProvider.overrideWithValue(meId)];

/// 一覧の定義と、各行が引く著者のプロフィールをそろえる。
List<Override> definitionRows() => [
  for (final d in sampleDefinitions)
    definitionProvider(d.id).overrideWith((ref) async => d),
  ...profiles(),
];

/// 画面に出うる利用者のプロフィール。
List<Override> profiles() => [
  userProfileProvider(meId).overrideWith((ref) async => profileOf(meId)),
  userProfileProvider(otherId).overrideWith(
    (ref) async => profileOf(otherId, name: 'はなこ', isFollowedByMe: true),
  ),
  userProfileProvider(
    'user-3',
  ).overrideWith((ref) async => profileOf('user-3', name: 'じろう')),
  userProfileProvider(
    'user-4',
  ).overrideWith((ref) async => profileOf('user-4', name: 'さぶろう')),
];

Override definitionFeed(
  DefinitionFeedType type,
  Mode mode, {
  String? wordId,
  String? targetUserId,
}) => definitionListStateNotifierProvider(
  type,
  wordId: wordId,
  targetUserId: targetUserId,
).overrideWith(() => FakeDefinitionList(mode));

Override wordOf(Mode mode) => wordProvider('word-1').overrideWith((ref) async {
  return pick<Word?>(mode, data: sampleWord, empty: null);
});
