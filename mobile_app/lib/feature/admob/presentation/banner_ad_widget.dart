import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../util/logger.dart';
import '../application/banner_ad_unit_id_provider.dart';

/// 無限スクロール中に差し込むバナー広告 Widget を提供する Provider.
///
/// 本番では [BannerAdWidget] を返す。[BannerAdWidget] は AdMob の
/// MethodChannel と dotenv に依存し widget test で描画できないため、
/// テストではこの Provider を override してダミーに差し替える。
final bannerAdWidgetProvider = Provider<Widget>(
  (ref) => const BannerAdWidget(),
);

/// バナー広告を 1 枠表示する Widget.
///
/// [BannerAd] は State が保持し、`initState` で 1 度だけ生成・load して
/// `dispose` で破棄する。build のたびに生成すると、リクエストが増え続け
/// 破棄されない [BannerAd] が積み上がる。無限スクロールは tile が
/// ビューポート外へ出ると破棄されるため、この Widget も再生成される。
/// 1 インスタンス = 1 リクエスト = 1 dispose を守ること。
class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;

  /// 読み込みが完了したかどうか。
  ///
  /// 完了前に [AdWidget] を描画すると空枠が出るため、完了後にのみ描画する。
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    // Web では AdMob の MethodChannel が使えない。
    if (kIsWeb) {
      return;
    }

    final bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: ref.read(bannerAdUnitIdProvider),
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (!mounted) {
            return;
          }
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          logger.e('BannerAdの読み込みに失敗しました。 error: $error');
          ad.dispose();
          if (!mounted) {
            // dispose 済み。二重 dispose を避けるため参照だけ落とす。
            _bannerAd = null;
            return;
          }
          setState(() {
            _bannerAd = null;
            _isLoaded = false;
          });
        },
      ),
    );
    _bannerAd = bannerAd;
    unawaited(bannerAd.load());
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerAd = _bannerAd;
    if (bannerAd == null || !_isLoaded) {
      // 読み込み前・読み込み失敗時。呼び出し側が高さを確保しているため、
      // ここでは何も描画しない（レイアウトのガタつきを避ける）。
      return const SizedBox.shrink();
    }

    return AdWidget(ad: bannerAd);
  }
}
