import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
import '../domain/user_profile.dart';
import 'entity/user_profile_document.dart';

part 'user_profile_repository.g.dart';

@Riverpod(keepAlive: true)
UserProfileRepository userProfileRepository(UserProfileRepositoryRef ref) =>
    UserProfileRepository(
      ref.watch(firestoreProvider),
    );

class UserProfileRepository {
  UserProfileRepository(this.firestore);

  CollectionReference get _userProfilesCollectionRef =>
      firestore.collection(UserProfilesCollection.collectionName);

  final FirebaseFirestore firestore;

  Future<UserProfileDocument> fetchUserProfile(String userId) async {
    final snapshot = await _userProfilesCollectionRef.doc(userId).get();

    return UserProfileDocument.fromFirestore(snapshot);
  }

  /// ユーザープロフィールをFirestoreに追加する
  ///
  /// 「publicIdの生成と重複確認」に最大試行回数を設定しており、
  /// 超えた場合は例外を投げる
  Future<void> addUserProfile(String userId) async {
    // publicIdを生成し、既に存在する場合は再生成する
    const maxAttempts = 10;
    var attempts = 0;
    var publicId = UserProfile.generatePublicId();
    var idExists = await _checkPublicIdExists(publicId);

    // ループし続けることを避けるために、最大試行回数を設定
    while (idExists && attempts < maxAttempts) {
      publicId = UserProfile.generatePublicId();
      idExists = await _checkPublicIdExists(publicId);
      attempts++;
    }

    if (attempts >= maxAttempts) {
      throw Exception('$maxAttempts回試行しても有効なpublicIdを生成できませんでした。');
    }

    await _userProfilesCollectionRef.doc(userId).set({
      UserProfilesCollection.publicId: publicId,
      UserProfilesCollection.name: UserProfile.defaultName,
      UserProfilesCollection.bio: UserProfile.defaultBio,
      UserProfilesCollection.profileImageUrl: UserProfile.defaultImageUrl,
      createdAtFieldName: FieldValue.serverTimestamp(),
      updatedAtFieldName: FieldValue.serverTimestamp(),
    });
  }

  Future<bool> _checkPublicIdExists(String publicId) async {
    final querySnapshot = await _userProfilesCollectionRef
        .where(UserProfilesCollection.publicId, isEqualTo: publicId)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> updateUserProfile(
    UserProfile userProfileForWrite,
  ) async {
    await _userProfilesCollectionRef.doc(userProfileForWrite.id).update({
      UserProfilesCollection.name: userProfileForWrite.name,
      UserProfilesCollection.bio: userProfileForWrite.bio,
      UserProfilesCollection.profileImageUrl:
          userProfileForWrite.profileImageUrl,
      updatedAtFieldName: FieldValue.serverTimestamp(),
    });
  }
}
