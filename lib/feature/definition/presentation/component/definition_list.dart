import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/definition_list_notifier.dart';
import '../../util/definition_feed_type.dart';
import 'definition_tile.dart';
import 'definition_tile_shimmer.dart';

class DefinitionList extends ConsumerWidget {
  DefinitionList({
    super.key,
    required this.definitionFeedType,
  });

  final DefinitionFeedType definitionFeedType;
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final definitionList = ref.watch(
      definitionListNotifierProvider(definitionFeedType),
    );

    return definitionList.when(
      data: (data) {
        return EasyRefresh(
          controller: refreshController,
          header: const CupertinoHeader(),
          onRefresh: () async {
            // providerを再生成
            ref.invalidate(definitionListNotifierProvider(definitionFeedType));
            // 処理が完了するまで待つ
            await ref.read(
              definitionListNotifierProvider(definitionFeedType).future,
            );

            refreshController.finishRefresh();
          },
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return DefinitionTile(
                definition: data[index],
                definitionFeedType: definitionFeedType,
              );
            },
          ),
        );
      },
      error: (error, _) {
        // TODO(me): エラー画面を表示させる
        return Center(
          child: Text(
            error.toString(),
          ),
        );
      },
      loading: () {
        return ListView(
          children: [
            for (var i = 0; i < 4; i++) const DefinitionTileShimmer(),
          ],
        );
      },
    );
  }
}
