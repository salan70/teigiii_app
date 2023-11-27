import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_profile/application/user_follow_service.dart';
import 'package:teigi_app/feature/user_profile/repository/user_follow_repository.dart';

import 'user_follow_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserFollowRepository>(),
  MockSpec<Listener<AsyncValue<void>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockUserFollowRepository = MockUserFollowRepository();
  final listener = MockListener();
  const currentUserId = 'userId';

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => currentUserId),
        userFollowRepositoryProvider
            .overrideWithValue(mockUserFollowRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockUserFollowRepository);
    reset(listener);
  });

  /// [userFollowServiceProvider]をlistenし、[UserFollowService]を返す
  UserFollowService init() {
    container.listen(
      userFollowServiceProvider,
      listener,
      fireImmediately: true,
    );

    return container.read(
      userFollowServiceProvider.notifier,
    );
  }

  group('follow', () {
    test('いいね登録: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final userFollowService = init();
      const targetUserId = 'targetUser';

      // * Act
      await userFollowService.follow(targetUserId);

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
        mockUserFollowRepository.follow(currentUserId, targetUserId),
      ).called(1);

      // 想定外のrepositoryの関数が呼ばれていないか検証
      verifyNever(
        mockUserFollowRepository.unfollow(any, any),
      );
    });

    // TODO(me): エラー発生時のテスト書く
  });

  group('unfollow', () {
    test('いいね登録: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final userFollowService = init();
      const targetUserId = 'targetUser';

      // * Act
      await userFollowService.unfollow(targetUserId);

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
        mockUserFollowRepository.unfollow(currentUserId, targetUserId),
      ).called(1);

      // 想定外のrepositoryの関数が呼ばれていないか検証
      verifyNever(
        mockUserFollowRepository.follow(any, any),
      );
    });

    // TODO(me): エラー発生時のテスト書く
  });
}
