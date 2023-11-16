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

  /// publicIdからユーザープロフィールを取得する
  ///
  /// 該当するユーザープロフィールが存在しない場合はnullを返す
  Future<UserProfileDocument?> searchUserProfileByPublicId(
    String publicId,
  ) async {
    final querySnapshot = await _userProfilesCollectionRef
        .where(UserProfilesCollection.publicId, isEqualTo: publicId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return UserProfileDocument.fromFirestore(querySnapshot.docs.first);
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
