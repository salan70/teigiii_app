import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/user_profile/application/user_id_list_state.dart';
import 'package:teigi_app/feature/user_profile/domain/user_id_list_state.dart';
import 'package:teigi_app/feature/user_profile/repository/user_follow_repository.dart';
import 'package:teigi_app/feature/user_profile/util/profile_feed_type.dart';

import '../../mock/mock_data.dart';
import 'user_id_list_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserFollowRepository>(),
  MockSpec<Listener<AsyncValue<UserIdListState>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockUserFollowRepository = MockUserFollowRepository();
  final listener = MockListener();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userFollowRepositoryProvider
            .overrideWithValue(mockUserFollowRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockUserFollowRepository);
  });
  group('build()', () {
    test('following: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      when(
        mockUserFollowRepository.fetchFollowingIdListFirst(
          any,
        ),
      ).thenAnswer(
        (_) async => mockUserIdListState,
      );
      const targetUserId = 'targetUserId';
      container.listen(
        userIdListStateNotifierProvider(UserListType.following, targetUserId),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        userIdListStateNotifierProvider(UserListType.following, targetUserId)
            .future,
      );

      // * Assert
      final expected = mockUserIdListState;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<UserIdListState>(),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          const AsyncLoading<UserIdListState>(),
          // fetchHomeRecommendDefinitionIdListの戻り値がそのまま格納されていることを検証
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserFollowRepository.fetchFollowingIdListFirst(
          targetUserId,
        ),
      ).called(1);
    });

    test('follower: stateの更新、repositoryで定義している関数の呼び出しを検証', () async {
      // * Arrange
      // Mockの設定
      when(
        mockUserFollowRepository.fetchFollowerIdListFirst(
          any,
        ),
      ).thenAnswer(
        (_) async => mockUserIdListState,
      );
      const targetUserId = 'targetUserId';
      container.listen(
        userIdListStateNotifierProvider(UserListType.follower, targetUserId),
        listener,
        fireImmediately: true,
      );
      addTearDown(() => reset(listener));

      // * Act
      await container.read(
        userIdListStateNotifierProvider(UserListType.follower, targetUserId)
            .future,
      );

      // * Assert
      final expected = mockUserIdListState;
      // stateの検証
      verifyInOrder([
        // ローディング状態であることを検証
        listener.call(
          null,
          const AsyncLoading<UserIdListState>(),
        ),
        // データがstateに格納されたことを検証
        listener.call(
          const AsyncLoading<UserIdListState>(),
          // fetchHomeRecommendDefinitionIdListの戻り値がそのまま格納されていることを検証
          AsyncValue.data(expected),
        ),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(
        mockUserFollowRepository.fetchFollowerIdListFirst(
          targetUserId,
        ),
      ).called(1);
    });
  });
}
