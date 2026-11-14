/// AppRoot が所有する、削除の再試行に必要なメモリ内状態。
/// Ref、クライアント、コンテナは保持せず、トークンを永続化しない。
class AccountCleanupState {
  String? serverDeletedUserId;
  CapturedAnonymousAccount? pendingAnonymousCleanup;
}

class CapturedAnonymousAccount {
  CapturedAnonymousAccount({required this.uid, required this.idToken});

  final String uid;
  final String idToken;
  bool serverDeleted = false;
}
