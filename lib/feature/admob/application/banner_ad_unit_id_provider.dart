import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/flavor_provider.dart';
import '../../../util/constant/flavor.dart';
import '../../../util/extension/target_platform_extension.dart';

part 'banner_ad_unit_id_provider.g.dart';

/// flavor と platform に応じた BannerAd のId を保持する。
@riverpod
String bannerAdUnitId(BannerAdUnitIdRef ref) {
  final platform = defaultTargetPlatform.when(
    onIOS: () => 'IOS',
    onAndroid: () => 'ANDROID',
  );

  final flavor = ref.watch(flavorProvider);
  switch (flavor) {
    case Flavor.prod:
      return dotenv.env['BANNER_ID_$platform']!;
    case Flavor.dev:
      return dotenv.env['TEST_BANNER_ID_$platform']!;
  }
}
