import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'firebase_options/firebase_options.dart';
import 'router/app_router.dart';
import 'util/constant/color_scheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const flavorName = String.fromEnvironment('flavor');
  await Firebase.initializeApp(options: firebaseOptionsWithFlavor(flavorName));

  await FirebaseAnalytics.instance.logEvent(
    name: 'launch App',
  );

  // Flutterフレームワークがキャッチしたエラーを記録する
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Flutterフレームワークでキャッチできない非同期エラーを記録する
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      theme: ThemeData(
        colorScheme: lightColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.surface,
          elevation: 1,
          titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.surface,
            ),
            iconColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        // タップ時のエフェクトを無効化
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }
}
