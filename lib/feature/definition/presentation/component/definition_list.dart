import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/definition_list_notifier.dart';
import '../../util/definition_feed_type.dart';
import 'definition_tile.dart';

class DefinitionList extends ConsumerWidget {
  const DefinitionList({
    super.key,
    required this.definitionFeedType,
  });

  final DefinitionFeedType definitionFeedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final definitionList = ref.watch(
      definitionListNotifierProvider(definitionFeedType),
    );
    return definitionList.when(
      data: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return DefinitionTile(
              definition: data[index],
              definitionFeedType: definitionFeedType,
            );
          },
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
        // TODO(me): スケルトンを表示させる
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
