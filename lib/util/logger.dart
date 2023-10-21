import 'package:roggle/roggle.dart';

final logger = Roggle(
  printer: SinglePrettyPrinter(
    loggerName: '[APP]',
    stackTraceLevel:
        Level.error,
    stackTraceMethodCount: 10, 
    stackTracePrefix: '>>> ', 
    // ログが長くなるので非表示
    printCaller: false,
  ),
);
