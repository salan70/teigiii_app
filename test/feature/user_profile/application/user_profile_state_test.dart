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

      final listener = MockUserProfileProviderListener();
      container.listen(
        userProfileProvider(mockUserProfileDoc.id),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

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
        croppedFile: null,
      );
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<UserProfile>(),
        ),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        listener.call(
          const AsyncLoading<UserProfile>(),
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserProfileRepository.fetchUserProfile(mockUserProfileDoc.id),
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
      await container.read(
        followingIdListProvider(targetUserId).future,
      );

      // * Assert
      const expected = mockFollowingIdList;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<List<String>>(),
        ),
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
        mockUserFollowRepository.fetchAllFollowingIdList(
          targetUserId,
        ),
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
      final listener = MockIsFollowingProviderListener();
      container.listen(
        isFollowingProvider(targetUserId),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        isFollowingProvider(targetUserId).future,
      );

      // * Assert
      const expected = mockIsFollowing;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<bool>(),
        ),
        // データがstateに格納されたこと、格納された値が想定通りであることを検証
        listener.call(
          const AsyncLoading<bool>(),
          const AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

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
