import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../util/logger.dart';
import '../application/banner_ad_unit_id_provider.dart';

class BannerAdWidget extends ConsumerWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
