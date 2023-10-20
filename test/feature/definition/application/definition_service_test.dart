import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/definition/application/definition_service.dart';
import 'package:teigi_app/feature/definition/repository/definition_repository.dart';

import '../../../mock/mock_data.dart';
import 'definition_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DefinitionRepository>(),
  MockSpec<Listener<AsyncValue<void>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockDefinitionRepository = MockDefinitionRepository();
  final listener = MockListener();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => 'userId'),
        definitionRepositoryProvider
            .overrideWithValue(mockDefinitionRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockDefinitionRepository);
    reset(listener);
  });

  /// definitionServiceProviderをlistenし、DefinitionServiceを返す
  DefinitionService init() {
    container.listen(
      definitionServiceProvider,
      listener,
      fireImmediately: true,
    );

    return container.read(
      definitionServiceProvider.notifier,
    );
  }

  group('tapLike()', () {
    test('いいね登録: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final definitionService = init();
      // いいね登録のため、isLikedByUserがfalseのDefinitionを用意
      final definition = mockDefinition.copyWith(isLikedByUser: false);

      // * Act
      await definitionService.tapLike(definition);

      // * Assert
      // stateの検証
      verifyInOrder([
        // build()時
        listener.call(null, const AsyncData(null)),
        // tapLike()時もstateは変わらない
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockDefinitionRepository.likeDefinition(definition.id, any),
      ).called(1);

      // 想定外の関数が呼ばれていないか検証
      verifyNever(mockDefinitionRepository.unlikeDefinition(any, any));
    });

    test('いいね解除: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final definitionService = init();
      // いいね解除のため、isLikedByUserがtrueのDefinitionを用意
      final definition = mockDefinition.copyWith(isLikedByUser: true);

      // * Act
      await definitionService.tapLike(definition);

      // * Assert
      // stateの検証
      verifyInOrder([
        // build()時
        listener.call(null, const AsyncData(null)),
        // tapLike()後もstateは変わらない
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockDefinitionRepository.unlikeDefinition(definition.id, any),
      ).called(1);

      // 想定外の関数が呼ばれていないか検証
      verifyNever(mockDefinitionRepository.likeDefinition(any, any));
    });

    // TODO(me): エラー発生時のテストを書く
    // Notifier(SnackBarController)のMock作成がうまく行かないため、テスト時にエラーが発生すると思われる
    // test('エラー発生時の検証', () async {});

    // TODO(me): 以下テストを動作させる
    // 現状は、Notifier(IsLoadingOverlay)のMock作成がうまく行かないため、テスト時にエラーが発生する
    // test('ローディング', () {
    //   // * Arrange
    //   // Mock
    //   final mockIsLoadingOverlayNotifier = MockIsLoadingOverlayNotifier();

    //   final definitionService = init();
    //   container = ProviderContainer(
    //     overrides: [
    //       isLoadingOverlayNotifierProvider
    //           .overrideWith(() => mockIsLoadingOverlayNotifier),
    //     ],
    //   );
    //   final isLoadingOverlayNotifier =
    //       container.read(isLoadingOverlayNotifierProvider.notifier);

    //   // * Act
    //   definitionService.tapLike(mockDefinition);

    //   // * Assert
    //   // 想定通りにisLoadingOverlayNotifierの関数が呼ばれているか検証
    //   verify(isLoadingOverlayNotifier.startLoading()).called(1);
    //   verify(isLoadingOverlayNotifier.finishLoading()).called(1);
    // });

    // TODO(me): definitionProviderが再生成されているか検証するテスト書く
    // providerがinvalidateされたことを検証する方法がわからないため一旦保留
    //
    // test('definitionProviderが再生成されているか検証', () async {});
  });

  // TODO(me): refreshAll()のテスト書く
  // providerがinvalidateされたことを検証する方法がわからないため一旦保留
  //
  // group('refreshAll()', () {});
}
