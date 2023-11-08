import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
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

  CollectionReference get _userConfigsCollectionRef =>
      firestore.collection(UserConfigsCollection.collectionName);

  Future<UserConfigDocument> fetchUserConfig(String userId) async {
    final snapshot = await _userConfigsCollectionRef.doc(userId).get();

    return UserConfigDocument.fromFirestore(snapshot);
  }

  Future<void> addUserConfig(
    String userId,
    String osVersion,
    String appVersion,
  ) async {
    await _userConfigsCollectionRef.doc(userId).set({
      UserConfigsCollection.mutedUserIdList: <dynamic>[],
      UserConfigsCollection.osVersion: osVersion,
      UserConfigsCollection.appVersion: appVersion,
      createdAtFieldName: FieldValue.serverTimestamp(),
      updatedAtFieldName: FieldValue.serverTimestamp(),
    });
  }

  /// ユーザーが使用しているos, appのバージョン情報を更新する
  Future<void> updateVersionInfo(
    String userId,
    String osVersion,
    String appVersion,
  ) async {
    await _userConfigsCollectionRef.doc(userId).update({
      UserConfigsCollection.osVersion: osVersion,
      UserConfigsCollection.appVersion: appVersion,
      updatedAtFieldName: FieldValue.serverTimestamp(),
    });
  }

  /// [mutedUserId]をmutedUserIdListに追加する
  Future<void> appendMutedUserIdList(
    String userId,
    String mutedUserId,
  ) async {
    await _userConfigsCollectionRef.doc(userId).update({
      UserConfigsCollection.mutedUserIdList:
          FieldValue.arrayUnion(<dynamic>[mutedUserId]),
      updatedAtFieldName: FieldValue.serverTimestamp(),
    });
  }

  /// [mutedUserId]をmutedUserIdListから削除する
  Future<void> removeMutedUserIdList(
    String userId,
    String mutedUserId,
  ) async {
    await _userConfigsCollectionRef.doc(userId).update({
      UserConfigsCollection.mutedUserIdList:
          FieldValue.arrayRemove(<dynamic>[mutedUserId]),
      updatedAtFieldName: FieldValue.serverTimestamp(),
    });
  }
}
