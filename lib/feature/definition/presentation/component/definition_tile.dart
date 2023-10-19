import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

import '../../../../core/common_widget/adaptive_overflow_text.dart';
import '../../../../util/constant/color_scheme.dart';
import '../../../../util/extension/date_time_extension.dart';
import '../../application/definition_service.dart';
import '../../application/definition_state.dart';
import 'definition_tile_shimmer.dart';

class DefinitionTile extends ConsumerWidget {
  const DefinitionTile({
    super.key,
    required this.definitionId,
  });

  final String definitionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinition = ref.watch(definitionProvider(definitionId));
    return asyncDefinition.when(
      data: (definition) {
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
                  CachedNetworkImage(
                    imageUrl: definition.authorImageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
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
      },
      error: (error, stackTrace) {
        debugPrint('definition id: $definitionId');
        debugPrint('error: $error');
        // TODO(me): エラー時に表示させるTileを作成する
        // 「!」みたいなアイコンと、エラーが発生した旨を表示するのが良さげ
        return const SizedBox();
      },
      loading: () {
        return const DefinitionTileShimmer();
      },
    );
  }
}
