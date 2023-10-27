import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUserFollowCountsToFirestore(String flavorName) async {
  if (flavorName == 'prod') {
    return;
  }

  final firestore = FirebaseFirestore.instance;

  for (var i = 1; i <= 20; i++) {
    final userId = 'user$i';
    await firestore.collection('UserFollowCounts').doc(userId).set(
      {
        'followerCount': 0,
        'followingCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }
}
