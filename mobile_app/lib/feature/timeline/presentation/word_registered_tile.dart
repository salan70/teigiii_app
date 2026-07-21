import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../../core/router/app_router.dart';
import '../../../../util/extension/date_time_extension.dart';

class WordRegisteredTile extends StatelessWidget {
  const WordRegisteredTile({super.key, required this.activity});

  final WordRegisteredActivity activity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushRoute(WordTopRoute(wordId: activity.word.id)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.word.word,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        activity.word.reading,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '言葉が登録されました',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  activity.occurredAt.timeAgo(DateTime.now()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
