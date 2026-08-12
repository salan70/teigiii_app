import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/app_scope_reset.dart';
import '../../../util/logger.dart';
import '../domain/auth_provider_type.dart';
import '../repository/account_data_repository.dart';
import '../repository/auth_repository.dart';
import 'auth_service.dart';

part 'account_link_service.g.dart';

typedef ConfirmAccountDiscard = Future<bool> Function(AccountDataSnapshot data);

typedef CredentialFallbackHandler = Future<AuthProviderType?> Function();

@riverpod
AccountLinkService accountLinkService(AccountLinkServiceRef ref) =>
    AccountLinkService(
      authRepository: ref.read(authRepositoryProvider),
      authService: ref.read(authServiceProvider),
      accountDataRepository: ref.read(accountDataRepositoryProvider),
      scopeResetController: ref.read(appScopeResetControllerProvider),
    );

class AccountLinkService {
  AccountLinkService({
    required AuthRepository authRepository,
    required AuthService authService,
    required AccountDataRepository accountDataRepository,
    required AppScopeResetController scopeResetController,
  }) : _authRepository = authRepository,
       _authService = authService,
       _accountDataRepository = accountDataRepository,
       _scopeResetController = scopeResetController;

  final AuthRepository _authRepository;
  final AuthService _authService;
  final AccountDataRepository _accountDataRepository;
  final AppScopeResetController _scopeResetController;

  Future<AccountLinkResult> link(
    AuthProviderType provider, {
    required ConfirmAccountDiscard confirmDiscard,
    CredentialFallbackHandler? onCredentialFallback,
  }) async {
    try {
      await _linkWithProvider(provider);
      return AccountLinkResult.linked;
    } on FirebaseAuthException catch (exception) {
      if (!_isAccountConflict(exception) || exception.credential == null) {
        rethrow;
      }

      final currentData = await _accountDataRepository
          .fetchCurrentAccountData();
      if (currentData.hasData && !await confirmDiscard(currentData)) {
        return AccountLinkResult.cancelled;
      }

      await _authService.deleteUserForAccountSwitch();

      try {
        await _authRepository.signInWithCredential(exception.credential!);
      } on Exception catch (error, stackTrace) {
        logger.w(
          '添付 credential によるアカウント切り替えに失敗しました。'
          ' フルサインインへフォールバックします。'
          ' error:$error, stackTrace:$stackTrace',
        );
        final fallbackProvider = await onCredentialFallback?.call() ?? provider;
        await _signInWithProvider(fallbackProvider);
      }

      _scopeResetController.reset();
      return AccountLinkResult.switched;
    }
  }

  Future<void> signIn(AuthProviderType provider) async {
    await _signInWithProvider(provider);
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
