import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

import '../ds_test_harness.dart';

void main() {
  group('DsChip.navigable', () {
    testWidgets('ラベルと遷移を示す chevron を表示する', (tester) async {
      await pumpDsWidget(
        tester,
        DsChip.navigable(label: 'この言葉は登録済みです', onTap: () {}),
      );

      expect(find.text('この言葉は登録済みです'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.chevron_forward), findsOneWidget);
    });

    testWidgets('タップすると onTap が呼ばれる', (tester) async {
      var tappedCount = 0;

      await pumpDsWidget(
        tester,
        DsChip.navigable(label: 'この言葉は登録済みです', onTap: () => tappedCount++),
      );
      await tester.tap(find.byType(DsChip));

      expect(tappedCount, 1);
    });

    testWidgets('ラベルが長くても横幅に収まる', (tester) async {
      await pumpDsWidget(
        tester,
        DsChip.navigable(
          label: 'この言葉はすでに登録済みです。同じよみで登録することはできません',
          onTap: () {},
        ),
      );

      expect(tester.takeException(), isNull);
      final size = tester.getSize(find.byType(DsChip));
      expect(size.width, lessThanOrEqualTo(800));
    });
  });
}
