import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_follow/application/user_follow_state.dart';
import 'package:teigi_app/feature/user_follow/domain/follow_count.dart';
import 'package:teigi_app/feature/user_follow/repository/user_follow_repository.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';

import '../../../mock/mock_data.dart';
import 'user_profile_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserProfileRepository>(),
  MockSpec<UserFollowRepository>(),
])
class MockUserProfileProviderListener extends Mock
    implements Listener<AsyncValue<UserProfile>> {}

class MockFollowingIdListListener extends Mock
    implements Listener<AsyncValue<List<String>>> {}

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
  // ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockUserProfileRepository = MockUserProfileRepository();
  final mockUserFollowRepository = MockUserFollowRepository();

  const currentUserId = 'currentUserId';

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => currentUserId),
        userProfileRepositoryProvider.overrideWithValue(
          mockUserProfileRepository,
        ),
        userFollowRepositoryProvider.overrideWithValue(
          mockUserFollowRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockUserProfileRepository);
    reset(mockUserFollowRepository);
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

  group('followingIdList', () {
    test('stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      const mockFollowingIdList = ['followingId1', 'followingId2'];
      when(
        mockUserFollowRepository.fetchAllFollowingIdList(any),
      ).thenAnswer((_) async => mockFollowingIdList);

      const targetUserId = 'targetUserId';
      final listener = MockFollowingIdListListener();
      container.listen(
        followingIdListProvider(targetUserId),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(followingIdListProvider(targetUserId).future);

      // * Assert
      const expected = mockFollowingIdList;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(null, const AsyncLoading<List<String>>()),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        listener.call(
          const AsyncLoading<List<String>>(),
          const AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserFollowRepository.fetchAllFollowingIdList(targetUserId),
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
      when(mockUserProfileRepository.fetchUserProfile(any)).thenAnswer(
        (_) async =>
            mockUserProfile.copyWith(followingCount: 5, followerCount: 7),
      );

      const targetUserId = 'targetUserId';

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
    });
  });
}
