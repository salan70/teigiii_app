@Tags(['golden'])
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:teigi_app/core/page/dictionary_everyone_page.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition/application/definition_for_write_notifier.dart';
import 'package:teigi_app/feature/definition/domain/definition_for_write.dart';
import 'package:teigi_app/feature/definition/presentation/write_definition_base_page.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';
import 'package:teigi_app/feature/word_list/application/community_dictionary_index_list_state.dart';
import 'package:teigi_app/feature/word_list/domain/dictionary_index_list_state.dart';

import 'ds_golden_harness.dart';

/// パイロット 2 系統の golden。
///
/// **移行前後の見た目が変わっていないことを確認するためのもの**。
/// ローカル限定で、CI では実行しない。
class _EmptyIndexList extends CommunityDictionaryIndexListStateNotifier {
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

class _LoadingIndexList extends CommunityDictionaryIndexListStateNotifier {
  @override
  FutureOr<DictionaryIndexListState> build() {
    return Completer<DictionaryIndexListState>().future;
  }
}

class _ErrorIndexList extends CommunityDictionaryIndexListStateNotifier {
  @override
  FutureOr<DictionaryIndexListState> build() async {
    throw Exception('golden 用のエラー');
  }
}

class _MockDefinitionForWriteNotifier extends Mock
    implements DefinitionForWriteNotifier {}

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

const _definition = DefinitionForWrite(
  id: null,
  authorId: 'user-1',
  word: '二日目のカレー',
  wordReading: 'ふつかめのかれー',
  isPublic: true,
  definition: '作ってから一晩経ったカレー。ばり美味い',
);

void main() {
  setUpAll(loadDsFonts);

  Future<void> pumpPage(
    WidgetTester tester,
    Widget page, {
    List<Override> overrides = const [],
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildDsThemeData(Brightness.light),
          home: page,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('DictionaryEveryonePage', () {
    final baseOverrides = [
      userIdProvider.overrideWithValue('user-1'),
      userProfileProvider('user-1').overrideWith((ref) async => _profile),
    ];

    testWidgets('empty', (tester) async {
      await pumpPage(
        tester,
        const DictionaryEveryonePage(),
        overrides: [
          ...baseOverrides,
          communityDictionaryIndexListStateNotifierProvider.overrideWith(
            _EmptyIndexList.new,
          ),
        ],
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/dictionary_everyone_empty.png'),
      );
    });

    testWidgets('loading', (tester) async {
      await pumpPage(
        tester,
        const DictionaryEveryonePage(),
        overrides: [
          ...baseOverrides,
          communityDictionaryIndexListStateNotifierProvider.overrideWith(
            _LoadingIndexList.new,
          ),
        ],
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/dictionary_everyone_loading.png'),
      );
    });

    testWidgets('error', (tester) async {
      await pumpPage(
        tester,
        const DictionaryEveryonePage(),
        overrides: [
          ...baseOverrides,
          communityDictionaryIndexListStateNotifierProvider.overrideWith(
            _ErrorIndexList.new,
          ),
        ],
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/dictionary_everyone_error.png'),
      );
    });
  });

  group('WriteDefinitionBasePage', () {
    testWidgets('入力済み', (tester) async {
      await pumpPage(
        tester,
        WriteDefinitionBasePage(
          definitionForWrite: _definition,
          notifier: _MockDefinitionForWriteNotifier(),
          appBarActionWidget: const SizedBox.shrink(),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/write_definition_base_filled.png'),
      );
    });

    testWidgets('編集時は言葉が読み取り専用', (tester) async {
      await pumpPage(
        tester,
        WriteDefinitionBasePage(
          definitionForWrite: _definition.copyWith(id: 'definition-1'),
          notifier: _MockDefinitionForWriteNotifier(),
          appBarActionWidget: const SizedBox.shrink(),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/write_definition_base_editing.png'),
      );
    });
  });
}
