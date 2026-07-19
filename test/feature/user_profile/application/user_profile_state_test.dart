import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_follow/application/user_follow_state.dart';
import 'package:teigi_app/feature/user_follow/domain/follow_count.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';

import '../../../mock/mock_data.dart';
import 'user_profile_state_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserProfileRepository>()])
class MockUserProfileProviderListener extends Mock
    implements Listener<AsyncValue<UserProfile>> {}

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
  // ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockUserProfileRepository = MockUserProfileRepository();
  const currentUserId = 'currentUserId';

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => currentUserId),
        userProfileRepositoryProvider.overrideWithValue(
          mockUserProfileRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockUserProfileRepository);
  });

  group('userProfile', () {
    test('stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      when(
        mockUserProfileRepository.fetchUserProfile(any),
      ).thenAnswer((_) async => mockUserProfile);

      final listener = MockUserProfileProviderListener();
      container.listen(
        userProfileProvider(mockUserProfile.id),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(userProfileProvider(mockUserProfile.id).future);

      // * Assert
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(null, const AsyncLoading<UserProfile>()),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        listener.call(
          const AsyncLoading<UserProfile>(),
          const AsyncValue.data(mockUserProfile),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserProfileRepository.fetchUserProfile(mockUserProfile.id),
      ).called(1);
    });
  });

  group('isFollowing', () {
    test('userProfileProvider の isFollowedByMe から導出されることを検証', () async {
      // * Arrange
      when(
        mockUserProfileRepository.fetchUserProfile(any),
      ).thenAnswer((_) async => mockUserProfile.copyWith(isFollowedByMe: true));

      const targetUserId = 'targetUserId';

      // * Act
      final isFollowing = await container.read(
        isFollowingProvider(targetUserId).future,
      );

      // * Assert
      expect(isFollowing, true);
      verify(
        mockUserProfileRepository.fetchUserProfile(targetUserId),
      ).called(1);
    });
  });

  group('followCount', () {
    test('userProfileProvider のフォロー数から導出されることを検証', () async {
      // * Arrange
      const targetUserId = 'targetUserId';
      when(mockUserProfileRepository.fetchUserProfile(targetUserId)).thenAnswer(
        (_) async =>
            mockUserProfile.copyWith(followingCount: 5, followerCount: 7),
      );

      // * Act
      final followCount = await container.read(
        followCountProvider(targetUserId).future,
      );

      // * Assert
      expect(
        followCount,
        const FollowCount(
          userId: targetUserId,
          followingCount: 5,
          followerCount: 7,
        ),
      );
      verify(
        mockUserProfileRepository.fetchUserProfile(targetUserId),
      ).called(1);
    });
  });
}
