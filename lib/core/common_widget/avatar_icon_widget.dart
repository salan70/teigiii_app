import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarIconWidget extends StatelessWidget {
  const AvatarIconWidget({
    super.key,
    required this.imageUrl,
    this.avatarSize = AvatarSize.medium,
  });

  final String imageUrl;
  final AvatarSize avatarSize;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: avatarSize.diameter,
        height: avatarSize.diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
          ),
        ),
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
