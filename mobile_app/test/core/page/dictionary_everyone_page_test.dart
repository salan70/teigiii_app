import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/dictionary_everyone_page.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition/presentation/post_definition_fab.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';
import 'package:teigi_app/feature/word_list/application/community_dictionary_index_list_state.dart';
import 'package:teigi_app/feature/word_list/domain/dictionary_index_list_state.dart';

class _EmptyCommunityDictionaryIndex
    extends CommunityDictionaryIndexListStateNotifier {
  @override
  FutureOr<DictionaryIndexListState> build() async {
    return const DictionaryIndexListState(
      list: [],
      allWords: [],
      nextCursor: null,
      hasMore: false,
    );
  }
}

const _profile = UserProfile(
  id: 'user-1',
  publicId: '123456789',
  name: 'テストユーザー',
  bio: 'bio',
  avatarUrl: null,
  followingCount: 0,
  followerCount: 0,
  isFollowedByMe: false,
  croppedFile: null,
);

void main() {
  testWidgets('AppBar に言葉を登録がなく拡張 FAB がある', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userIdProvider.overrideWithValue('user-1'),
          userProfileProvider('user-1').overrideWith((ref) async => _profile),
          communityDictionaryIndexListStateNotifierProvider.overrideWith(
            _EmptyCommunityDictionaryIndex.new,
          ),
        ],
        child: const MaterialApp(home: DictionaryEveryonePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('言葉を登録')),
      findsNothing,
    );
    expect(find.byType(PostDefinitionFAB), findsOneWidget);
  });
}
