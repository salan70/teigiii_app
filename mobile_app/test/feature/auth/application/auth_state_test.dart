import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/auth/repository/auth_repository.dart';

import 'auth_state_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<User>(),
  MockSpec<UserInfo>(),
])
void main() {
  late MockAuthRepository authRepository;
  late MockUser user;
  late MockUserInfo appleProvider;

  setUp(() {
    authRepository = MockAuthRepository();
    user = MockUser();
    appleProvider = MockUserInfo();
    when(authRepository.userChanges).thenAnswer((_) => const Stream.empty());
    when(authRepository.currentUser).thenReturn(user);
    when(user.isAnonymous).thenReturn(true);
    when(user.providerData).thenReturn([appleProvider]);
    when(appleProvider.providerId).thenReturn('apple.com');
  });

  test('現在のユーザーが匿名かどうかを返す', () {
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
    );
    addTearDown(container.dispose);

    expect(container.read(isAnonymousProvider), isTrue);
  });

  test('firebase 自体を除いた連携済みプロバイダを返す', () {
    final firebaseProvider = MockUserInfo();
    when(firebaseProvider.providerId).thenReturn('firebase');
    when(user.providerData).thenReturn([firebaseProvider, appleProvider]);
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
    );
    addTearDown(container.dispose);

    final providers = container.read(linkedAuthProvidersProvider);

    expect(providers, [appleProvider]);
  });
}
