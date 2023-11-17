import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

import '../../../../util/constant/color_scheme.dart';
import '../../application/definition_service.dart';
import '../../domain/definition.dart';

// TODO(me): UIの左に余白があるのでそれをなくす
class LikeWidget extends ConsumerWidget {
  const LikeWidget({
    super.key,
    required this.definition,
    this.showCount = true,
  });

  final Definition definition;
  final bool showCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LikeButton(
          isLiked: definition.isLikedByUser,
          likeCount: definition.likesCount,
          likeCountPadding: EdgeInsets.only(
            right: showCount ? 24 : 0,
          ),
          likeBuilder: (bool isLiked) {
            return Icon(
              isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              color:
                  isLiked ? likeColor : Theme.of(context).colorScheme.outline,
              size: 20,
            );
          },
          countBuilder: (int? count, bool isLiked, String text) {
            return showCount
                ? Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: isLiked
                          ? likeColor
                          : Theme.of(context).colorScheme.outline,
                    ),
                  )
                : const SizedBox.shrink();
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
