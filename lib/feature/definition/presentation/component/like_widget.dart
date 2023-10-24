import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

import '../../../../util/constant/color_scheme.dart';
import '../../application/definition_service.dart';
import '../../domain/definition.dart';

class LikeWidget extends ConsumerWidget {
  const LikeWidget({
    super.key,
    required this.definition,
  });

  final Definition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TODO(me): countのアニメが表示されない事案を解決する
        LikeButton(
          isLiked: definition.isLikedByUser,
          likeCount: definition.likesCount,
          likeCountPadding: const EdgeInsets.only(
            right: 24,
          ),
          likeBuilder: (bool isLiked) {
            return Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline,
              color:
                  isLiked ? likeColor : Theme.of(context).colorScheme.outline,
              size: 20,
            );
          },
          countBuilder: (int? count, bool isLiked, String text) {
            return Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color:
                    isLiked ? likeColor : Theme.of(context).colorScheme.outline,
              ),
            );
          },
          onTap: (_) async {
            try {
              await ref
                  .read(definitionServiceProvider.notifier)
                  .tapLike(definition);
            } on Exception catch (_) {
              // 例外発生時は、もともとのisLikedByUserの値を返す
              return definition.isLikedByUser;
            }

            return !definition.isLikedByUser;
          },
        ),
      ],
    );
  }
}
