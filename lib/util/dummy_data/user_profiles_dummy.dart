// ignore_for_file: inference_failure_on_collection_literal
// 上記について、本ファイルはテストデータを挿入するためのもので、実際のアプリの挙動には
// 影響しないため、ignoreを設定

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUserProfilesToFirestore(String flavorName) async {
  if (flavorName == 'prod') {
    return;
  }

  final firestore = FirebaseFirestore.instance;

  // 上で定義したusersマップを用いてデータをFirestoreに追加
  for (final userId in userProfiles.keys) {
    await firestore.collection('UserProfiles').doc(userId).set(userProfiles[userId]!);
    await Future<void>.delayed(const Duration(milliseconds: 1000));
  }
}

final userProfiles = {
  'user1': {
    'name': '石田スミレ',
    'profileImageUrl': 'https://randomuser.me/api/portraits/women/1.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user2': {
    'name': 'モンキー・D・ルフィ',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/2.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user3': {
    'name': 'うずまきナルト',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/3.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user4': {
    'name': 'アトム',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/4.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user5': {
    'name': '黒崎一護',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/5.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user6': {
    'name': '悟空',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/6.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user7': {
    'name': 'セーラームーン',
    'profileImageUrl': 'https://randomuser.me/api/portraits/women/7.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user8': {
    'name': '江戸川コナン',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/8.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user9': {
    'name': '武藤遊戯',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/9.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user10': {
    'name': 'アッシュ・ケッチャム',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/10.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user11': {
    'name': 'サクラ',
    'profileImageUrl': 'https://randomuser.me/api/portraits/women/11.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user12': {
    'name': 'ゾロ',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/12.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user13': {
    'name': 'ブルマ',
    'profileImageUrl': 'https://randomuser.me/api/portraits/women/13.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user14': {
    'name': 'ルパン三世',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/14.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user15': {
    'name': '八神太一',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/15.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user16': {
    'name': '犬夜叉',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/16.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user17': {
    'name': 'ハク',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/17.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user18': {
    'name': '宇宙刑事ギャバン',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/18.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user19': {
    'name': 'キラ',
    'profileImageUrl': 'https://randomuser.me/api/portraits/men/19.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user20': {
    'name': 'アスカ',
    'profileImageUrl': 'https://randomuser.me/api/portraits/women/20.jpg',
    'bio': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
};
