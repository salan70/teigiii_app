import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUserFollowsToFirestore(String flavorName) async {
  if (flavorName == 'prod') {
    return;
  }

  final firestore = FirebaseFirestore.instance;

  // 上で定義したusersマップを用いてデータをFirestoreに追加
  for (final userFollowId in userFollows.keys) {
    final userFollow = userFollows[userFollowId]!;
    await firestore.collection('UserFollows').doc(userFollowId).set({
      ...userFollow,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await Future<void>.delayed(const Duration(milliseconds: 1000));
  }
}

/// user1がuser2〜user20をフォローする
Future<void> addUserFollowsToFirestore2(String flavorName) async {
  if (flavorName == 'prod') {
    return;
  }

  for (var i = 2; i <= 20; i++) {
    final userId = 'user$i';
    await FirebaseFirestore.instance.collection('UserFollows').add(
      {
        'followingId': 'user1',
        'followerId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }
}

/// user1がuser2〜user20にフォローされる
Future<void> addUserFollowsToFirestore3(String flavorName) async {
  if (flavorName == 'prod') {
    return;
  }

  for (var i = 2; i <= 20; i++) {
    final userId = 'user$i';
    await FirebaseFirestore.instance.collection('UserFollows').add(
      {
        'followingId': userId,
        'followerId': 'user1',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }
}

final userFollows = {
  'userFollows1': {
    'followerId': 'user1',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows2': {
    'followerId': 'user2',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows3': {
    'followerId': 'user3',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows4': {
    'followerId': 'user4',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows5': {
    'followerId': 'user5',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows6': {
    'followerId': 'user6',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows7': {
    'followerId': 'user7',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows8': {
    'followerId': 'user8',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows9': {
    'followerId': 'user9',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows10': {
    'followerId': 'user10',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows11': {
    'followerId': 'user11',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows12': {
    'followerId': 'user12',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows13': {
    'followerId': 'user13',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows14': {
    'followerId': 'user14',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows15': {
    'followerId': 'user15',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows16': {
    'followerId': 'user16',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
  'userFollows17': {
    'followerId': 'user17',
    'followingId': 'xE9Je2LljHXIPORKyDnk',
  },
};
