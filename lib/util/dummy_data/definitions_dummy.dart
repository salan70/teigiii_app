import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;
final definitionsCollection = firestore.collection('Definitions');

final wordIds = List<String>.generate(30, (i) => 'word${i + 1}');

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

Future<void> addDefinitionDummy0to29(String flavorName) async {
  if (flavorName == 'prod') {
    return;
  }

  final definitions = <String>[
    '他者を思いやる深い感情。',
    '実現は難しいが、達成を願う想い。',
    '楽観的な予想や期待。',
    '制限や束縛を受けずに行動すること。',
    '争いを好まず、平和を重んじる考え方。',
    '怪我の治療に用いる粘着性のある布。',
    '日々の生活に欠かせない連続した瞬間。',
    '晴れた日に広がる無限の空。',
    '物体の表面が光を反射する性質。',
    '一方の事象が他方に与える効果。',
    'ウイルスや細菌によって引き起こされる感染症。',
    '目に見えない非常に高い位置。',
    '水面などが風によって小さな波を作ること。',
    '火事による大規模な火災。',
    '夜空に輝く無数の星。',
    '感謝や祝福の気持ちを込めて贈る花。',
    '個人の内面的な感情や思い。',
    '人の声による音楽的表現。',
    '社交的なダンスイベント。',
    '隠された意図や計画。',
    'あることに心を奪われて他のことに注意が向かない状態。',
    '遠くまで広がって聞こえる音。',
    '喜びや幸せの表情。',
    '涙が目に溜まった状態。',
    '困難に立ち向かう勇敢な心。',
    '著しい努力を凝らした作品。',
    '極めて短い時間。',
    '通常では考えられないような現象。',
    '新しい経験に挑戦する意欲。',
    '限りなく続く未来。',
  ];

  final wordReadingInitialGroups =
      readings.map(_categorizeFirstCharacter).toList();

  for (var i = 0; i < words.length; i++) {
    await Future<void>.delayed(const Duration(microseconds: 300));
    await definitionsCollection.doc('definition${i + 1}').set({
      'wordId': wordIds[i],
      'word': words[i],
      'wordReadingInitialGroup': wordReadingInitialGroups[i],
      'authorId': 'user${Random().nextInt(20) + 1}',
      'definition': definitions[i],
      'likesCount': Random().nextInt(100),
      'isPublic': Random().nextBool(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

String _categorizeFirstCharacter(String text) {
  final firstChar = text.substring(0, 1);

  if (RegExp(r'^[ぁ-ん]').hasMatch(firstChar)) {
    return firstChar;
  } else if (RegExp(r'^[ァ-ヶー]').hasMatch(firstChar)) {
    return _convertToHiragana(firstChar);
  } else if (RegExp(r'^[a-zA-Z]').hasMatch(firstChar)) {
    return firstChar.toUpperCase();
  } else if (RegExp(r'^[0-9]').hasMatch(firstChar)) {
    return '数字';
  } else {
    return '記号';
  }
}

String _convertToHiragana(String katakana) {
  final offset = 'ァ'.codeUnitAt(0) - 'ぁ'.codeUnitAt(0);
  return String.fromCharCode(katakana.codeUnitAt(0) - offset);
}
