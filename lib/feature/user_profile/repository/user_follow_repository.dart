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

  /// [followingId]が[followerId]をフォローする
  Future<void> follow(String followingId, String followerId) async {
    final batch = firestore.batch()

      // UserFollowsドキュメントを追加
      ..set(
        firestore.collection('UserFollows').doc(),
        {
          'followerId': followerId,
          'followingId': followingId,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      )

      // フォローしたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        firestore.collection('UserFollowCounts').doc(followingId),
        {
          'followingCount': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      )

      // フォローされたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        firestore.collection('UserFollowCounts').doc(followerId),
        {
          'followerCount': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

    await batch.commit();
  }

  /// [followingId]が[followerId]のフォローを解除する
  Future<void> unfollow(String followingId, String followerId) async {
    final batch = firestore.batch()

      // UserFollowsドキュメントを探して削除
      ..delete(
        await firestore
            .collection('UserFollows')
            .where('followingId', isEqualTo: followingId)
            .where('followerId', isEqualTo: followerId)
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.first.reference),
      )

      // フォローしたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        firestore.collection('UserFollowCounts').doc(followingId),
        {
          'followingCount': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      )

      // フォローされたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        firestore.collection('UserFollowCounts').doc(followerId),
        {
          'followerCount': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

    await batch.commit();
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
