import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/force_event/presentation/overlay_force_update_dialog.dart';

void main() {
  testWidgets('システムの戻る操作では閉じない', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const OverlayForceUpdateDialog(),
                  ),
                ),
                child: const Text('強制アップデート表示'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('強制アップデート表示'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('アップデートする'), findsOneWidget);
  });
}
