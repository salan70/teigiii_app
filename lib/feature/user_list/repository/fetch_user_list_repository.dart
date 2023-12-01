import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/config_constant.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../../util/extension/firestore_extension.dart';
import '../../user_list/domain/user_id_list_state.dart';

part 'fetch_user_list_repository.g.dart';

@Riverpod(keepAlive: true)
FetchUserListRepository fetchUserListRepository(
  FetchUserListRepositoryRef ref,
) =>
    FetchUserListRepository(ref.watch(firestoreProvider));

class FetchUserListRepository {
  FetchUserListRepository(this.firestore);

  final FirebaseFirestore firestore;

  /// [userId] がフォローしているユーザーIDリストを
  /// [fetchLimitForUserIdList] 件取得する。
  ///
  /// [lastDocument] がnullの場合、最初のdocumentから取得する。
  Future<UserIdListState> fetchFollowingIdList(
    String userId,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    final snapshot = await firestore
        .collection(UserFollowsCollection.collectionName)
        .where(UserFollowsCollection.followingId, isEqualTo: userId)
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimitForUserIdList)
        .maybeStartAfterDocument(lastDocument)
        .get();

    final followerIdList = snapshot.docs
        .map((doc) => doc[UserFollowsCollection.followerId] as String)
        .toList();

    return _toUserIdListState(snapshot, followerIdList);
  }

  /// [userId] をフォローしているユーザーIDのリストを
  /// [fetchLimitForUserIdList]件取得する。
  ///
  /// [lastDocument] がnullの場合、最初のdocumentから取得する。
  Future<UserIdListState> fetchFollowerIdList(
    String userId,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    final snapshot = await firestore
        .collection(UserFollowsCollection.collectionName)
        .where(UserFollowsCollection.followerId, isEqualTo: userId)
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimitForUserIdList)
        .maybeStartAfterDocument(lastDocument)
        .get();

    final followingIdList = snapshot.docs
        .map((doc) => doc[UserFollowsCollection.followingId] as String)
        .toList();

    return _toUserIdListState(snapshot, followingIdList);
  }

  /// [definitionId] をいいねしたユーザーのIDリストを
  /// [fetchLimitForUserIdList] 件取得する。
  ///
  /// [lastDocument] がnullの場合、最初のdocumentから取得する。
  Future<UserIdListState> fetchLikedUserIdList(
    String definitionId,
    QueryDocumentSnapshot? lastDocument,
  ) async {
    final snapshot = await firestore
        .collection(LikesCollection.collectionName)
        .where(LikesCollection.definitionId, isEqualTo: definitionId)
        .orderBy(createdAtFieldName, descending: true)
        .limit(fetchLimitForUserIdList)
        .maybeStartAfterDocument(lastDocument)
        .get();

    final favoriteUserIdList = snapshot.docs
        .map((doc) => doc[LikesCollection.userId] as String)
        .toList();

    return _toUserIdListState(snapshot, favoriteUserIdList);
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
