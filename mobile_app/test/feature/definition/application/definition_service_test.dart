import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/analytics/analytics_event.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition/application/definition_seed_store.dart';
import 'package:teigi_app/feature/definition_like/application/like_definition_service.dart';
import 'package:teigi_app/feature/definition_like/repository/like_definition_repository.dart';
import 'package:teigi_app/feature/definition_list/appication/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition_list/domain/definition_id_list_state.dart';
import 'package:teigi_app/feature/definition_list/repository/definition_id_list_repository.dart';
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart';

import '../../../mock/fake_analytics.dart';
import '../../../mock/mock_data.dart';
import 'definition_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LikeDefinitionRepository>(),
  MockSpec<DefinitionIdListRepository>(),
])
void main() {
  final mockLikeDefinitionRepository = MockLikeDefinitionRepository();
  final mockDefinitionIdListRepository = MockDefinitionIdListRepository();

  late ProviderContainer container;
  late FakeAnalyticsClient fakeAnalytics;

  setUp(() {
    fakeAnalytics = FakeAnalyticsClient();
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => 'current-user'),
        likeDefinitionRepositoryProvider.overrideWithValue(
          mockLikeDefinitionRepository,
        ),
        definitionIdListRepositoryProvider.overrideWithValue(
          mockDefinitionIdListRepository,
        ),
        ...analyticsTestOverrides(fakeAnalytics),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockLikeDefinitionRepository);
    reset(mockDefinitionIdListRepository);
  });

  group('tapLike()', () {
    test('いいね登録: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final definitionService = container.read(likeDefinitionServiceProvider);
      // いいね登録のため、isLikedByUserがfalseのDefinitionを用意
      final definition = mockDefinition.copyWith(isLikedByUser: false);

      // * Act
      await definitionService.tapLike(definition);

      // * Assert
      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockLikeDefinitionRepository.likeDefinition(definition.id),
      ).called(1);

      // 想定外の関数が呼ばれていないか検証
      verifyNever(mockLikeDefinitionRepository.unlikeDefinition(any));
      expect(
        fakeAnalytics.loggedEvents.single.name,
        AnalyticsEvent.definitionLiked,
      );
    });

    test('いいね解除: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final definitionService = container.read(likeDefinitionServiceProvider);
      // いいね解除のため、isLikedByUserがtrueのDefinitionを用意
      final definition = mockDefinition.copyWith(isLikedByUser: true);

      // * Act
      await definitionService.tapLike(definition);

      // * Assert
      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockLikeDefinitionRepository.unlikeDefinition(definition.id),
      ).called(1);
      expect(
        fakeAnalytics.loggedEvents.single.name,
        AnalyticsEvent.definitionUnliked,
      );

      // 想定外の関数が呼ばれていないか検証
      verifyNever(mockLikeDefinitionRepository.likeDefinition(any));
    });

    test('ホームフィードのページング状態を保ったままいいねする', () async {
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

      await container
          .read(likeDefinitionServiceProvider)
          .tapLike(mockDefinition.copyWith(isLikedByUser: false));
      await Future<void>.delayed(Duration.zero);

      expect(subscription.read().value?.list, ['definition-1', 'definition-2']);
      verify(
        mockDefinitionIdListRepository.fetchForHomeRecommend(null),
      ).called(1);
      verify(
        mockDefinitionIdListRepository.fetchForHomeRecommend('cursor-1'),
      ).called(1);
    });

    test('いいね後、対象定義のシードが破棄される', () async {
      // * Arrange
      final store = container.read(definitionSeedStoreProvider)
        ..seedAll([mockDefinition]);
      expect(store.read(mockDefinition.id), mockDefinition);

      // * Act
      await container
          .read(likeDefinitionServiceProvider)
          .tapLike(mockDefinition.copyWith(isLikedByUser: false));

      // * Assert
      // シードが残っていると invalidate しても古い likesCount が返るため破棄する。
      expect(store.read(mockDefinition.id), isNull);
    });

    // TODO(me): definitionProviderが再生成されているか検証するテスト書く
    // providerがinvalidateされたことを検証する方法がわからないため一旦保留
    //
    // test('definitionProviderが再生成されているか検証', () async {});
  });
}
