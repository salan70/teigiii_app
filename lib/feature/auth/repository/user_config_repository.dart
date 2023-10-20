import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import 'entity/user_config_document.dart';

part 'user_config_repository.g.dart';

@Riverpod(keepAlive: true)
UserConfigRepository userConfigRepository(UserConfigRepositoryRef ref) =>
    UserConfigRepository(
      ref.watch(firestoreProvider),
    );

class UserConfigRepository {
  UserConfigRepository(this.firestore);

  final FirebaseFirestore firestore;

  Future<UserConfigDocument> fetchUserConfig(String userId) async {
    final DocumentSnapshot snapshot =
        await firestore.collection('UserConfigs').doc(userId).get();

    return UserConfigDocument.fromFirestore(snapshot);
  }
}
