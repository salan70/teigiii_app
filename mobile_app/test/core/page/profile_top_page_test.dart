import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/profile_top_page.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition_list/application/definition_list_state.dart';
import 'package:teigi_app/feature/definition_list/domain/definition_list_state.dart';
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';
import 'package:teigi_app/feature/word_list/application/saved_word_list_state.dart';
import 'package:teigi_app/feature/word_list/domain/word_list_state.dart';
import 'package:teigi_app/util/constant/initial_main_group.dart';

class _EmptyDefinitionList extends DefinitionListStateNotifier {
  @override
  FutureOr<DefinitionListState> build(
    DefinitionFeedType definitionFeedType, {
    String? wordId,
    String? targetUserId,
    InitialSubGroup? initialSubGroup,
  }) async {
    return const DefinitionListState(
      list: [],
      nextCursor: null,
      hasMore: false,
    );
  }
}

class _EmptySavedWordList extends SavedWordListStateNotifier {
  @override
  FutureOr<WordListState> build() async {
    return const WordListState(list: [], nextCursor: null, hasMore: false);
  }
}

UserProfile _profileFor(String id) => UserProfile(
  id: id,
  publicId: '123456789',
  name: 'テストユーザー',
  bio: 'bio',
  avatarUrl: null,
  followingCount: 0,
  followerCount: 0,
  isFollowedByMe: false,
  croppedFile: null,
);

Future<void> _pumpProfile(
  WidgetTester tester, {
  required String currentUserId,
  required String targetUserId,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userIdProvider.overrideWithValue(currentUserId),
        userProfileProvider(
          targetUserId,
        ).overrideWith((ref) async => _profileFor(targetUserId)),
        definitionListStateNotifierProvider(
          DefinitionFeedType.profileOrderByCreatedAt,
          targetUserId: targetUserId,
        ).overrideWith(_EmptyDefinitionList.new),
        definitionListStateNotifierProvider(
          DefinitionFeedType.profileLiked,
          targetUserId: targetUserId,
        ).overrideWith(_EmptyDefinitionList.new),
        savedWordListStateNotifierProvider.overrideWith(
          _EmptySavedWordList.new,
        ),
      ],
      child: MaterialApp(home: ProfileTopPage(targetUserId: targetUserId)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('自分のプロフィールは投稿順・いいね・保存の3タブ', (tester) async {
    await _pumpProfile(tester, currentUserId: 'user-1', targetUserId: 'user-1');

    expect(find.text('投稿順'), findsOneWidget);
    expect(find.text('いいね'), findsOneWidget);
    expect(find.text('保存'), findsOneWidget);
  });

  testWidgets('他者のプロフィールは投稿順・いいねの2タブのみ', (tester) async {
    await _pumpProfile(
      tester,
      currentUserId: 'user-1',
      targetUserId: 'other-user',
    );

    expect(find.text('投稿順'), findsOneWidget);
    expect(find.text('いいね'), findsOneWidget);
    expect(find.text('保存'), findsNothing);
  });
}
