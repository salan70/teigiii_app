import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/package_info_repository.dart';
import '../repository/user_config_repository.dart';

part 'user_config_state.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> mutedUserIdList(MutedUserIdListRef ref) async {
  return ref.read(userConfigRepositoryProvider).fetchMutedUserIdList();
}

@Riverpod(keepAlive: true)
Future<String> appVersion(AppVersionRef ref) async {
  return ref.read(packageInfoRepositoryProvider).fetchAppVersion();
}
