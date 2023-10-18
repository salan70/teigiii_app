// ignore_for_file: inference_failure_on_collection_literal
// 上記について、本ファイルはテストデータを挿入するためのもので、実際のアプリの挙動には
// 影響しないため、ignoreを設定

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUsersToFirestore(String flavorName) async {
  if (flavorName == 'prod') {
    return;
  }

  final firestore = FirebaseFirestore.instance;

  // 上で定義したusersマップを用いてデータをFirestoreに追加
  for (final userId in users.keys) {
    await firestore.collection('Users').doc(userId).set(users[userId]!);
    await Future<void>.delayed(const Duration(milliseconds: 1000));
  }
}

final users = {
  'user1': {
    'name': '石田スミレ',
    'email': 'sumire.ishida@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/women/1.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user2': {
    'name': 'モンキー・D・ルフィ',
    'email': 'luffy.monkey@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/2.jpg',
    'mutedUserIdList': ['user1'],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user3': {
    'name': 'うずまきナルト',
    'email': 'naruto.uzumaki@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/3.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user4': {
    'name': 'アトム',
    'email': 'atom@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/4.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user5': {
    'name': '黒崎一護',
    'email': 'ichigo.kurosaki@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/5.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user6': {
    'name': '悟空',
    'email': 'goku@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/6.jpg',
    'mutedUserIdList': ['user3'],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user7': {
    'name': 'セーラームーン',
    'email': 'sailormoon@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/women/7.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user8': {
    'name': '江戸川コナン',
    'email': 'conan.edogawa@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/8.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user9': {
    'name': '武藤遊戯',
    'email': 'yugi.muto@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/9.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user10': {
    'name': 'アッシュ・ケッチャム',
    'email': 'ash.ketchum@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/10.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user11': {
    'name': 'サクラ',
    'email': 'sakura@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/women/11.jpg',
    'mutedUserIdList': ['user2'],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user12': {
    'name': 'ゾロ',
    'email': 'zoro@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/12.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user13': {
    'name': 'ブルマ',
    'email': 'bulma@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/women/13.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user14': {
    'name': 'ルパン三世',
    'email': 'lupinIII@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/14.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user15': {
    'name': '八神太一',
    'email': 'taichi.yagami@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/15.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user16': {
    'name': '犬夜叉',
    'email': 'inuyasha@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/16.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user17': {
    'name': 'ハク',
    'email': 'haku@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/17.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user18': {
    'name': '宇宙刑事ギャバン',
    'email': 'gavan@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/18.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user19': {
    'name': 'キラ',
    'email': 'kira@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/19.jpg',
    'mutedUserIdList': ['user11', 'user18'],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user20': {
    'name': 'アスカ',
    'email': 'asuka@example.com',
    'profileImageUrl': 'https://randomuser.me/api/portraits/women/20.jpg',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
};
