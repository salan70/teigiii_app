import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/app_router.dart';
import '../../domain/word.dart';

class WordTile extends StatelessWidget {
  const WordTile({
    super.key,
    required this.word,
  });

  final Word word;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.only(
        top: 8,
        right: 16,
        left: 16,
      ),
      child: InkWell(
        onTap: () {
          context.pushRoute(WordTopRoute(wordId: word.id));
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.word,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        word.reading,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${word.postedDefinitionCount}投稿',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      CupertinoIcons.chevron_forward,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20.sp,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
