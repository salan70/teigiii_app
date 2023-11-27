// ignore_for_file: inference_failure_on_collection_literal
// 上記について、本ファイルはテストデータを挿入するためのもので、実際のアプリの挙動には
// 影響しないため、ignoreを設定

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUserConfigsToFirestore(String flavorName) async {
  if (flavorName == 'prod') {
    return;
  }

  final firestore = FirebaseFirestore.instance;

  // 上で定義したusersマップを用いてデータをFirestoreに追加
  for (final userId in userConfigs.keys) {
    await firestore
        .collection('UserConfigs')
        .doc(userId)
        .set(userConfigs[userId]!);
    await Future<void>.delayed(const Duration(milliseconds: 1000));
  }
}

final userConfigs = {
  'user1': {
    'mutedUserIdList': [],
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user2': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': ['user1'],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user3': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user4': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user5': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user6': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': ['user3'],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user7': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user8': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user9': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user10': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user11': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': ['user2'],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user12': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user13': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user14': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user15': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user16': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user17': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user18': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user19': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': ['user11', 'user18'],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
  'user20': {
    'osVersion': 'iOS 14.4.2',
    'appVersion': '1.0.0',
    'mutedUserIdList': [],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  },
};
