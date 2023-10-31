import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addWordsDummy0to29(String flavorName) async {
  // 語句リスト
  final words = <String>[
    '愛情',
    '夢想',
    '希望的観測',
    '自由自在',
    '平和主義',
    '絆創膏',
    '時間',
    '青空',
    '光沢',
    '影響',
    '風邪',
    '雲の上',
    '波立つ',
    '炎上',
    '星空',
    '花束',
    '心情',
    '歌声',
    '舞踏会',
    '魂胆',
    '夢中',
    '響き渡る',
    '笑顔',
    '涙目',
    '勇気凜凜',
    '力作',
    '瞬時',
    '奇跡的',
    '冒険心',
    '未来永劫',
  ];

  // 各単語のひらがなリスト
  final readings = <String>[
    'あいじょう',
    'むそう',
    'きぼうてきかんそく',
    'じゆうじざい',
    'へいわしゅぎ',
    'きずそうこう',
    'じかん',
    'あおぞら',
    'こうたく',
    'えいきょう',
    'かぜ',
    'くものうえ',
    'なみたつ',
    'えんじょう',
    'ほしぞら',
    'はなたば',
    'しんじょう',
    'うたごえ',
    'ぶとうかい',
    'こんたん',
    'むちゅう',
    'ひびきわたる',
    'えがお',
    'なみだめ',
    'ゆうきりんりん',
    'りきさく',
    'しゅんじ',
    'きせきてき',
    'ぼうけんしん',
    'みらいえいごう',
  ];

  // publicDefinitionCountのダミーデータ
  final publicDefinitionCounts = <int>[
    5,
    4,
    7,
    6,
    3,
    4,
    5,
    6,
    2,
    7,
    8,
    3,
    4,
    5,
    6,
    7,
    5,
    6,
    7,
    4,
    3,
    6,
    5,
    7,
    3,
    5,
    6,
    7,
    8,
    2,
  ];
  await _addWordsDummyToFirestore(flavorName, words, readings,
      publicDefinitionCounts, 0, 29,);
}

Future<void> addWordsDummy30to59(String flavorName) async {
  // 語句リスト
  final words = <String>[
    '沙汰',
    '左折',
    '散歩',
    '刺身',
    '察知',
    '三脚',
    '砂漠',
    '差分',
    '最低',
    '殺到',
    '察する',
    '冊子',
    '雑談',
    '冊数',
    '察見',
    '砂糖',
    '刺繍',
    '裁判',
    '差異',
    '際立つ',
    '捨てる',
    '蛇足',
    '冴える',
    '猿も木から落ちる',
    '左利き',
    '雑誌',
    '裁縫',
    '冴え冴え',
    '左遷',
    '雑音',
  ];

  // 各単語のひらがなリスト
  final readings = <String>[
    'さた',
    'させつ',
    'さんぽ',
    'さしみ',
    'さっち',
    'さんきゃく',
    'さばく',
    'さぶん',
    'さいてい',
    'さっとう',
    'さっする',
    'さっし',
    'ざつだん',
    'さっすう',
    'さっけん',
    'さとう',
    'ししゅう',
    'さいばん',
    'さい',
    'きわだつ',
    'すてる',
    'だそく',
    'さえる',
    'さるもきからおちる',
    'ひだりきき',
    'ざっし',
    'さいほう',
    'さえさえ',
    'させん',
    'ざつおん',
  ];

  // publicDefinitionCountのダミーデータ
  final publicDefinitionCounts = <int>[
    6,
    4,
    8,
    7,
    3,
    4,
    5,
    6,
    3,
    7,
    8,
    3,
    4,
    5,
    6,
    7,
    5,
    6,
    7,
    4,
    3,
    6,
    5,
    7,
    3,
    5,
    6,
    7,
    8,
    3,
  ];

  await _addWordsDummyToFirestore(flavorName, words, readings,
      publicDefinitionCounts, 30, 59,);
}


Future<void> _addWordsDummyToFirestore(
  String flavorName,
  List<String> words,
  List<String> readings,
  List<int> publicDefinitionCounts,
  int startIndex,
  int endIndex,
) async {
  if (flavorName == 'prod') {
    return;
  }
  final firestore = FirebaseFirestore.instance;

  // Words コレクションのテストデータを挿入
  for (var i = 0; i < 30; i++) {
    final wordId = 'word${startIndex + i + 1}';
    final privateDefinitionCount = Random().nextInt(3);
    final wordData = {
      'id': wordId,
      'word': words[i],
      'reading': readings[i],
      'initialLetter': readings[i][0], // readingの最初の文字
      'publicDefinitionCount': publicDefinitionCounts[i],
      'privateDefinitionCount': privateDefinitionCount,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await firestore.collection('Words').doc(wordId).set(wordData);

    // PrivateDefinitionPostedAuthors サブコレクションのテストデータを挿入
    if (privateDefinitionCount != 0) {
      final randomIndex = Random().nextInt(19) + 1;
      final authorData = {
        'id': 'user$randomIndex',
        'postedPrivateCount': privateDefinitionCount,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await firestore
          .collection('Words')
          .doc(wordId)
          .collection('PrivateDefinitionPostedAuthors')
          .doc('user$randomIndex')
          .set(authorData);
    }
  }
}
