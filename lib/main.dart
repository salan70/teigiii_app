import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/common_provider/is_loading_overlay_state.dart';
import 'core/common_provider/snack_bar_controller.dart';
import 'core/common_widget/loading_dialog.dart';
import 'core/router/app_router.dart';
import 'feature/auth/application/auth_service.dart';
import 'feature/auth/application/auth_state.dart';
import 'firebase_options/firebase_options.dart';
import 'util/constant/color_scheme.dart';
import 'util/constant/text_theme.dart';

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

  // TODO(me): リリース時に削除する
  // デバッグ用にダミーデータを登録する
  // await addUserConfigsToFirestore(flavorName);
  // await addUserProfilesToFirestore(flavorName);

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authServiceProvider.notifier).onAppLaunch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: widget._appRouter.config(),
      scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
      theme: ThemeData(
        fontFamily: 'LINESeedJP',
        colorScheme: lightColorScheme,
        textTheme: textTheme,
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
      builder: (context, child) {
        final isSignedIn = ref.watch(isSignedInProvider);
        if (isSignedIn) {
          final async = ref.watch(authServiceProvider);
          return async.when(
            data: (_) {
              return Stack(
                children: [
                  child!,
                  if (ref.watch(isLoadingOverlayNotifierProvider))
                    const OverlayLoadingWidget(),
                ],
              );
            },
            loading: () {
              return const Scaffold(
                body: OverlayLoadingWidget(),
              );
            },
            error: (error, stack) {
              // TODO(me): エラー画面を作成し、表示させる
              return Scaffold(
                body: Center(
                  child: Text('エラーが発生しました\n$error'),
                ),
              );
            },
          );
        }
        // 起動直後にisSignedInがfalseになる想定
        return const Scaffold(
          body: OverlayLoadingWidget(),
        );
      },
    );
  }
}
