import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_providers.dart';
import '../../../core/common_widget/shimmer_widget.dart';
import '../util/default_avatar.dart';

class AvatarNetworkImageWidget extends ConsumerWidget {
  const AvatarNetworkImageWidget({
    super.key,
    required this.imageUrl,
    required this.userId,
    this.avatarSize = AvatarSize.medium,
  });

  /// アバター画像の URL。未設定（null）の場合はデフォルトアイコンを表示する
  final String? imageUrl;

  /// デフォルトアイコンの決定的な選択に使うユーザー ID
  final String userId;

  final AvatarSize avatarSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = this.imageUrl;
    if (imageUrl == null) {
      return Container(
        width: avatarSize.diameter,
        height: avatarSize.diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(defaultAvatarAssetPath(userId)),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheManager: ref.watch(avatarCacheManagerProvider),
      imageBuilder: (context, imageProvider) => Container(
        width: avatarSize.diameter,
        height: avatarSize.diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider),
        ),
      ),
      placeholder: (context, url) => ShimmerWidget.circular(
        width: avatarSize.diameter,
        height: avatarSize.diameter,
      ),
    );
  }
}

enum AvatarSize {
  small,
  medium,
  large;

  /// [AvatarSize]に応じた直径を返す
  double get diameter {
    switch (this) {
      case AvatarSize.small:
        return 32;
      case AvatarSize.medium:
        return 48;
      case AvatarSize.large:
        return 72;
    }
  }
}
