import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/component/ds_list_tile.dart';
import 'package:teigi_app/core/design_system/theme/ds_theme.dart';

void main() {
  testWidgets('操作不可の行には遷移用 chevron を表示しない', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildDsThemeData(Brightness.light),
        home: const Scaffold(
          body: DsListTile.label(label: 'Apple', onTap: null),
        ),
      ),
    );

    expect(find.text('Apple'), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.chevron_forward), findsNothing);
  });
}
