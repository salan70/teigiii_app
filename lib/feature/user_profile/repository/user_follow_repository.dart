import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import 'entity/user_follow_count_document.dart';

part 'user_follow_repository.g.dart';

@Riverpod(keepAlive: true)
UserFollowRepository userFollowRepository(UserFollowRepositoryRef ref) =>
    UserFollowRepository(
      ref.watch(firestoreProvider),
    );

class UserFollowRepository {
  UserFollowRepository(this.firestore);

  final FirebaseFirestore firestore;

  Future<UserFollowCountDocument> fetchUserFollowCount(String userId) async {
    final DocumentSnapshot snapshot =
        await firestore.collection('UserFollowCounts').doc(userId).get();

    return UserFollowCountDocument.fromFirestore(snapshot);
  }

  /// UserFollowCountドキュメントを追加する
  Future<void> addUserFollowCount(String userId) async {
    await firestore.collection('UserFollowCounts').doc(userId).set({
      'followerCount': 0,
      'followingCount': 0,
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
