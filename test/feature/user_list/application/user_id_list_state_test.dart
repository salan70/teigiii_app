import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/user_list/application/user_id_list_state_notifier.dart';
import 'package:teigi_app/feature/user_list/domain/user_id_list_state.dart';
import 'package:teigi_app/feature/user_list/repository/fetch_user_list_repository.dart';
import 'package:teigi_app/feature/user_list/util/user_list_type.dart';

import 'user_id_list_state_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FetchUserListRepository>()])
void main() {
  final repository = MockFetchUserListRepository();
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        fetchUserListRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() => reset(repository));

  test('フォロー中一覧へ targetUserId と null cursor を渡す', () async {
    when(repository.fetchFollowingIdList('target', null)).thenAnswer(
      (_) async => const UserIdListState(
        list: ['user-1'],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = userIdListStateNotifierProvider(
      UserListType.following,
      targetUserId: 'target',
      targetDefinitionId: null,
    );

    final state = await container.read(provider.future);

    expect(state.list, ['user-1']);
    verify(repository.fetchFollowingIdList('target', null)).called(1);
  });

  test('fetchMore は nextCursor を渡して結果を連結する', () async {
    when(repository.fetchFollowerIdList('target', null)).thenAnswer(
      (_) async => const UserIdListState(
        list: ['user-1'],
        nextCursor: 'cursor-1',
        hasMore: true,
      ),
    );
    when(repository.fetchFollowerIdList('target', 'cursor-1')).thenAnswer(
      (_) async => const UserIdListState(
        list: ['user-2'],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = userIdListStateNotifierProvider(
      UserListType.follower,
      targetUserId: 'target',
      targetDefinitionId: null,
    );
    await container.read(provider.future);

    await container.read(provider.notifier).fetchMore();

    expect(
      container.read(provider).value,
      const UserIdListState(
        list: ['user-1', 'user-2'],
        nextCursor: null,
        hasMore: false,
      ),
    );
    verify(repository.fetchFollowerIdList('target', 'cursor-1')).called(1);
  });

  test('いいね一覧へ definitionId を渡す', () async {
    when(repository.fetchLikedUserIdList('definition-1', null)).thenAnswer(
      (_) async => const UserIdListState(
        list: ['user-1'],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = userIdListStateNotifierProvider(
      UserListType.liked,
      targetUserId: null,
      targetDefinitionId: 'definition-1',
    );

    final state = await container.read(provider.future);

    expect(state.list, ['user-1']);
    verify(repository.fetchLikedUserIdList('definition-1', null)).called(1);
  });
}
