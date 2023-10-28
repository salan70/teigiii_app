import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';
import 'package:teigi_app/feature/user_profile/repository/user_follow_repository.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';

import '../../../mock/mock_data.dart';
import 'user_profile_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserProfileRepository>(),
  MockSpec<UserFollowRepository>(),
])
class MockUserProfileProviderListener extends Mock
    implements Listener<AsyncValue<UserProfile>> {}

class MockIsFollowingProviderListener extends Mock
    implements Listener<AsyncValue<bool>> {}

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockUserProfileRepository = MockUserProfileRepository();
  final mockUserFollowRepository = MockUserFollowRepository();
  final userProfileProviderListener = MockUserProfileProviderListener();
  final isFollowingProviderListener = MockIsFollowingProviderListener();

  const currentUserId = 'currentUserId';

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => currentUserId),
        userProfileRepositoryProvider
            .overrideWithValue(mockUserProfileRepository),
        userFollowRepositoryProvider
            .overrideWithValue(mockUserFollowRepository),
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
      ).thenAnswer((_) async => mockUserProfileDoc);
      when(
        mockUserFollowRepository.fetchUserFollowCount(any),
      ).thenAnswer((_) async => mockUserFollowCountDoc);

      container.listen(
        userProfileProvider(mockUserProfileDoc.id),
        userProfileProviderListener,
        fireImmediately: true,
      );
      addTearDown(() => reset(userProfileProviderListener));

      // * Act
      await container.read(
        userProfileProvider(mockUserProfileDoc.id).future,
      );

      // * Assert
      final expected = UserProfile(
        id: mockUserProfileDoc.id,
        name: mockUserProfileDoc.name,
        bio: mockUserProfileDoc.bio,
        profileImageUrl: mockUserProfileDoc.profileImageUrl,
        followerCount: mockUserFollowCountDoc.followerCount,
        followingCount: mockUserFollowCountDoc.followingCount,
      );
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        userProfileProviderListener.call(
          null,
          const AsyncLoading<UserProfile>(),
        ),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        userProfileProviderListener.call(
          const AsyncLoading<UserProfile>(),
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(userProfileProviderListener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserProfileRepository.fetchUserProfile(mockUserProfileDoc.id),
      ).called(1);
      verify(
        mockUserFollowRepository.fetchUserFollowCount(mockUserProfileDoc.id),
      ).called(1);
    });
  });

  group('isFollowing', () {
    test('stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      const mockIsFollowing = true;
      when(
        mockUserFollowRepository.isFollowing(any, any),
      ).thenAnswer((_) async => mockIsFollowing);

      const targetUserId = 'targetUserId';
      container.listen(
        isFollowingProvider(targetUserId),
        isFollowingProviderListener,
        fireImmediately: true,
      );
      addTearDown(() => reset(isFollowingProviderListener));

      // * Act
      await container.read(
        isFollowingProvider(targetUserId).future,
      );

      // * Assert
      const expected = mockIsFollowing;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        isFollowingProviderListener.call(
          null,
          const AsyncLoading<bool>(),
        ),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        isFollowingProviderListener.call(
          const AsyncLoading<bool>(),
          const AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(isFollowingProviderListener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserFollowRepository.isFollowing(
          currentUserId,
          targetUserId,
        ),
      ).called(1);
    });
  });
}
