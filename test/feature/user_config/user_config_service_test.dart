import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart';

import 'user_config_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserConfigRepository>(),
  MockSpec<Listener<AsyncValue<void>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockUserConfigRepository = MockUserConfigRepository();
  final listener = MockListener();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => 'userId'),
        userConfigRepositoryProvider
            .overrideWithValue(mockUserConfigRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockUserConfigRepository);
    reset(listener);
  });

  /// userConfigServiceProviderをlistenし、UserConfigServiceを返す
  // UserConfigService init() {
  //   container.listen(
  //     userConfigServiceProvider,
  //     listener,
  //     fireImmediately: true,
  //   );

  //   return container.read(
  //     userConfigServiceProvider.notifier,
  //   );
  // }

  // TODO(me): addMutedUserのテスト書く
  // 他のServiceProvider（Notifier）を読んでるからか、うまくいかないため保留
  // group('addMutedUser', () {
  //   test('stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
  //     // * Arrange
  //     final userConfigService = init();

  //     // * Act
  //     await userConfigService.addMutedUser('targetUserId');

  //     // * Assert
  //     // stateの検証
  //     verifyInOrder([
  //       // build()時
  //       listener.call(null, const AsyncData(null)),
  //       // tapLike()時もstateは変わらない
  //     ]);
  //     // 他にlistenerが発火されないことを検証
  //     verifyNoMoreInteractions(listener);

  //     // 想定通りにrepositoryの関数が呼ばれているか検証

  //     // 想定外の関数が呼ばれていないか検証
  //   });
  // });
}
