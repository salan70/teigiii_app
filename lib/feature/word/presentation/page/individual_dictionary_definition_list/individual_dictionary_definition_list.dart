import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../core/common_widget/simple_widget_for_empty.dart';
import '../../../../../util/constant/initial_main_group.dart';
import '../../../../../util/extension/scroll_controller_extension.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../../definition/presentation/component/definition_list.dart';
import '../../../../definition/util/definition_feed_type.dart';
import '../../component/dictionary_author_widget.dart';

@RoutePage()
class IndividualDictionaryDefinitionListPage extends ConsumerWidget {
  const IndividualDictionaryDefinitionListPage({
    super.key,
    required this.targetUserId,
    required this.initialSubGroup,
  });

  final String targetUserId;
  final InitialSubGroup initialSubGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelf = ref.watch(userIdProvider) == targetUserId;
    String generateEmptyMessage(String initialLabel) {
      if (!isSelf) {
        // * 自分以外の辞書の場合
        return '「$initialLabel」の投稿はありません';
      }

      // * 自分の辞書の場合
      final messageList = [
        '「$initialLabel」はまだ投稿されていません\n投稿してくれると嬉しいです😭',
        '「$initialLabel」はまだ投稿されていません\nところで、このアプリを見つけていただきありがとうございます😊',
        '「$initialLabel」は未開拓です..!!',
        '「$initialLabel」は伸びしろたっぷりです😆',
        '「$initialLabel」はまだ投稿されていません😭',
        '「$initialLabel」デビューしませんか🥺',
        'やあ✋私は「$initialLabel」である👴。\nここに来た記念に私を投稿してくれ',
        'やっほー！私は「$initialLabel」だよ。投稿してくれるよね？🥺',
        '「$initialLabel」を開くとはお目が高い！',
        '無理にとは言わんけぇ、\n「$initialLabel」を投稿してはくれまいか？👴',
        '🙃んせまりあは稿投だま',
      ];

      // ランダムでメッセージを返す
      return messageList[Random().nextInt(messageList.length)];
    }

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool _) {
            return <Widget>[
              SliverAppBar(
                forceElevated: true,
                pinned: true,
                title: InkWell(
                  child: Text(initialSubGroup.label),
                  onTap: () =>
                      PrimaryScrollController.of(context).scrollToTop(),
                ),
                flexibleSpace: InkWell(
                  onTap: () =>
                      PrimaryScrollController.of(context).scrollToTop(),
                ),
              ),
            ];
          },
          body: Column(
            children: [
              const SizedBox(height: 16),
              DictionaryAuthorWidget(targetUserId: targetUserId),
              const SizedBox(height: 16),
              Expanded(
                child: DefinitionList(
                  definitionFeedType: DefinitionFeedType.individualIndex,
                  targetUserId: targetUserId,
                  initialSubGroup: initialSubGroup,
                  shimmerTileNumber: 1,
                  emptyWidget: SimpleWidgetForEmpty(
                    message: generateEmptyMessage(initialSubGroup.label),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const PostDefinitionFAB(),
    );
  }
}
