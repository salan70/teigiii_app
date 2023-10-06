import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/firebase_provider.dart';
import 'entity/user_document.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) =>
    UserRepository(
      ref.watch(firestoreProvider),
    );

class UserRepository {
  UserRepository(this.firestore);

  final FirebaseFirestore firestore;

  Future<UserDocument> fetchUser(String userId) async {
    final DocumentSnapshot userSnapshot =
        await firestore.collection('Users').doc(userId).get();

    return UserDocument.fromFirestore(userSnapshot);
  }

  Future<List<String>> fetchFollowingIdList(String userId) async {
    final QuerySnapshot followingSnapshot = await firestore
        .collection('UserFollows')
        .where('followerId', isEqualTo: userId)
        .get();

    return followingSnapshot.docs
        .map((doc) => doc['followingId'] as String)
        .toList();
  }
}
