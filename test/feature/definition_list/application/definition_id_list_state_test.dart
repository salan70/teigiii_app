import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition_list/appication/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition_list/domain/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition_list/repository/definition_id_list_repository.dart';
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart';

import 'definition_id_list_state_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DefinitionIdListRepository>()])
void main() {
  final repository = MockDefinitionIdListRepository();
  var currentUserId = 'user-1';
  late ProviderContainer container;

  setUp(() {
    currentUserId = 'user-1';
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => currentUserId),
        definitionIdListRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() => reset(repository));

  test('初回取得は null cursor を渡す', () async {
    when(repository.fetchForHomeRecommend(null)).thenAnswer(
      (_) async => const DefinitionIdListState(
        list: ['definition-1'],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = definitionIdListStateNotifierProvider(
      DefinitionFeedType.homeRecommend,
    );

    final state = await container.read(provider.future);

    expect(state.list, ['definition-1']);
    verify(repository.fetchForHomeRecommend(null)).called(1);
  });

  test('fetchMore は nextCursor を渡して結果を連結する', () async {
    when(repository.fetchForHomeFollowing(null)).thenAnswer(
      (_) async => const DefinitionIdListState(
        list: ['definition-1'],
        nextCursor: 'cursor-1',
        hasMore: true,
      ),
    );
    when(repository.fetchForHomeFollowing('cursor-1')).thenAnswer(
      (_) async => const DefinitionIdListState(
        list: ['definition-2'],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = definitionIdListStateNotifierProvider(
      DefinitionFeedType.homeFollowing,
    );
    await container.read(provider.future);

    await container.read(provider.notifier).fetchMore();

    expect(
      container.read(provider).value,
      const DefinitionIdListState(
        list: ['definition-1', 'definition-2'],
        nextCursor: null,
        hasMore: false,
      ),
    );
    verify(repository.fetchForHomeFollowing('cursor-1')).called(1);
  });

  test('hasMore が false の場合は追加取得しない', () async {
    when(repository.fetchForHomeRecommend(null)).thenAnswer(
      (_) async => const DefinitionIdListState(
        list: ['definition-1'],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = definitionIdListStateNotifierProvider(
      DefinitionFeedType.homeRecommend,
    );
    await container.read(provider.future);

    await container.read(provider.notifier).fetchMore();

    verify(repository.fetchForHomeRecommend(null)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('アカウントが切り替わると初回 cursor から再取得する', () async {
    when(repository.fetchForHomeRecommend(null)).thenAnswer(
      (_) async => DefinitionIdListState(
        list: [currentUserId],
        nextCursor: null,
        hasMore: false,
      ),
    );
    final provider = definitionIdListStateNotifierProvider(
      DefinitionFeedType.homeRecommend,
    );

    expect((await container.read(provider.future)).list, ['user-1']);
    currentUserId = 'user-2';
    container.invalidate(userIdProvider);

    expect((await container.read(provider.future)).list, ['user-2']);
    verify(repository.fetchForHomeRecommend(null)).called(2);
  });

  test('fetchMore 失敗時は AsyncError に前回の一覧を保持する', () async {
    const initialState = DefinitionIdListState(
      list: ['definition-1'],
      nextCursor: 'cursor-1',
      hasMore: true,
    );
    final exception = Exception('fetch failed');
    when(
      repository.fetchForHomeRecommend(null),
    ).thenAnswer((_) async => initialState);
    when(repository.fetchForHomeRecommend('cursor-1')).thenThrow(exception);
    final provider = definitionIdListStateNotifierProvider(
      DefinitionFeedType.homeRecommend,
    );
    await container.read(provider.future);

    await container.read(provider.notifier).fetchMore();

    final result = container.read(provider);
    expect(result, isA<AsyncError<DefinitionIdListState>>());
    expect(result.error, same(exception));
    expect(result.value, initialState);
  });
}
