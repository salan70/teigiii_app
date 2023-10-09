import 'package:flutter/material.dart';

import '../../../../util/extension/date_time_extension.dart';
import '../../domain/definition.dart';

class DefinitionTile extends StatelessWidget {
  const DefinitionTile({
    super.key,
    required this.definition,
  });

  final Definition definition;

  @override
  Widget build(BuildContext context) {
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
                        Text(definition.authorName),
                        // TODO(me): 投稿が何分前にされたかを表示する
                        Text(definition.updatedAt.timeAgo(DateTime.now())),
                      ],
                    ),
                    Text(
                      definition.word,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(definition.definition),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        // TODO(me): タップでいいねの登録/解除する
                        // print('いいね!!');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite_outline, size: 16),
                          const SizedBox(width: 4),
                          Text(definition.likesCount.toString()),
                          const SizedBox(width: 4),
                        ],
                      ),
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
