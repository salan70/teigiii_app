import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/core/common_provider/flavor_state.dart';
import 'package:teigi_app/feature/auth/application/auth_service.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/auth/repository/auth_repository.dart';
import 'package:teigi_app/feature/auth/repository/register_user_repository.dart';
import 'package:teigi_app/feature/auth/util/constant.dart';
import 'package:teigi_app/feature/user_config/application/user_config_state.dart';
import 'package:teigi_app/feature/user_config/repository/device_info_repository.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';

import 'auth_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RegisterUserRepository>(),
  MockSpec<DeviceInfoRepository>(),
  MockSpec<AuthRepository>(),
])
void main() {
  final mockRegisterUserRepository = MockRegisterUserRepository();
  final mockDeviceInfoRepository = MockDeviceInfoRepository();
  final mockAuthRepository = MockAuthRepository();

  late ProviderContainer container;

  const mockUserId = 'userId';
  const mockAppVersion = '1.0.0';

  // ProviderContainerの初期化を行う。
  // このとき、isSignedInProvider はfalse（未ログイン状態）であることに注意する。
  setUp(() {
    container = ProviderContainer(
      overrides: [
        flavorProvider.overrideWithValue(Flavor.dev),
        isSignedInProvider.overrideWithValue(false),
        userIdProvider.overrideWithValue(mockUserId),
        appVersionProvider.overrideWith((ref) => Future.value(mockAppVersion)),
        registerUserRepositoryProvider.overrideWithValue(
          mockRegisterUserRepository,
        ),
        deviceInfoRepositoryProvider.overrideWithValue(
          mockDeviceInfoRepository,
        ),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() {
    reset(mockRegisterUserRepository);
    reset(mockDeviceInfoRepository);
    reset(mockAuthRepository);
  });

  /// container を 更新（ override ）する。
  void updateContainersOverride({required bool isSignedIn}) {
    container.updateOverrides([
      flavorProvider.overrideWithValue(Flavor.dev),
      isSignedInProvider.overrideWithValue(isSignedIn),
      userIdProvider.overrideWithValue(mockUserId),
      appVersionProvider.overrideWith((ref) => Future.value(mockAppVersion)),
      registerUserRepositoryProvider.overrideWithValue(
        mockRegisterUserRepository,
      ),
      deviceInfoRepositoryProvider.overrideWithValue(mockDeviceInfoRepository),
      authRepositoryProvider.overrideWithValue(mockAuthRepository),
    ]);
  }

  void setupMock(String? osVersion) {
    when(
      mockDeviceInfoRepository.fetchOsVersion(),
    ).thenAnswer((_) async => osVersion);
  }

  group('onAppLaunch()', () {
    test('未ログイン: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      const mockOsVersion = 'iOS 14.4';
      const mockAppVersion = '1.0.0';
      setupMock(mockOsVersion);

      // * Act
      await authService.signIn();

      // * Assert
      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(mockAuthRepository.signInAnonymously()).called(1);
      verify(mockDeviceInfoRepository.fetchOsVersion()).called(1);
      verify(
        mockRegisterUserRepository.initUser(
          name: UserProfile.defaultName,
          osVersion: mockOsVersion,
          appVersion: mockAppVersion,
        ),
      ).called(1);
    });

    test('ログイン済: stateと、想定通りにrepositoryの関数が呼ばれることを検証', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      const mockOsVersion = 'iOS 14.4';
      setupMock(mockOsVersion);
      updateContainersOverride(isSignedIn: true);

      // * Act
      await authService.updateUserConfig();

      // * Assert
      // 想定通りにrepositoryの関数が呼ばれているか検証
      verify(mockDeviceInfoRepository.fetchOsVersion()).called(1);
      verify(
        mockRegisterUserRepository.updateVersionInfo(
          osVersion: mockOsVersion,
          appVersion: mockAppVersion,
        ),
      ).called(1);

      // 想定外の関数が呼ばれていないか検証
      verifyNever(mockAuthRepository.signInAnonymously());
    });

    test('未ログイン（OSがiOSでもAndroidでもない場合）: 処理の中で渡される引数が想定通りであることを検証', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      // iOSでもAndroidでもないOSを再現
      setupMock(null);

      // * Act
      await authService.signIn();

      // * Assert
      verify(
        mockRegisterUserRepository.initUser(
          name: anyNamed('name'),
          osVersion: unexpectedOsText, // 検証対象
          appVersion: anyNamed('appVersion'),
        ),
      ).called(1);
    });

    test('ログイン済（OSがiOSでもAndroidでもない場合）: 処理の中で渡される引数が想定通りであることを検証', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      updateContainersOverride(isSignedIn: true);
      // iOSでもAndroidでもないOSを再現
      setupMock(null);

      // * Act
      await authService.updateUserConfig();

      // * Assert
      verify(
        mockRegisterUserRepository.updateVersionInfo(
          osVersion: unexpectedOsText, // 検証対象
          appVersion: anyNamed('appVersion'),
        ),
      ).called(1);
    });
  });

  group('signIn() 失敗時のクリーンアップ', () {
    test(
      'initUser 失敗時: サーバーユーザー削除 → Firebase Auth 削除の順で呼ばれ rethrow する',
      () async {
        // * Arrange
        final authService = container.read(authServiceProvider);
        setupMock('iOS 14.4');
        when(
          mockRegisterUserRepository.initUser(
            name: anyNamed('name'),
            osVersion: anyNamed('osVersion'),
            appVersion: anyNamed('appVersion'),
          ),
        ).thenThrow(ApiException(statusCode: 500));

        // * Act & Assert
        await expectLater(authService.signIn(), throwsA(isA<ApiException>()));

        // Firebase Auth だけでなくサーバーユーザーもベストエフォート削除される
        verifyInOrder([
          mockRegisterUserRepository.deleteUser(),
          mockAuthRepository.deleteUser(),
        ]);
      },
    );

    test('サーバーユーザー削除も失敗した場合でも Firebase Auth 削除まで到達し rethrow する', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      setupMock('iOS 14.4');
      when(
        mockRegisterUserRepository.initUser(
          name: anyNamed('name'),
          osVersion: anyNamed('osVersion'),
          appVersion: anyNamed('appVersion'),
        ),
      ).thenThrow(ApiException(statusCode: 500));
      when(
        mockRegisterUserRepository.deleteUser(),
      ).thenThrow(ApiException(statusCode: 404));

      // * Act & Assert
      await expectLater(authService.signIn(), throwsA(isA<ApiException>()));

      // サーバー削除が失敗しても Firebase Auth 削除は実行される
      verify(mockAuthRepository.deleteUser()).called(1);
    });
  });

  group('deleteUser()', () {
    test(
      'DELETE /v1/users/me → Firebase Auth deleteUser の順で呼ばれることを検証',
      () async {
        // * Arrange
        final authService = container.read(authServiceProvider);
        updateContainersOverride(isSignedIn: true);

        // * Act
        await authService.deleteUser();

        // * Assert
        verifyInOrder([
          mockRegisterUserRepository.deleteUser(),
          mockAuthRepository.deleteUser(),
        ]);
      },
    );

    test('サーバー削除が 404（削除済み）でも Firebase Auth 削除へ進む', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      updateContainersOverride(isSignedIn: true);
      when(
        mockRegisterUserRepository.deleteUser(),
      ).thenThrow(ApiException(statusCode: 404));

      // * Act
      await authService.deleteUser();

      // * Assert
      verify(mockAuthRepository.deleteUser()).called(1);
    });

    test('サーバー削除が 500 の場合は rethrow し Firebase Auth 削除しない', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      updateContainersOverride(isSignedIn: true);
      when(
        mockRegisterUserRepository.deleteUser(),
      ).thenThrow(ApiException(statusCode: 500));

      // * Act & Assert
      await expectLater(authService.deleteUser(), throwsA(isA<ApiException>()));
      verifyNever(mockAuthRepository.deleteUser());
    });
  });
}
