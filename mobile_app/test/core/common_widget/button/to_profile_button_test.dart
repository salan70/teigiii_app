import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/common_widget/button/to_profile_button.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';

void main() {
  testWidgets('プロフィール読み込み中はボタンを表示しない', (tester) async {
    const userId = 'current-user-id';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userIdProvider.overrideWithValue(userId),
          userProfileProvider(
            userId,
          ).overrideWith((ref) => Completer<UserProfile>().future),
        ],
        child: const MaterialApp(home: Scaffold(body: ToProfileButton())),
      ),
    );

    expect(find.byType(IconButton), findsNothing);
  });
}
