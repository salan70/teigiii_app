import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/util/constant/initial_main_group.dart';

void main() {
  group('InitialMainGroup', () {
    test('sectionHeaderLabelは各グループの短縮ラベルを返す', () {
      const expectedLabels = <InitialMainGroup, String>{
        InitialMainGroup.japaneseAColumn: 'あ',
        InitialMainGroup.japaneseKaColumn: 'か',
        InitialMainGroup.japaneseSaColumn: 'さ',
        InitialMainGroup.japaneseTaColumn: 'た',
        InitialMainGroup.japaneseNaColumn: 'な',
        InitialMainGroup.japaneseHaColumn: 'は',
        InitialMainGroup.japaneseMaColumn: 'ま',
        InitialMainGroup.japaneseYaColumn: 'や',
        InitialMainGroup.japaneseRaColumn: 'ら',
        InitialMainGroup.japaneseWaColumn: 'わ',
        InitialMainGroup.alphabet: 'A-Z',
        InitialMainGroup.other: '数字・記号',
      };

      for (final entry in expectedLabels.entries) {
        expect(entry.key.sectionHeaderLabel, entry.value);
      }
    });

    test('サーバーの全サブグループを対応するメイングループへ変換する', () {
      for (final entry in initialMapping.entries) {
        for (final subGroup in entry.value) {
          expect(InitialMainGroup.fromSubGroupLabel(subGroup.label), entry.key);
        }
      }
    });

    test('未知のサブグループは数字・記号へフォールバックする', () {
      expect(
        InitialMainGroup.fromSubGroupLabel('unknown'),
        InitialMainGroup.other,
      );
    });
  });
}
