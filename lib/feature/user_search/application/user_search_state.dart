import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/user_search_repository.dart';

part 'user_search_state.g.dart';

@riverpod
Future<String?> userIdSearchByPublicId(
  UserIdSearchByPublicIdRef ref,
  String publicId,
) async {
  return ref.read(userSearchRepositoryProvider).searchByPublicId(publicId);
}
