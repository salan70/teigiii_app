import 'package:flutter_riverpod/flutter_riverpod.dart';

final appScopeResetControllerProvider = Provider<AppScopeResetController>(
  (ref) => AppScopeResetController(),
);

/// ProviderScope を再生成するためのコールバックを保持する。
///
/// アプリケーション層から Flutter の Widget ツリーへ直接依存しないため、
/// ルート Widget がコールバックを登録して利用する。
class AppScopeResetController {
  void Function()? _onReset;

  void Function()? get onReset => _onReset;

  set onReset(void Function() onReset) {
    _onReset = onReset;
  }

  void reset() {
    _onReset?.call();
  }
}
