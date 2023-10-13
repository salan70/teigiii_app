import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/definition_service.dart';
import '../../application/definition_state.dart';
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
    final asyncDefinitionIdList =
        ref.watch(definitionIdListProvider(definitionFeedType));

    return asyncDefinitionIdList.when(
      data: (data) {
        return EasyRefresh(
          controller: refreshController,
          header: const CupertinoHeader(),
          onRefresh: () async {
            await ref
                .read(definitionServiceProvider.notifier)
                .refreshAll(definitionFeedType);

            refreshController.finishRefresh();
          },
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return DefinitionTile(definitionId: data[index]);
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
