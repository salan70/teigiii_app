import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import 'entity/user_private_word_document.dart';

part 'user_private_word_repository.g.dart';

@Riverpod(keepAlive: true)
UserPrivateWordRepository userPrivateWordRepository(
  UserPrivateWordRepositoryRef ref,
) =>
    UserPrivateWordRepository(
      ref.watch(firestoreProvider),
    );

class UserPrivateWordRepository {
  UserPrivateWordRepository(this.firestore);

  final FirebaseFirestore firestore;

  Future<UserPrivateWordDocument> fetchUserPrivateWord(String userId) async {
    final DocumentSnapshot snapshot =
        await firestore.collection('UserPrivateWords').doc(userId).get();

    return UserPrivateWordDocument.fromFirestore(snapshot);
  }
}
