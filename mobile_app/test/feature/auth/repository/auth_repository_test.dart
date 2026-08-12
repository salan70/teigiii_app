import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/feature/auth/repository/auth_repository.dart';

import 'auth_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<GoogleSignInClient>(),
  MockSpec<GoogleSignInAccount>(),
  MockSpec<GoogleSignInAuthentication>(),
  MockSpec<User>(),
  MockSpec<UserCredential>(),
  MockSpec<UserInfo>(),
])
void main() {
  late MockFirebaseAuth firebaseAuth;
  late MockGoogleSignInClient googleSignInClient;
  late MockGoogleSignInAccount googleAccount;
  late MockGoogleSignInAuthentication googleAuthentication;
  late MockUser user;
  late AuthRepository repository;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    googleSignInClient = MockGoogleSignInClient();
    googleAccount = MockGoogleSignInAccount();
    googleAuthentication = MockGoogleSignInAuthentication();
    user = MockUser();
    repository = AuthRepository(
      firebaseAuth,
      googleSignInClient: googleSignInClient,
    );

    when(
      googleSignInClient.authenticate(),
    ).thenAnswer((_) async => googleAccount);
    when(googleAccount.authentication).thenReturn(googleAuthentication);
    when(googleAuthentication.idToken).thenReturn('id-token');
    when(firebaseAuth.currentUser).thenReturn(user);
  });

  test('Google サインインは取得した ID token で Firebase credential を作る', () async {
    when(
      firebaseAuth.signInWithCredential(any),
    ).thenAnswer((_) async => MockUserCredential());

    await repository.signInWithGoogle();

    final captured =
        verify(firebaseAuth.signInWithCredential(captureAny)).captured.single
            as AuthCredential;
    expect(captured.providerId, 'google.com');
    verify(googleSignInClient.authenticate()).called(1);
  });

  test('Apple 連携は匿名ユーザーの linkWithProvider を使う', () async {
    when(
      user.linkWithProvider(any),
    ).thenAnswer((_) async => MockUserCredential());

    await repository.linkWithApple();

    final captured = verify(user.linkWithProvider(captureAny)).captured.single;
    expect(captured, isA<AppleAuthProvider>());
  });

  test('リンク済み Google アカウントの再認証は Google credential を使う', () async {
    final providerInfo = MockUserInfo();
    when(providerInfo.providerId).thenReturn('google.com');
    when(user.providerData).thenReturn([providerInfo]);
    when(
      user.reauthenticateWithCredential(any),
    ).thenAnswer((_) async => MockUserCredential());

    await repository.reauthenticateWithLinkedProvider();

    final captured =
        verify(user.reauthenticateWithCredential(captureAny)).captured.single
            as AuthCredential;
    expect(captured.providerId, 'google.com');
  });
}
