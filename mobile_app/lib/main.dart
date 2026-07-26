import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/analytics/analytics_event.dart';
import 'core/analytics/analytics_service.dart';
import 'core/common_provider/firebase_providers.dart';
import 'core/common_provider/flavor_state.dart';
import 'core/common_provider/is_loading_overlay_state.dart';
import 'core/common_provider/key_provider.dart';
import 'core/common_widget/dialog/loading_dialog.dart';
import 'core/common_widget/error_and_retry_widget.dart';
import 'core/design_system/design_system.dart';
import 'core/router/app_router.dart';
import 'feature/force_event/application/app_config_state.dart';
import 'feature/force_event/presentation/app_config_gate.dart';
import 'feature/force_event/presentation/overlay_force_update_dialog.dart';
import 'util/firebase_options/firebase_options.dart';
import 'util/logger.dart';
import 'util/web_device_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  final flavor = Flavor.fromString(const String.fromEnvironment('flavor'));
  await Firebase.initializeApp(options: firebaseOptionsWithFlavor(flavor));

  const appCheckDebugToken = String.fromEnvironment('APP_CHECK_DEBUG_TOKEN');
  await FirebaseAppCheck.instance.activate(
    androidProvider: kReleaseMode
        ? AndroidProvider.playIntegrity
        : AndroidProvider.debug,
    appleProvider: kReleaseMode
        ? AppleProvider.deviceCheck
        : AppleProvider.debug,
    // Web は QA 専用のため、kReleaseMode でも常に WebDebugProvider を使う。
    // （本番 Web 提供はスコープ外。将来本番化するときはここで分岐を入れる。）
    // 登録済みデバッグトークンを dart-define で固定注入する（全 origin 通過）。
    // 未指定時は auto-generate（ブラウザ console に出力）する。
    providerWeb: WebDebugProvider(
      debugToken: appCheckDebugToken.isEmpty ? null : appCheckDebugToken,
    ),
  );

  if (!kIsWeb) {
    // Flutterフレームワークがキャッチしたエラーを記録する
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Flutterフレームワークでキャッチできない非同期エラーを記録する
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    await MobileAds.instance.initialize();

    // iOS 端末にてステータスバーを表示させるための設定。
    //
    // 参考: https://halzoblog.com/error-bug-diary/20220922-2/
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  final enableDevicePreview = shouldEnableWebDevicePreview(
    isWeb: kIsWeb,
    platform: defaultTargetPlatform,
  );

  runApp(
    ProviderScope(
      overrides: [flavorProvider.overrideWithValue(flavor)],
      child: DevicePreview(
        // PC の Web QA のみ iPhone 枠。実機ブラウザでは枠なし。
        enabled: enableDevicePreview,
        defaultDevice: Devices.ios.iPhone16,
        builder: (context) {
          return const MyApp();
        },
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  var _didLogAppLaunched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLogAppLaunched) {
      return;
    }
    _didLogAppLaunched = true;
    // ignore: discarded_futures
    ref
        .read(analyticsServiceProvider)
        .logEvent(
          AnalyticsEvent.appLaunched,
          parameters: {AnalyticsParam.flavor: ref.read(flavorProvider).name},
        );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja')],
      routerConfig: ref
          .watch(appRouterProvider)
          .config(
            navigatorObservers: () => [
              FirebaseAnalyticsObserver(
                analytics: ref.watch(firebaseAnalyticsProvider),
              ),
            ],
          ),
      theme: buildDsThemeData(Brightness.light),
      darkTheme: buildDsThemeData(Brightness.dark),
      builder: (context, child) {
        // 強制アップデート関連の処理
        final asyncIsRequiredUpdate = ref.watch(isRequiredAppUpdateProvider);
        final app = asyncIsRequiredUpdate.when(
          loading: () => const Scaffold(body: OverlayLoadingWidget()),
          error: (e, s) {
            // エラーが発生後、再読み込み時にtrueになる。
            if (asyncIsRequiredUpdate.isLoading) {
              return const Scaffold(body: OverlayLoadingWidget());
            }

            logger.e(
              '[asyncIsRequiredUpdate]の取得時にエラーが発生しました。'
              ' error: $e, stackTrace: $s',
            );
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ErrorAndRetryWidget.canInquire(
                      onRetry: () =>
                          ref.invalidate(isRequiredAppUpdateProvider),
                      inBaseRoute: false,
                    ),
                  ),
                ],
              ),
            );
          },
          data: (isRequiredUpdate) {
            if (isRequiredUpdate) {
              // * アップデートが必要な場合
              return Stack(
                children: [child!, const OverlayForceUpdateDialog()],
              );
            }

            // * アップデートが不要な場合
            return Stack(
              children: [
                ScaffoldMessenger(
                  key: ref.watch(
                    scaffoldMessengerKeyProvider(
                      ScaffoldMessengerType.topRoute,
                    ),
                  ),
                  child: child!,
                ),
                if (ref.watch(isLoadingOverlayNotifierProvider))
                  const OverlayLoadingWidget(),
              ],
            );
          },
        );

        final gated = AppConfigGate(
          asyncAppConfig: ref.watch(appConfigProvider),
          onRetry: () => ref.invalidate(appConfigProvider),
          child: app,
        );
        return DevicePreview.appBuilder(context, gated);
      },
    );
  }
}
