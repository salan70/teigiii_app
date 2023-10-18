import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/definition_id_list_state.dart';
import '../../application/definition_service.dart';
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
    final asyncDefinitionIdListState =
        ref.watch(DefinitionIdListStateNotifierProvider(definitionFeedType));

    return asyncDefinitionIdListState.when(
      data: (data) {
        final definitionIdList = data.definitionIdList;
        return EasyRefresh(
          controller: refreshController,
          header: const CupertinoHeader(),
          onRefresh: () async {
            await ref
                .read(definitionServiceProvider.notifier)
                .refreshAll(definitionFeedType);

            refreshController.finishRefresh();
          },
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentAfter == 0) {
                ref
                    .read(
                      DefinitionIdListStateNotifierProvider(definitionFeedType)
                          .notifier,
                    )
                    .fetchMore();
                return true;
              }
              return true;
            },
            child: ListView.builder(
              itemCount: definitionIdList.length,
              itemBuilder: (context, index) {
                return DefinitionTile(definitionId: definitionIdList[index]);
              },
            ),
          ),
        );
      },
      error: (error, _) {
        debugPrint('error: $error');

        // 取得済みのデータがある場合、それを表示する
        if (asyncDefinitionIdListState.hasValue) {
          final definitionIdList =
              asyncDefinitionIdListState.value!.definitionIdList;
          return ListView.builder(
            itemCount: definitionIdList.length,
            itemBuilder: (context, index) {
              return DefinitionTile(definitionId: definitionIdList[index]);
            },
          );
        }

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
