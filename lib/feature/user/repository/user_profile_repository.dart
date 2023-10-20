import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import 'entity/user_profile_document.dart';

part 'user_profile_repository.g.dart';

@Riverpod(keepAlive: true)
UserProfileRepository userProfileRepository(UserProfileRepositoryRef ref) =>
    UserProfileRepository(
      ref.watch(firestoreProvider),
    );

class UserProfileRepository {
  UserProfileRepository(this.firestore);

  final FirebaseFirestore firestore;

  Future<UserProfileDocument> fetchUserProfile(String userId) async {
    final DocumentSnapshot snapshot =
        await firestore.collection('UserProfiles').doc(userId).get();

    return UserProfileDocument.fromFirestore(snapshot);
  }

  Future<void> addUserProfile(String userId, String name) async {
    await firestore.collection('UserProfiles').doc(userId).set({
      'name': name,
      'bio': '',
      'profileImageUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 引数で渡したユーザーが、フォローしているユーザーのIDリストを取得
  Future<List<String>> fetchFollowingIdList(String userId) async {
    final QuerySnapshot snapshot = await firestore
        .collection('UserFollows')
        .where('followingId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => doc['followerId'] as String).toList();
  }
}
