import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition_list/appication/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition_list/domain/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition_list/repository/definition_id_list_repository.dart';
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart';
import 'package:teigi_app/feature/user_follow/application/user_follow_service.dart';
import 'package:teigi_app/feature/user_follow/repository/user_follow_repository.dart';

import 'user_follow_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserFollowRepository>(),
  MockSpec<DefinitionIdListRepository>(),
])
void main() {
  final mockUserFollowRepository = MockUserFollowRepository();
  final mockDefinitionIdListRepository = MockDefinitionIdListRepository();
  const currentUserId = 'userId';

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => currentUserId),
        userFollowRepositoryProvider.overrideWithValue(
          mockUserFollowRepository,
        ),
        definitionIdListRepositoryProvider.overrideWithValue(
          mockDefinitionIdListRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockUserFollowRepository);
    reset(mockDefinitionIdListRepository);
  });

  group('follow', () {
    test('いいね登録: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final userFollowService = container.read(userFollowServiceProvider);
      const targetUserId = 'targetUser';

      // * Act
      await userFollowService.follow(targetUserId);

      // * Assert
      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(mockUserFollowRepository.follow(targetUserId)).called(1);

      // 想定外のrepositoryの関数が呼ばれていないか検証
      verifyNever(mockUserFollowRepository.unfollow(any));
    });

    test('無関係なおすすめフィードのページング状態を保つ', () async {
      when(
        mockDefinitionIdListRepository.fetchForHomeRecommend(null),
      ).thenAnswer(
        (_) async => const DefinitionIdListState(
          list: ['definition-1'],
          nextCursor: 'cursor-1',
          hasMore: true,
        ),
      );
      when(
        mockDefinitionIdListRepository.fetchForHomeRecommend('cursor-1'),
      ).thenAnswer(
        (_) async => const DefinitionIdListState(
          list: ['definition-2'],
          nextCursor: null,
          hasMore: false,
        ),
      );
      final provider = definitionIdListStateNotifierProvider(
        DefinitionFeedType.homeRecommend,
      );
      final subscription = container.listen(
        provider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      await container.read(provider.future);
      await container.read(provider.notifier).fetchMore();

      await container.read(userFollowServiceProvider).follow('targetUser');
      await Future<void>.delayed(Duration.zero);

      expect(subscription.read().value?.list, ['definition-1', 'definition-2']);
      verify(
        mockDefinitionIdListRepository.fetchForHomeRecommend(null),
      ).called(1);
      verify(
        mockDefinitionIdListRepository.fetchForHomeRecommend('cursor-1'),
      ).called(1);
    });
  });

  group('unfollow', () {
    test('いいね登録: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final userFollowService = container.read(userFollowServiceProvider);
      const targetUserId = 'targetUser';

      // * Act
      await userFollowService.unfollow(targetUserId);

      // * Assert
      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(mockUserFollowRepository.unfollow(targetUserId)).called(1);

      // 想定外のrepositoryの関数が呼ばれていないか検証
      verifyNever(mockUserFollowRepository.follow(any));
    });
  });
}
