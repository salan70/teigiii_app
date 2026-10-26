import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/analytics/analytics_event.dart';
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

import '../../../mock/fake_analytics.dart';
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
  late FakeAnalyticsClient fakeAnalytics;

  const mockUserId = 'userId';
  const mockAppVersion = '1.0.0';

  // ProviderContainerの初期化を行う。
  // このとき、isSignedInProvider はfalse（未ログイン状態）であることに注意する。
  setUp(() {
    when(
      mockAuthRepository.prepareAccountDeletion(),
    ).thenAnswer((_) async => mockUserId);
    fakeAnalytics = FakeAnalyticsClient();
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
        ...analyticsTestOverrides(fakeAnalytics),
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
      ...analyticsTestOverrides(fakeAnalytics),
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
      expect(fakeAnalytics.loggedEvents.map((e) => e.name), [
        AnalyticsEvent.userSignedInAnonymously,
        AnalyticsEvent.userRegistered,
      ]);
      expect(fakeAnalytics.userIds, [mockUserId]);
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
      expect(fakeAnalytics.userIds, [mockUserId]);
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

  group('updateUserConfig() の自己修復', () {
    test('404 user_not_found: initUser による再登録が呼ばれることを検証', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      setupMock('iOS 14.4');
      updateContainersOverride(isSignedIn: true);
      when(
        mockRegisterUserRepository.updateVersionInfo(
          osVersion: anyNamed('osVersion'),
          appVersion: anyNamed('appVersion'),
        ),
      ).thenThrow(ApiException(statusCode: 404, code: 'user_not_found'));

      // * Act
      await authService.updateUserConfig();

      // * Assert
      verify(
        mockRegisterUserRepository.initUser(
          name: UserProfile.defaultName,
          osVersion: 'iOS 14.4',
          appVersion: mockAppVersion,
        ),
      ).called(1);
    });

    test('404 だが code が user_not_found でない場合は再登録せず rethrow する', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      setupMock('iOS 14.4');
      updateContainersOverride(isSignedIn: true);
      when(
        mockRegisterUserRepository.updateVersionInfo(
          osVersion: anyNamed('osVersion'),
          appVersion: anyNamed('appVersion'),
        ),
      ).thenThrow(ApiException(statusCode: 404, code: 'other_not_found'));

      // * Act & Assert
      await expectLater(
        authService.updateUserConfig(),
        throwsA(isA<ApiException>()),
      );
      verifyNever(
        mockRegisterUserRepository.initUser(
          name: anyNamed('name'),
          osVersion: anyNamed('osVersion'),
          appVersion: anyNamed('appVersion'),
        ),
      );
    });

    test('500 の場合は再登録せず rethrow する', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      setupMock('iOS 14.4');
      updateContainersOverride(isSignedIn: true);
      when(
        mockRegisterUserRepository.updateVersionInfo(
          osVersion: anyNamed('osVersion'),
          appVersion: anyNamed('appVersion'),
        ),
      ).thenThrow(ApiException(statusCode: 500));

      // * Act & Assert
      await expectLater(
        authService.updateUserConfig(),
        throwsA(isA<ApiException>()),
      );
      verifyNever(
        mockRegisterUserRepository.initUser(
          name: anyNamed('name'),
          osVersion: anyNamed('osVersion'),
          appVersion: anyNamed('appVersion'),
        ),
      );
    });

    test('再登録（自己修復）自体が失敗した場合はそのエラーを rethrow する', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      setupMock('iOS 14.4');
      updateContainersOverride(isSignedIn: true);
      when(
        mockRegisterUserRepository.updateVersionInfo(
          osVersion: anyNamed('osVersion'),
          appVersion: anyNamed('appVersion'),
        ),
      ).thenThrow(ApiException(statusCode: 404, code: 'user_not_found'));
      when(
        mockRegisterUserRepository.initUser(
          name: anyNamed('name'),
          osVersion: anyNamed('osVersion'),
          appVersion: anyNamed('appVersion'),
        ),
      ).thenThrow(ApiException(statusCode: 409, code: 'user_already_exists'));

      // * Act & Assert
      await expectLater(
        authService.updateUserConfig(),
        throwsA(isA<ApiException>()),
      );
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
    test('サーバー成功後の Firebase 削除失敗は同じ UID で残りだけ再試行する', () async {
      final service = container.read(authServiceProvider);
      when(
        mockAuthRepository.deletePreparedUser(mockUserId),
      ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
      await expectLater(
        service.deleteUser(),
        throwsA(isA<FirebaseAuthException>()),
      );
      verify(mockAuthRepository.serverDeletedUserId = mockUserId).called(1);
      when(mockAuthRepository.serverDeletedUserId).thenReturn(mockUserId);
      when(
        mockAuthRepository.deletePreparedUser(mockUserId),
      ).thenAnswer((_) async {});
      await service.deleteUser();
      verify(mockRegisterUserRepository.deleteUser()).called(1);
      verify(mockAuthRepository.prepareAccountDeletion()).called(1);
      verify(mockAuthRepository.deletePreparedUser(mockUserId)).called(2);
    });
    test('再認証 → サーバー削除 → 同じ UID の Firebase 削除の順で処理する', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      updateContainersOverride(isSignedIn: true);

      // * Act
      await authService.deleteUser();

      // * Assert
      verifyInOrder([
        mockAuthRepository.prepareAccountDeletion(),
        mockRegisterUserRepository.deleteUser(),
        mockAuthRepository.deletePreparedUser(mockUserId),
      ]);
      expect(fakeAnalytics.loggedEvents.map((e) => e.name), [
        AnalyticsEvent.accountDeleted,
      ]);
      expect(fakeAnalytics.userIds, [null]);
    });

    test('サーバー削除の 404 は削除成功と扱わない', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      updateContainersOverride(isSignedIn: true);
      when(
        mockRegisterUserRepository.deleteUser(),
      ).thenThrow(ApiException(statusCode: 404));

      // * Act
      await expectLater(authService.deleteUser(), throwsA(isA<ApiException>()));

      // * Assert
      verifyNever(mockAuthRepository.deletePreparedUser(any));
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
      verifyNever(mockAuthRepository.deletePreparedUser(any));
    });

    test('再認証失敗の場合はサーバーを削除しない', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      updateContainersOverride(isSignedIn: true);
      when(
        mockAuthRepository.prepareAccountDeletion(),
      ).thenThrow(FirebaseAuthException(code: 'web-context-cancelled'));

      // * Act
      await expectLater(
        authService.deleteUser(),
        throwsA(isA<FirebaseAuthException>()),
      );

      // * Assert
      verifyNever(mockRegisterUserRepository.deleteUser());
      verifyNever(mockAuthRepository.deletePreparedUser(any));
    });

    test('サーバー 401 requires_recent_login は Firebase 削除せず利用者に返す', () async {
      // * Arrange
      final authService = container.read(authServiceProvider);
      updateContainersOverride(isSignedIn: true);
      when(
        mockRegisterUserRepository.deleteUser(),
      ).thenThrow(ApiException(statusCode: 401, code: 'requires_recent_login'));

      // * Act
      await expectLater(authService.deleteUser(), throwsA(isA<ApiException>()));

      // * Assert
      verify(mockRegisterUserRepository.deleteUser()).called(1);
      verifyNever(mockAuthRepository.deletePreparedUser(any));
    });
  });
}
