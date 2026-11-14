import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/auth/domain/account_cleanup_state.dart';

final accountCleanupStateProvider = Provider<AccountCleanupState>(
  (ref) => AccountCleanupState(),
);
