import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

import '../../../../common_widget/adaptive_overflow_text.dart';
import '../../../../util/constant/color_scheme.dart';
import '../../../../util/extension/date_time_extension.dart';
import '../../application/definition_list_notifier.dart';
import '../../domain/definition.dart';
import '../../util/definition_feed_type.dart';

class DefinitionTile extends ConsumerWidget {
  const DefinitionTile({
    super.key,
    required this.definition,
    required this.definitionFeedType,
  });

  final Definition definition;
  final DefinitionFeedType definitionFeedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final definitionListNotifier = ref.watch(
      definitionListNotifierProvider(definitionFeedType).notifier,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.background,
                backgroundImage: NetworkImage(definition.authorImageUrl),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            definition.authorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(definition.updatedAt.timeAgo(DateTime.now())),
                      ],
                    ),
                    Text(
                      definition.word,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    AdaptiveOverflowText(
                      text: definition.definition,
                      // TODO(me): maxLinesの値を検討する
                      maxLines: 5,
                    ),
                    const SizedBox(height: 8),
                    Row(
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
                              color: isLiked
                                  ? likeColor
                                  : Theme.of(context).colorScheme.outline,
                              size: 20,
                            );
                          },
                          countBuilder:
                              (int? count, bool isLiked, String text) {
                            return Text(
                              text,
                              style: TextStyle(
                                fontSize: 16,
                                color: isLiked
                                    ? likeColor
                                    : Theme.of(context).colorScheme.outline,
                              ),
                            );
                          },
                          onTap: (_) async {
                            await definitionListNotifier.tapLike(definition);
                            return !definition.isLikedByUser;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
