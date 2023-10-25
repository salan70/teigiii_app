import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/firebase_providers.dart';
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

  Future<UserConfigDocument> fetchUserConfig(String userId) async {
    final DocumentSnapshot snapshot =
        await firestore.collection('UserConfigs').doc(userId).get();

    return UserConfigDocument.fromFirestore(snapshot);
  }

  Future<void> addUserConfig(
    String userId,
    String osVersion,
    String appVersion,
  ) async {
    await firestore.collection('UserConfigs').doc(userId).set({
      'mutedUserIdList': <dynamic>[],
      'osVersion': osVersion,
      'appVersion': appVersion,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ユーザーが使用しているos, appのバージョン情報を更新する
  Future<void> updateVersionInfo(
    String userId,
    String osVersion,
    String appVersion,
  ) async {
    await firestore.collection('UserConfigs').doc(userId).update({
      'osVersion': osVersion,
      'appVersion': appVersion,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// mutedUserIdとして指定したユーザーIDをmutedUserIdListに追加する
  Future<void> appendMutedUserIdList(
    String userId,
    String mutedUserId,
  ) async {
    await firestore.collection('UserConfigs').doc(userId).update({
      'mutedUserIdList': FieldValue.arrayUnion(<dynamic>[mutedUserId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
