import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/app_scope_reset.dart';
import '../domain/auth_provider_type.dart';
import '../repository/account_data_repository.dart';
import '../repository/auth_repository.dart';

part 'account_link_service.g.dart';

typedef ConfirmAccountDiscard = Future<bool> Function(AccountDataSnapshot data);

typedef CredentialFallbackHandler = Future<AuthProviderType?> Function();

@riverpod
AccountLinkService accountLinkService(AccountLinkServiceRef ref) =>
    AccountLinkService(
      authRepository: ref.read(authRepositoryProvider),
      accountDataRepository: ref.read(accountDataRepositoryProvider),
      scopeResetController: ref.read(appScopeResetControllerProvider),
    );

class AccountLinkService {
  AccountLinkService({
    required AuthRepository authRepository,
    required AccountDataRepository accountDataRepository,
    required AppScopeResetController scopeResetController,
  }) : _authRepository = authRepository,
       _accountDataRepository = accountDataRepository,
       _scopeResetController = scopeResetController;

  final AuthRepository _authRepository;
  final AccountDataRepository _accountDataRepository;
  final AppScopeResetController _scopeResetController;

  Future<AccountLinkResult> link(
    AuthProviderType provider, {
    required ConfirmAccountDiscard confirmDiscard,
    CredentialFallbackHandler? onCredentialFallback,
  }) async {
    _ensureNoPendingCleanup();
    try {
      await _linkWithProvider(provider);
      return AccountLinkResult.linked;
    } on FirebaseAuthException catch (exception) {
      if (!_isAccountConflict(exception)) {
        rethrow;
      }

      return _switchAccount(
        confirmDiscard: confirmDiscard,
        signIn: () async {
          if (exception.credential != null) {
            try {
              await _authRepository.signInWithCredential(exception.credential!);
              return true;
            } on FirebaseAuthException {
              // 添付 credential が再利用不可なら、新しい認証を取得する。
            }
          }
          final fallbackProvider = await onCredentialFallback?.call();
          if (fallbackProvider == null) {
            return false;
          }
          await _signInWithProvider(fallbackProvider);
          return true;
        },
      );
    }
  }

  Future<AccountLinkResult> signIn(
    AuthProviderType provider, {
    ConfirmAccountDiscard? confirmDiscard,
  }) => _switchAccount(
    confirmDiscard: confirmDiscard,
    signIn: () async {
      await _signInWithProvider(provider);
      return true;
    },
  );

  bool get hasPendingCleanup => _authRepository.pendingAnonymousCleanup != null;

  void _ensureNoPendingCleanup() {
    if (hasPendingCleanup) {
      throw const AccountCleanupPendingException();
    }
  }

  Future<AccountLinkResult> _switchAccount({
    required Future<bool> Function() signIn,
    ConfirmAccountDiscard? confirmDiscard,
  }) async {
    _ensureNoPendingCleanup();
    var source = await _authRepository.captureAnonymousAccount();
    if (source != null) {
      final data = await _accountDataRepository.fetchCurrentAccountData();
      // 件数がゼロでも、切替に伴う匿名アカウント破棄を明示する。
      if (confirmDiscard == null || !await confirmDiscard(data)) {
        return AccountLinkResult.cancelled;
      }
      if (_authRepository.currentUser?.uid != source.uid) {
        throw StateError('確認中にアカウントが変更されました。');
      }
      final refreshedSource = await _authRepository.captureAnonymousAccount();
      if (refreshedSource?.uid != source.uid) {
        throw StateError('切替元のアカウントを確認できませんでした。');
      }
      source = refreshedSource;
    }
    if (!await signIn()) {
      return AccountLinkResult.cancelled;
    }
    try {
      if (source != null) {
        await _authRepository.deleteCapturedAnonymousAccount(source);
      }
    } on Exception {
      throw const AccountCleanupPendingException();
    } finally {
      // B の認証成功後は、cleanup に失敗しても A のキャッシュを破棄する。
      _scopeResetController.reset();
    }
    return AccountLinkResult.switched;
  }

  Future<void> retryPendingCleanup() async {
    final source = _authRepository.pendingAnonymousCleanup;
    if (source == null) {
      return;
    }
    try {
      await _authRepository.deleteCapturedAnonymousAccount(source);
    } on Exception {
      throw const AccountCleanupPendingException();
    }
    _scopeResetController.reset();
  }

  Future<void> _linkWithProvider(AuthProviderType provider) async {
    switch (provider) {
      case AuthProviderType.apple:
        await _authRepository.linkWithApple();
      case AuthProviderType.google:
        await _authRepository.linkWithGoogle();
    }
  }

  Future<void> _signInWithProvider(AuthProviderType provider) async {
    switch (provider) {
      case AuthProviderType.apple:
        await _authRepository.signInWithApple();
      case AuthProviderType.google:
        await _authRepository.signInWithGoogle();
    }
  }

  bool _isAccountConflict(FirebaseAuthException exception) {
    return exception.code == 'credential-already-in-use' ||
        exception.code == 'account-exists-with-different-credential';
  }
}

enum AccountLinkResult { linked, switched, cancelled }

class AccountCleanupPendingException implements Exception {
  const AccountCleanupPendingException();

  @override
  String toString() =>
      'サインインは完了しましたが、元の匿名アカウントの削除が完了していません。'
      'アプリを閉じず、アカウント連携画面で削除を再試行してください。';
}
