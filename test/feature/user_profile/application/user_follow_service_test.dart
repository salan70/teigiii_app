import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_follow/application/user_follow_service.dart';
import 'package:teigi_app/feature/user_follow/repository/user_follow_repository.dart';

import 'user_follow_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserFollowRepository>(),
])

void main() {
  final mockUserFollowRepository = MockUserFollowRepository();
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
      verify(
        mockUserFollowRepository.follow(currentUserId, targetUserId),
      ).called(1);

      // 想定外のrepositoryの関数が呼ばれていないか検証
      verifyNever(
        mockUserFollowRepository.unfollow(any, any),
      );
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
      verify(
        mockUserFollowRepository.unfollow(currentUserId, targetUserId),
      ).called(1);

      // 想定外のrepositoryの関数が呼ばれていないか検証
      verifyNever(
        mockUserFollowRepository.follow(any, any),
      );
    });
  });
}
