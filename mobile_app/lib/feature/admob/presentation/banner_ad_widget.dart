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

class BannerAdWidget extends ConsumerWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    return AdWidget(
      ad: BannerAd(
        size: AdSize.banner,
        adUnitId: ref.watch(bannerAdUnitIdProvider),
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            logger.e('BannerAdの読み込みに失敗しました。 error: $error');
          },
        ),
      )..load(),
    );
  }
}
