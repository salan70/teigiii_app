import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
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

  CollectionReference get _userFollowsCollectionRef =>
      firestore.collection(UserFollowsCollection.collectionName);

  CollectionReference get _userFollowCountsCollectionRef =>
      firestore.collection(UserFollowCountsCollection.collectionName);

  Future<UserFollowCountDocument> fetchUserFollowCount(String userId) async {
    final snapshot = await _userFollowCountsCollectionRef.doc(userId).get();

    return UserFollowCountDocument.fromFirestore(snapshot);
  }

  /// [currentUserId] が [targetUserId] をフォローする。
  Future<void> follow(String currentUserId, String targetUserId) async {
    final batch = firestore.batch()

      // UserFollows ドキュメントを追加する。
      ..set(
        _userFollowsCollectionRef.doc(),
        {
          UserFollowsCollection.followerId: targetUserId,
          UserFollowsCollection.followingId: currentUserId,
          createdAtFieldName: FieldValue.serverTimestamp(),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )

      // フォローしたユーザーの UserFollowCounts ドキュメントを更新する。
      ..update(
        _userFollowCountsCollectionRef.doc(currentUserId),
        {
          UserFollowCountsCollection.followingCount: FieldValue.increment(1),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )

      // フォローされたユーザーの UserFollowCounts ドキュメントを更新する。
      ..update(
        _userFollowCountsCollectionRef.doc(targetUserId),
        {
          UserFollowCountsCollection.followerCount: FieldValue.increment(1),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      );

    await batch.commit();
  }

  /// [currentUserId] が [targetUserId] のフォローを解除する。
  Future<void> unfollow(String currentUserId, String targetUserId) async {
    final batch = firestore.batch()

      // UserFollowsドキュメントを探して削除する。
      ..delete(
        await _userFollowsCollectionRef
            .where(
              UserFollowsCollection.followingId,
              isEqualTo: currentUserId,
            )
            .where(
              UserFollowsCollection.followerId,
              isEqualTo: targetUserId,
            )
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.first.reference),
      )

      // フォロー解除したユーザーのUserFollowCountsドキュメントを更新する。
      ..update(
        _userFollowCountsCollectionRef.doc(currentUserId),
        {
          UserFollowCountsCollection.followingCount: FieldValue.increment(-1),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )

      // フォロー解除されたユーザーのUserFollowCountsドキュメントを更新する。
      ..update(
        _userFollowCountsCollectionRef.doc(targetUserId),
        {
          UserFollowCountsCollection.followerCount: FieldValue.increment(-1),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      );

    await batch.commit();
  }

  /// [currentUserId] が [targetUserId] をフォローしているかどうかを返す。
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final snapshot = await _userFollowsCollectionRef
        .where(UserFollowsCollection.followingId, isEqualTo: currentUserId)
        .where(UserFollowsCollection.followerId, isEqualTo: targetUserId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// [userId] がフォローしているユーザーのIDリストを全て取得する。
  Future<List<String>> fetchAllFollowingIdList(String userId) async {
    final snapshot = await _userFollowsCollectionRef
        .where(UserFollowsCollection.followingId, isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => doc[UserFollowsCollection.followerId] as String)
        .toList();
  }

  Future<void> deleteUserFollowCount(String userId) async {
    await _userFollowCountsCollectionRef.doc(userId).delete();
  }
}
