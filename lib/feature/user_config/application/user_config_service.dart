import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/user_config_repository.dart';
import 'user_config_state.dart';

part 'user_config_service.g.dart';

@riverpod
UserConfigService userConfigService(UserConfigServiceRef ref) =>
    UserConfigService(ref);

class UserConfigService {
  UserConfigService(this.ref);

  final Ref ref;

  /// [targetUserId] をミュートする。
  Future<void> muteUser(String targetUserId) async {
    await ref
        .read(userConfigRepositoryProvider)
        .appendMutedUserIdList(targetUserId);

    ref.invalidate(mutedUserIdListProvider);
  }

  /// [targetUserId] のミュートを解除する。
  Future<void> unmuteUser(String targetUserId) async {
    await ref
        .read(userConfigRepositoryProvider)
        .removeMutedUserIdList(targetUserId);

    ref.invalidate(mutedUserIdListProvider);
  }
}
