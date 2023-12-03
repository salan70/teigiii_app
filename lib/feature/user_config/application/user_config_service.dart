import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
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
    final currentUserId = ref.read(userIdProvider)!;

    await ref.read(userConfigRepositoryProvider).appendMutedUserIdList(
          currentUserId,
          targetUserId,
        );

    ref.invalidate(mutedUserIdListProvider);
  }

  /// [targetUserId] のミュートを解除する。
  Future<void> unmuteUser(String targetUserId) async {
    final currentUserId = ref.read(userIdProvider)!;

    await ref.read(userConfigRepositoryProvider).removeMutedUserIdList(
          currentUserId,
          targetUserId,
        );

    ref.invalidate(mutedUserIdListProvider);
  }
}
