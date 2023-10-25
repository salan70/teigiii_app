import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../repository/user_config_repository.dart';

part 'user_config_state.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> mutedUserIdList(MutedUserIdListRef ref) async {
  final userId = ref.read(userIdProvider)!;
  final userProfileDoc =
      await ref.read(userConfigRepositoryProvider).fetchUserConfig(userId);

  return userProfileDoc.mutedUserIdList;
}
