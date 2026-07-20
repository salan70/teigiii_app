import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/force_event/domain/app_config.dart';
import 'package:teigi_app/feature/force_event/presentation/app_config_gate.dart';

void main() {
  testWidgets('AppConfig の取得失敗時にエラーを表示して再取得できる', (tester) async {
    // * Arrange
    var retryCount = 0;

    // * Act
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: AppConfigGate(
            asyncAppConfig: AsyncValue<AppConfig>.error(
              StateError('failed'),
              StackTrace.empty,
            ),
            onRetry: () => retryCount++,
            child: const Text('アプリ本体'),
          ),
        ),
      ),
    );

    // * Assert
    expect(find.text('エラーが発生しました。'), findsOneWidget);
    expect(find.text('アプリ本体'), findsNothing);

    await tester.tap(find.text('再読み込み'));
    expect(retryCount, 1);
  });
}
