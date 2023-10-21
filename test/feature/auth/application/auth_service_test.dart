import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_service.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/auth/repository/auth_repository.dart';
import 'package:teigi_app/feature/auth/util/constant.dart';
import 'package:teigi_app/feature/user/repository/user_profile_repository.dart';
import 'package:teigi_app/feature/user_config/repository/device_info_repository.dart';
import 'package:teigi_app/feature/user_config/repository/package_info_repository.dart';
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart';

import 'auth_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserProfileRepository>(),
  MockSpec<UserConfigRepository>(),
  MockSpec<DeviceInfoRepository>(),
  MockSpec<PackageInfoRepository>(),
  MockSpec<AuthRepository>(),
  MockSpec<Listener<AsyncValue<void>>>(),
])

// ignore: one_member_abstracts, unreachable_from_main
abstract class Listener<T> {
// ignore: unreachable_from_main
  void call(T? previous, T next);
}

void main() {
  final mockUserProfileRepository = MockUserProfileRepository();
  final mockUserConfigRepository = MockUserConfigRepository();
  final mockDeviceInfoRepository = MockDeviceInfoRepository();
  final mockPackageInfoRepository = MockPackageInfoRepository();
  final mockAuthRepository = MockAuthRepository();
  final listener = MockListener();

  late ProviderContainer container;

  const mockUserId = 'userId';

  // ProviderContainerの初期化、authServiceProviderのlistenを設定する
  // このとき、[isSignedInProvider]はfalse（未ログイン状態）であることに注意
  setUp(() {
    container = ProviderContainer(
      overrides: [
        isSignedInProvider.overrideWithValue(false),
        userIdProvider.overrideWithValue(mockUserId),
        userProfileRepositoryProvider
            .overrideWithValue(mockUserProfileRepository),
        userConfigRepositoryProvider
            .overrideWithValue(mockUserConfigRepository),
        deviceInfoRepositoryProvider
            .overrideWithValue(mockDeviceInfoRepository),
        packageInfoRepositoryProvider
            .overrideWithValue(mockPackageInfoRepository),
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
    reset(mockUserProfileRepository);
    reset(mockUserConfigRepository);
    reset(mockDeviceInfoRepository);
    reset(mockPackageInfoRepository);
    reset(mockAuthRepository);
    reset(listener);
  });

  /// containerのoverrideを更新する
  void updateContainersOverride({required bool isSignedIn}) {
    container.updateOverrides([
      isSignedInProvider.overrideWithValue(isSignedIn),
      userIdProvider.overrideWithValue(mockUserId),
      userProfileRepositoryProvider
          .overrideWithValue(mockUserProfileRepository),
      userConfigRepositoryProvider.overrideWithValue(mockUserConfigRepository),
      deviceInfoRepositoryProvider.overrideWithValue(mockDeviceInfoRepository),
      packageInfoRepositoryProvider
          .overrideWithValue(mockPackageInfoRepository),
      authRepositoryProvider.overrideWithValue(mockAuthRepository),
    ]);
  }

  void setupMock(String? osVersion, String appVersion) {
    when(mockDeviceInfoRepository.fetchOsVersion())
        .thenAnswer((_) async => osVersion);
    when(mockPackageInfoRepository.fetchAppVersion())
        .thenAnswer((_) async => appVersion);
  }

  group('onAppLaunch()', () {
    test('未ログイン: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final authService = init();
      const mockOsVersion = 'iOS 14.4';
      const mockAppVersion = '1.0.0';
      setupMock(mockOsVersion, mockAppVersion);

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
      verify(mockPackageInfoRepository.fetchAppVersion()).called(1);
      verify(
        mockUserConfigRepository.addUserConfig(
          mockUserId,
          mockOsVersion,
          mockAppVersion,
        ),
      ).called(1);
      verify(
        mockUserProfileRepository.addUserProfile(
          mockUserId,
          defaultUserName,
        ),
      ).called(1);
    });

    test('ログイン済: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final authService = init();
      const mockOsVersion = 'iOS 14.4';
      const mockAppVersion = '1.0.0';
      setupMock(mockOsVersion, mockAppVersion);
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
      verify(mockPackageInfoRepository.fetchAppVersion()).called(1);
      verify(
        mockUserConfigRepository.updateUserConfig(
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
      const mockAppVersion = '1.0.0';
      setupMock(
        null, // iOSでもAndroidでもないOSを再現
        mockAppVersion,
      );

      // * Act
      await authService.onAppLaunch();

      // * Assert
      verify(
        mockUserConfigRepository.addUserConfig(
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
      const mockAppVersion = '1.0.0';
      setupMock(
        null, // iOSでもAndroidでもないOSを再現
        mockAppVersion,
      );

      // * Act
      await authService.onAppLaunch();

      // * Assert
      verify(
        mockUserConfigRepository.updateUserConfig(
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
      when(mockUserConfigRepository.updateUserConfig(any, any, any))
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
