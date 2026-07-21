import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/page/global_search_page.dart';
import 'package:teigi_app/feature/community_dictionary/domain/community_dictionary.dart';
import 'package:teigi_app/feature/user_search/domain/user_search_result_state.dart';
import 'package:teigi_app/feature/user_search/repository/user_search_repository.dart';
import 'package:teigi_app/feature/word_list/domain/word_list_state.dart';
import 'package:teigi_app/feature/word_list/repository/fetch_word_list_repository.dart';

class _WordRepositoryStub implements FetchWordListRepository {
  final calls = <String>[];

  @override
  Future<WordListState> fetchWordListStateBySearchWord(
    String searchWord,
    String? cursor,
  ) async {
    calls.add(searchWord);
    return const WordListState(list: [], nextCursor: null, hasMore: false);
  }

  @override
  Future<WordListState> fetchCommunityWordList({
    required CommunityWordFilter filter,
    required String query,
    required String? cursor,
  }) => throw UnimplementedError();

  @override
  Future<WordListState> fetchWordListStateByInitial(
    String initial,
    String? cursor,
  ) => throw UnimplementedError();
}

class _UserRepositoryStub implements UserSearchRepository {
  final calls = <String>[];

  @override
  Future<UserSearchResultState> search(String query, String? cursor) async {
    calls.add(query);
    return const UserSearchResultState(
      list: [],
      nextCursor: null,
      hasMore: false,
    );
  }

  @override
  Future<String?> searchByPublicId(String publicId) =>
      throw UnimplementedError();
}

void main() {
  testWidgets('入力中は検索せず、検索操作で同じ query の2タブを表示する', (tester) async {
    final words = _WordRepositoryStub();
    final users = _UserRepositoryStub();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fetchWordListRepositoryProvider.overrideWithValue(words),
          userSearchRepositoryProvider.overrideWithValue(users),
        ],
        child: const MaterialApp(home: GlobalSearchPage()),
      ),
    );

    await tester.enterText(find.byType(TextField), ' 余白 ');
    await tester.pump();
    expect(words.calls, isEmpty);
    expect(users.calls, isEmpty);

    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('言葉'), findsOneWidget);
    expect(find.text('ユーザー'), findsOneWidget);
    expect(words.calls, ['余白']);
    expect(find.text(' 余白 '), findsOneWidget);

    await tester.tap(find.text('ユーザー'));
    await tester.pumpAndSettle();
    expect(users.calls, ['余白']);
    expect(find.text(' 余白 '), findsOneWidget);
  });

  testWidgets('空文字の検索操作では API を呼ばない', (tester) async {
    final words = _WordRepositoryStub();
    final users = _UserRepositoryStub();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fetchWordListRepositoryProvider.overrideWithValue(words),
          userSearchRepositoryProvider.overrideWithValue(users),
        ],
        child: const MaterialApp(home: GlobalSearchPage()),
      ),
    );

    await tester.enterText(find.byType(TextField), '   ');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(words.calls, isEmpty);
    expect(users.calls, isEmpty);
    expect(find.text('検索語を入力してください'), findsOneWidget);
  });
}
