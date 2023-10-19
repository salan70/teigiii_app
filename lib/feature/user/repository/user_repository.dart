import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_provider.dart';
import 'entity/user_document.dart';

part 'user_repository.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) =>
    UserRepository(
      ref.watch(firestoreProvider),
    );

class UserRepository {
  UserRepository(this.firestore);

  final FirebaseFirestore firestore;

  Future<UserDocument> fetchUser(String userId) async {
    final DocumentSnapshot userSnapshot =
        await firestore.collection('Users').doc(userId).get();

    return UserDocument.fromFirestore(userSnapshot);
  }

  /// 引数で渡したユーザーが、フォローしているユーザーのIDリストを取得
  Future<List<String>> fetchFollowingIdList(String userId) async {
    final QuerySnapshot followingSnapshot = await firestore
        .collection('UserFollows')
        .where('followingId', isEqualTo: userId)
        .get();

    return followingSnapshot.docs
        .map((doc) => doc['followerId'] as String)
        .toList();
  }
}
