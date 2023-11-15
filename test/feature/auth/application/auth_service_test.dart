import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_service.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/auth/repository/auth_repository.dart';
import 'package:teigi_app/feature/auth/repository/register_user_repository.dart';
import 'package:teigi_app/feature/auth/util/constant.dart';
import 'package:teigi_app/feature/user_config/application/user_config_state.dart';
import 'package:teigi_app/feature/user_config/repository/device_info_repository.dart';

import 'auth_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RegisterUserRepository>(),
  MockSpec<DeviceInfoRepository>(),
  MockSpec<AuthRepository>(),
  MockSpec<Listener<AsyncValue<void>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockRegisterUserRepository = MockRegisterUserRepository();
  final mockDeviceInfoRepository = MockDeviceInfoRepository();
  final mockAuthRepository = MockAuthRepository();
  final listener = MockListener();

  late ProviderContainer container;

  const mockUserId = 'userId';
  const mockAppVersion = '1.0.0';

  // ProviderContainerの初期化、authServiceProviderのlistenを設定する
  // このとき、[isSignedInProvider]はfalse（未ログイン状態）であることに注意
  setUp(() {
    container = ProviderContainer(
      overrides: [
        isSignedInProvider.overrideWithValue(false),
        userIdProvider.overrideWithValue(mockUserId),
        appVersionProvider.overrideWith((ref) => Future.value(mockAppVersion)),
        registerUserRepositoryProvider
            .overrideWithValue(mockRegisterUserRepository),
        deviceInfoRepositoryProvider
            .overrideWithValue(mockDeviceInfoRepository),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  /// authServiceProviderをlistenし、AuthServiceを返す
  AuthService init() {
    container.listen(
      authServiceProvider,
      listener,
      fireImmediately: true,
    );

    return container.read(
      authServiceProvider.notifier,
    );
  }

  tearDown(() {
    reset(mockRegisterUserRepository);
    reset(mockDeviceInfoRepository);
    reset(mockAuthRepository);
    reset(listener);
  });

  /// containerのoverrideを更新する
  void updateContainersOverride({required bool isSignedIn}) {
    container.updateOverrides([
      isSignedInProvider.overrideWithValue(isSignedIn),
      userIdProvider.overrideWithValue(mockUserId),
      appVersionProvider.overrideWith((ref) => Future.value(mockAppVersion)),
      registerUserRepositoryProvider
          .overrideWithValue(mockRegisterUserRepository),
      deviceInfoRepositoryProvider.overrideWithValue(mockDeviceInfoRepository),
      authRepositoryProvider.overrideWithValue(mockAuthRepository),
    ]);
  }

  void setupMock(String? osVersion) {
    when(mockDeviceInfoRepository.fetchOsVersion())
        .thenAnswer((_) async => osVersion);
  }

  group('onAppLaunch()', () {
    test('未ログイン: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final authService = init();
      const mockOsVersion = 'iOS 14.4';
      const mockAppVersion = '1.0.0';
      setupMock(mockOsVersion);

      // * Act
      await authService.onAppLaunch();

      // * Assert
      // stateの検証
      verifyInOrder([
        listener.call(null, const AsyncLoading()),
        listener.call(const AsyncLoading(), const AsyncData(null)),
        listener.call(const AsyncData(null), const AsyncData(null)),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(mockAuthRepository.signInAnonymously()).called(1);
      verify(mockDeviceInfoRepository.fetchOsVersion()).called(1);
      verify(
        mockRegisterUserRepository.initUser(
          mockUserId,
          mockOsVersion,
          mockAppVersion,
        ),
      ).called(1);
    });

    test('ログイン済: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final authService = init();
      const mockOsVersion = 'iOS 14.4';
      setupMock(mockOsVersion);
      updateContainersOverride(isSignedIn: true);

      // * Act
      await authService.onAppLaunch();

      // * Assert
      // stateの検証
      verifyInOrder([
        listener.call(null, const AsyncLoading()),
        listener.call(const AsyncLoading(), const AsyncData(null)),
        listener.call(const AsyncData(null), const AsyncData(null)),
      ]);
      // 他にlistenerが発火されないことを検証
      verifyNoMoreInteractions(listener);

      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(mockDeviceInfoRepository.fetchOsVersion()).called(1);
      verify(
        mockRegisterUserRepository.updateVersionInfo(
          mockUserId,
          mockOsVersion,
          mockAppVersion,
        ),
      ).called(1);

      // 想定外の関数が呼ばれていないか検証
      verifyNever(mockAuthRepository.signInAnonymously());
    });

    test('未ログイン（OSがiOSでもAndroidでもない場合）: 処理の中で渡される引数が想定通りであることを検証', () async {
      // * Arrange
      final authService = init();
      // iOSでもAndroidでもないOSを再現
      setupMock(null);

      // * Act
      await authService.onAppLaunch();

      // * Assert
      verify(
        mockRegisterUserRepository.initUser(
          any,
          unexpectedOsText, // 検証対象
          any,
        ),
      ).called(1);
    });

    test('ログイン済（OSがiOSでもAndroidでもない場合）: 処理の中で渡される引数が想定通りであることを検証', () async {
      // * Arrange
      final authService = init();
      updateContainersOverride(isSignedIn: true);
      // iOSでもAndroidでもないOSを再現
      setupMock(null);

      // * Act
      await authService.onAppLaunch();

      // * Assert
      verify(
        mockRegisterUserRepository.updateVersionInfo(
          any,
          unexpectedOsText, // 検証対象
          any,
        ),
      ).called(1);
    });

    test('未ログイン（例外発生）: stateにAsyncErrorが入ることを検証', () async {
      // * Arrange
      final authService = init();
      final testException = Exception('signInAnonymously()で例外発生！！！');
      when(mockAuthRepository.signInAnonymously()).thenThrow(testException);

      // * Act
      await authService.onAppLaunch();

      // * Assert
      verifyInOrder([
        listener.call(null, const AsyncLoading()),
        listener.call(const AsyncLoading(), const AsyncData(null)),
        listener.call(
          const AsyncData(null),
          // AsyncErrorが格納されていることを検証
          argThat(
            isA<AsyncError<void>>().having(
              (d) => d.error,
              'error',
              testException,
            ),
          ),
        ),
      ]);
    });

    test('ログイン済み（例外発生）: stateにAsyncErrorが入らないことを検証', () async {
      // * Arrange
      final authService = init();
      updateContainersOverride(isSignedIn: true);
      final testException = Exception('updateUserConfig()で例外発生！！！');
      when(mockRegisterUserRepository.updateVersionInfo(any, any, any))
          .thenThrow(testException);

      // * Act
      await authService.onAppLaunch();

      // * Assert
      verifyInOrder([
        listener.call(null, const AsyncLoading()),
        listener.call(const AsyncLoading(), const AsyncData(null)),
        listener.call(const AsyncData(null), const AsyncData(null)),
      ]);
    });
  });
}
