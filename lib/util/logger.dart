import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:roggle/roggle.dart';

final logger = kReleaseMode
    ? Roggle.crashlytics(
        printer: CrashlyticsPrinter(
          errorLevel: Level.error, // error 以上のログを送信する
          onError: (event) {
            FirebaseCrashlytics.instance.recordError(
              event.exception,
              event.stack,
              fatal: true, // エラーレポートを即時送信する
            );
          },
          onLog: (event) {
            // ここで記録したログは、firebase コンソールのログタブに表示される
            FirebaseCrashlytics.instance.log(event.message);
          },
        ),
      )
    : Roggle(
        printer: SinglePrettyPrinter(
          loggerName: '[APP]',
          stackTraceLevel: Level.error,
          stackTraceMethodCount: 10,
          stackTracePrefix: '>>> ',
          // ログが長くなるので非表示
          printCaller: false,
        ),
      );
