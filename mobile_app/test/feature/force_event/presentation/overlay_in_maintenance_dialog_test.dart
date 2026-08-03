import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/force_event/domain/app_maintenance.dart';
import 'package:teigi_app/feature/force_event/presentation/overlay_in_maintenance_dialog.dart';

void main() {
  testWidgets('終了予定日時がない場合は未定と表示する', (tester) async {
    // * Arrange & Act
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OverlayInMaintenanceDialog(
            appMaintenance: AppMaintenance(
              inMaintenance: true,
              scheduledEndTime: null,
            ),
          ),
        ),
      ),
    );

    // * Assert
    expect(find.textContaining('終了予定は未定です。'), findsOneWidget);
    expect(find.textContaining('null'), findsNothing);
  });

  testWidgets('システムの戻る操作では閉じない', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const OverlayInMaintenanceDialog(
                      appMaintenance: AppMaintenance(
                        inMaintenance: true,
                        scheduledEndTime: null,
                      ),
                    ),
                  ),
                ),
                child: const Text('メンテナンス表示'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('メンテナンス表示'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.textContaining('現在メンテナンス中です'), findsOneWidget);
  });
}
