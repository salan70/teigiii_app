import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/dictionary_individual_page.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';
import 'package:teigi_app/feature/word_list/application/user_dictionary_index_list_state.dart';
import 'package:teigi_app/feature/word_list/domain/dictionary_index_list_state.dart';

class _EmptyUserDictionaryIndex extends UserDictionaryIndexListStateNotifier {
  @override
  FutureOr<DictionaryIndexListState> build(String targetUserId) async {
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
  testWidgets('自分の辞書トップに保存した言葉の導線を置かない', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userIdProvider.overrideWithValue('user-1'),
          userProfileProvider('user-1').overrideWith((ref) async => _profile),
          userDictionaryIndexListStateNotifierProvider(
            'user-1',
          ).overrideWith(_EmptyUserDictionaryIndex.new),
        ],
        child: const MaterialApp(
          home: DictionaryIndividualPage(
            targetUserId: 'user-1',
            isTopRoute: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('保存した言葉'), findsNothing);
  });
}
