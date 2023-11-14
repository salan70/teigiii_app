import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/common_provider/is_loading_overlay_state.dart';
import 'core/common_widget/loading_dialog.dart';
import 'core/router/app_router.dart';
import 'feature/auth/application/auth_service.dart';
import 'feature/auth/application/auth_state.dart';
import 'firebase_options/firebase_options.dart';
import 'util/constant/theme_data.dart';

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
  // await addUserFollowCountsToFirestore(flavorName);
  // await addUserFollowsToFirestore2(flavorName);
  // await addUserFollowsToFirestore3(flavorName);
  // await addWordsDummy0to29(flavorName);
  // await addWordsDummy30to59(flavorName);
  // await addDefinitionDummy0to29(flavorName);
  // await addLikesToFirestore(flavorName);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja')],
      routerConfig: ref.watch(appRouterProvider).config(),
      theme: getThemeData(ThemeMode.light, context),
      darkTheme: getThemeData(ThemeMode.dark, context),
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
              // publicIdの重複でエラーが発生する可能性があるため、
              // 少なくとも再試行できるボタンを表示させる
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
