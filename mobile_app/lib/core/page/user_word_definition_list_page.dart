import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/definition_list/presentation/definition_list.dart';
import '../../feature/definition_list/util/definition_feed_type.dart';
import '../../util/extension/scroll_controller_extension.dart';

/// あなたの辞書から遷移する、特定の言葉に対する自分の定義一覧。
@RoutePage()
class UserWordDefinitionListPage extends ConsumerWidget {
  const UserWordDefinitionListPage({
    super.key,
    required this.targetUserId,
    required this.wordId,
    required this.wordLabel,
  });

  final String targetUserId;
  final String wordId;
  final String wordLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Text(wordLabel),
          onTap: () {
            final controller = PrimaryScrollController.maybeOf(context);
            controller?.scrollToTop();
          },
        ),
      ),
      body: DefinitionList(
        definitionFeedType: DefinitionFeedType.userWordDefinitions,
        targetUserId: targetUserId,
        wordId: wordId,
        emptyWidget: const Center(child: Text('定義がありません')),
      ),
    );
  }
}
