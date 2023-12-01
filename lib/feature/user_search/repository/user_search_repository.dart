import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
import '../../../util/constant/firestore_collections.dart';
import '../../user_profile/repository/entity/user_profile_document.dart';

part 'user_search_repository.g.dart';

@riverpod
UserSearchRepository userSearchRepository(UserSearchRepositoryRef ref) =>
    UserSearchRepository(
      ref.watch(firestoreProvider),
    );

class UserSearchRepository {
  UserSearchRepository(this.firestore);

  final FirebaseFirestore firestore;

  /// [publicId] からユーザープロフィールを取得する。
  ///
  /// 該当するユーザープロフィールが存在しない場合はnullを返す。
  Future<UserProfileDocument?> searchByPublicId(
    String publicId,
  ) async {
    final querySnapshot = await firestore
        .collection(UserProfilesCollection.collectionName)
        .where(UserProfilesCollection.publicId, isEqualTo: publicId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return UserProfileDocument.fromFirestore(querySnapshot.docs.first);
  }
}
