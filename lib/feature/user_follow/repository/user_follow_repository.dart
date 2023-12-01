import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../../util/extension/firestore_extension.dart';
import '../../user_profile/domain/user_id_list_state.dart';
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

  /// [currentUserId]が[targetUserId]をフォローする
  Future<void> follow(String currentUserId, String targetUserId) async {
    final batch = firestore.batch()

      // UserFollowsドキュメントを追加
      ..set(
        _userFollowsCollectionRef.doc(),
        {
          UserFollowsCollection.followerId: targetUserId,
          UserFollowsCollection.followingId: currentUserId,
          createdAtFieldName: FieldValue.serverTimestamp(),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )

      // フォローしたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        _userFollowCountsCollectionRef.doc(currentUserId),
        {
          UserFollowCountsCollection.followingCount: FieldValue.increment(1),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )

      // フォローされたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        _userFollowCountsCollectionRef.doc(targetUserId),
        {
          UserFollowCountsCollection.followerCount: FieldValue.increment(1),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      );

    await batch.commit();
  }

  /// [currentUserId]が[targetUserId]のフォローを解除する
  Future<void> unfollow(String currentUserId, String targetUserId) async {
    final batch = firestore.batch()

      // UserFollowsドキュメントを探して削除
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

      // フォロー解除したユーザーのUserFollowCountsドキュメントを更新
      ..update(
        _userFollowCountsCollectionRef.doc(currentUserId),
        {
          UserFollowCountsCollection.followingCount: FieldValue.increment(-1),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      )

      // フォロー解除されたユーザーのUserFollowCountsドキュメントを更新
      ..update(
        _userFollowCountsCollectionRef.doc(targetUserId),
        {
          UserFollowCountsCollection.followerCount: FieldValue.increment(-1),
          updatedAtFieldName: FieldValue.serverTimestamp(),
        },
      );

    await batch.commit();
  }

  /// [currentUserId]が[targetUserId]をフォローしているかどうかを返す
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final snapshot = await _userFollowsCollectionRef
        .where(UserFollowsCollection.followingId, isEqualTo: currentUserId)
        .where(UserFollowsCollection.followerId, isEqualTo: targetUserId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// [userId]がフォローしているユーザーのIDリストを全て取得
  Future<List<String>> fetchAllFollowingIdList(String userId) async {
    final snapshot = await _userFollowsCollectionRef
        .where(UserFollowsCollection.followingId, isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => doc[UserFollowsCollection.followerId] as String)
        .toList();
  }

  /// [userId]がフォローしているユーザーのIDリストを[fetchLimitForUserIdList]件取得
  /// [lastDocument]がnullの場合、最初のdocumentから取得する。
  /// 無限スクロールなどで、2回目以降の取得の場合、
  /// [lastDocument]に前回取得した最後のdocumentを指定すること。
  Future<UserIdListState> fetchFollowingIdList(
    String userId,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    var query = _userFollowsCollectionRef
        .where(UserFollowsCollection.followingId, isEqualTo: userId)
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimitForUserIdList);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    final followerIdList = snapshot.docs
        .map((doc) => doc[UserFollowsCollection.followerId] as String)
        .toList();

    return _toUserIdListState(snapshot, followerIdList);
  }

  /// [userId]をフォローしているユーザーのIDリストを[fetchLimitForUserIdList]件取得
  ///
  /// [lastDocument]がnullの場合、最初のdocumentから取得する。
  /// 無限スクロールなどで、2回目以降の取得の場合、
  /// [lastDocument]に前回取得した最後のdocumentを指定すること。
  Future<UserIdListState> fetchFollowerIdList(
    String userId,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    var query = _userFollowsCollectionRef
        .where(UserFollowsCollection.followerId, isEqualTo: userId)
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimitForUserIdList);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    final followingIdList = snapshot.docs
        .map((doc) => doc[UserFollowsCollection.followingId] as String)
        .toList();

    return _toUserIdListState(snapshot, followingIdList);
  }

  Future<void> deleteUserFollowCount(String userId) async {
    await _userFollowCountsCollectionRef.doc(userId).delete();
  }

  UserIdListState _toUserIdListState(
    QuerySnapshot snapshot,
    List<String> userIdList,
  ) {
    return UserIdListState(
      list: userIdList,
      lastReadQueryDocumentSnapshot: snapshot.docs.lastOrNull,
      hasMore: userIdList.length == fetchLimitForUserIdList,
    );
  }
}
