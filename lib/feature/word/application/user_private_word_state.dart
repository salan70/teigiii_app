import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../repository/user_private_word_repository.dart';

part 'user_private_word_state.g.dart';

@Riverpod(keepAlive: true)
Future<Map<String, Map<String, int>>> userPrivateWordMap(
  UserPrivateWordMapRef ref,
) async {
  final currentUserId = ref.read(userIdProvider)!;
  final userPrivateWordDoc = await ref
      .read(userPrivateWordRepositoryProvider)
      .fetchUserPrivateWord(currentUserId);

  return userPrivateWordDoc.privateWordMap;
}
