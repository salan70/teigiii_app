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
}
