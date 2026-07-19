import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../definition_list/appication/definition_id_list_state.dart';
import '../../word_list/application/word_list_state_by_initial.dart';
import '../../word_list/application/word_list_state_by_search_word.dart';
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

    _invalidateMuteAwareProviders();
  }

  /// [targetUserId] のミュートを解除する。
  Future<void> unmuteUser(String targetUserId) async {
    await ref
        .read(userConfigRepositoryProvider)
        .removeMutedUserIdList(targetUserId);

    _invalidateMuteAwareProviders();
  }

  void _invalidateMuteAwareProviders() {
    ref
      ..invalidate(mutedUserIdListProvider)
      ..invalidate(definitionIdListStateNotifierProvider)
      ..invalidate(wordListStateByInitialNotifierProvider)
      ..invalidate(wordListStateBySearchWordNotifierProvider);
  }
}
