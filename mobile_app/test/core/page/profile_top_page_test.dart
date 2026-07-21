import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/profile_top_page.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/public_dictionary/domain/public_dictionary_state.dart';
import 'package:teigi_app/feature/public_dictionary/repository/public_dictionary_repository.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';

class _PublicDictionaryRepositoryStub implements PublicDictionaryRepository {
  @override
  Future<PublicDictionaryState> fetch(String userId, String? cursor) async =>
      const PublicDictionaryState(list: [], nextCursor: null, hasMore: false);
}

void main() {
  testWidgets('公開辞書を主表示し、いいねした投稿への独立導線を残す', (tester) async {
    const profile = UserProfile(
      id: 'user-1',
      publicId: '123456789',
      name: 'テスト太郎',
      bio: '自己紹介',
      publicDefinitionCount: 3,
      avatarUrl: null,
      followingCount: 1,
      followerCount: 2,
      isFollowedByMe: false,
      croppedFile: null,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userIdProvider.overrideWithValue('user-1'),
          userProfileProvider('user-1').overrideWith((ref) async => profile),
          publicDictionaryRepositoryProvider.overrideWithValue(
            _PublicDictionaryRepositoryStub(),
          ),
        ],
        child: const MaterialApp(home: ProfileTopPage(targetUserId: 'user-1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('公開定義 3'), findsOneWidget);
    expect(find.text('いいねした投稿'), findsOneWidget);
    expect(find.text('公開辞書'), findsOneWidget);
    expect(find.text('投稿順'), findsNothing);
  });
}
