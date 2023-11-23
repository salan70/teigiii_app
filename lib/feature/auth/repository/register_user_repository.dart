import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../user_profile/domain/user_profile.dart';

part 'register_user_repository.g.dart';

@Riverpod(keepAlive: true)
RegisterUserRepository registerUserRepository(RegisterUserRepositoryRef ref) =>
    RegisterUserRepository(ref.watch(firestoreProvider));

class RegisterUserRepository {
  RegisterUserRepository(this.firestore);

  CollectionReference get _userProfilesCollectionRef =>
      firestore.collection(UserProfilesCollection.collectionName);

  CollectionReference get _userConfigsCollectionRef =>
      firestore.collection(UserConfigsCollection.collectionName);

  CollectionReference get _userFollowCountsCollectionRef =>
      firestore.collection(UserFollowCountsCollection.collectionName);

  final FirebaseFirestore firestore;

  /// 初回登録時に必要なユーザー情報を登録する
  Future<void> initUser(
    String userId,
    UserProfile userProfile,
    String osVersion,
    String appVersion,
  ) async {
    final batch = firestore.batch()

      // * UserProfileドキュメント
      ..set(_userProfilesCollectionRef.doc(userId), {
        UserProfilesCollection.publicId: await _generateValidPublicId(),
        ...userProfile.toFirestoreForCreate(),
        createdAtFieldName: FieldValue.serverTimestamp(),
        updatedAtFieldName: FieldValue.serverTimestamp(),
      })

      // * UserConfigドキュメント
      ..set(_userConfigsCollectionRef.doc(userId), {
        UserConfigsCollection.mutedUserIdList: <dynamic>[],
        UserConfigsCollection.osVersion: osVersion,
        UserConfigsCollection.appVersion: appVersion,
        createdAtFieldName: FieldValue.serverTimestamp(),
        updatedAtFieldName: FieldValue.serverTimestamp(),
      })

      // * UserFollowCountドキュメント
      ..set(_userFollowCountsCollectionRef.doc(userId), {
        UserFollowCountsCollection.followerCount: 0,
        UserFollowCountsCollection.followingCount: 0,
        createdAtFieldName: FieldValue.serverTimestamp(),
        updatedAtFieldName: FieldValue.serverTimestamp(),
      });

    await batch.commit();
  }

  /// 有効な（重複がない）publicIdを生成する
  ///
  /// 「publicIdの生成と重複確認」に最大試行回数を設定しており、
  /// 超えた場合は例外を投げる
  Future<String> _generateValidPublicId() async {
    var publicId = UserProfile.generatePublicId();
    var idExists = await _checkPublicIdExists(publicId);

    // ループし続けることを避けるために、最大試行回数を設定
    const maxAttempts = 10;
    var attempts = 0;

    while (idExists && attempts < maxAttempts) {
      publicId = UserProfile.generatePublicId();
      idExists = await _checkPublicIdExists(publicId);
      attempts++;
    }

    if (attempts >= maxAttempts) {
      throw Exception('$maxAttempts回試行しても有効なpublicIdを生成できませんでした。');
    }

    return publicId;
  }

  Future<bool> _checkPublicIdExists(String publicId) async {
    final querySnapshot = await _userProfilesCollectionRef
        .where(UserProfilesCollection.publicId, isEqualTo: publicId)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
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
}
