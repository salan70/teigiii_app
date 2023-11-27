import 'package:cloud_firestore/cloud_firestore.dart';

import '../constant/firestore_collections.dart';

Future<void> addLikesToFirestore(String flavorName) async {
  if (flavorName == 'prod') {
    return;
  }

  final firestore = FirebaseFirestore.instance;

  // 上で定義したusersマップを用いてデータをFirestoreに追加
  for (var i = 1; i <= 20; i++) {
    await firestore.collection(LikesCollection.collectionName).add({
      LikesCollection.definitionId: 'OnEjul4BHX5YtTCXFbHq',
      LikesCollection.userId: 'user$i',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await Future<void>.delayed(const Duration(milliseconds: 1000));
  }
}
