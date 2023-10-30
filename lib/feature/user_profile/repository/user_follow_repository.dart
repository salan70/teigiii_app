import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/extension/firestore_extension.dart';
import '../domain/user_id_list_state.dart';
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

  /// [currentUserId]が[targetUserId]をフォローする
  Future<void> follow(String currentUserId, String targetUserId) async {
    final batch = firestore.batch()

      // UserFollowsドキュメントを追加
      ..set(
        firestore.collection('UserFollows').doc(),
        {
          'followerId': targetUserId,
          'followingId': currentUserId,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      )

      // フォローしたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        firestore.collection('UserFollowCounts').doc(currentUserId),
        {
          'followingCount': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      )

      // フォローされたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        firestore.collection('UserFollowCounts').doc(targetUserId),
        {
          'followerCount': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

    await batch.commit();
  }

  /// [currentUserId]が[targetUserId]のフォローを解除する
  Future<void> unfollow(String currentUserId, String targetUserId) async {
    final batch = firestore.batch()

      // UserFollowsドキュメントを探して削除
      ..delete(
        await firestore
            .collection('UserFollows')
            .where('followingId', isEqualTo: currentUserId)
            .where('followerId', isEqualTo: targetUserId)
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.first.reference),
      )

      // フォローしたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        firestore.collection('UserFollowCounts').doc(currentUserId),
        {
          'followingCount': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      )

      // フォローされたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        firestore.collection('UserFollowCounts').doc(targetUserId),
        {
          'followerCount': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

    await batch.commit();
  }

  /// [currentUserId]が[targetUserId]をフォローしているかどうかを返す
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final QuerySnapshot snapshot = await firestore
        .collection('UserFollows')
        .where('followingId', isEqualTo: currentUserId)
        .where('followerId', isEqualTo: targetUserId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
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

  /// [userId]がフォローしているユーザーのIDリストを全て取得
  Future<List<String>> fetchAllFollowingIdList(String userId) async {
    final QuerySnapshot snapshot = await firestore
        .collection('UserFollows')
        .where('followingId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => doc['followerId'] as String).toList();
  }

  /// [userId]がフォローしているユーザーのIDリストを[fetchLimitForUserIdList]件取得（初回）
  Future<UserIdListState> fetchFollowingIdListFirst(
    String userId,
  ) async {
    final snapshot = await firestore
        .collection('UserFollows')
        .where('followingId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(fetchLimitForUserIdList)
        .get();

    final followerIdList =
        snapshot.docs.map((doc) => doc['followerId'] as String).toList();

    return _toUserIdListState(snapshot, followerIdList);
  }

  /// [userId]がフォローしているユーザーのIDリストを[fetchLimitForUserIdList]件取得（2回目以降）
  Future<UserIdListState> fetchFollowingIdListMore(
    String userId,
    QueryDocumentSnapshot lastReadQueryDocumentSnapshot,
  ) async {
    final snapshot = await firestore
        .collection('UserFollows')
        .where('followingId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastReadQueryDocumentSnapshot)
        .limit(fetchLimitForUserIdList)
        .get();

    final followerIdList =
        snapshot.docs.map((doc) => doc['followerId'] as String).toList();

    return _toUserIdListState(snapshot, followerIdList);
  }

  /// [userId]をフォローしているユーザーのIDリストを[fetchLimitForUserIdList]件取得（初回）
  Future<UserIdListState> fetchFollowerIdListFirst(
    String userId,
  ) async {
    final snapshot = await firestore
        .collection('UserFollows')
        .where('followerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(fetchLimitForUserIdList)
        .get();

    final followingIdList =
        snapshot.docs.map((doc) => doc['followingId'] as String).toList();

    return _toUserIdListState(snapshot, followingIdList);
  }

  /// [userId]をフォローしているユーザーのIDリストを[fetchLimitForUserIdList]件取得（2回目以降）
  Future<UserIdListState> fetchFollowerIdListMore(
    String userId,
    QueryDocumentSnapshot lastReadQueryDocumentSnapshot,
  ) async {
    final snapshot = await firestore
        .collection('UserFollows')
        .where('followerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastReadQueryDocumentSnapshot)
        .limit(fetchLimitForUserIdList)
        .get();

    final followingIdList =
        snapshot.docs.map((doc) => doc['followingId'] as String).toList();

    return _toUserIdListState(snapshot, followingIdList);
  }

  UserIdListState _toUserIdListState(
    QuerySnapshot snapshot,
    List<String> userIdList,
  ) {
    return UserIdListState(
      userIdList: userIdList,
      lastReadQueryDocumentSnapshot: snapshot.docs.lastOrNull,
      hasMore: userIdList.length == fetchLimitForUserIdList,
    );
  }
}
