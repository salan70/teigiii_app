import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../../util/extension/date_time_extension.dart';
import '../../../../auth/application/auth_state.dart';
import '../../../../user_config/application/user_config_service.dart';
import '../../../application/definition_state.dart';
import '../../component/avatar_icon_widget.dart';
import '../../component/like_widget.dart';
import 'definition_detail_shimmer.dart';

@RoutePage()
class DefinitionDetailPage extends ConsumerWidget {
  const DefinitionDetailPage({
    super.key,
    required this.definitionId,
  });

  final String definitionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final definitionAsync = ref.watch(definitionProvider(definitionId));
    final globalKey = GlobalKey();

    return definitionAsync.when(
      data: (definition) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
            actions: [
              IconButton(
                key: globalKey,
                icon: const Icon(Icons.more_horiz),
                onPressed: () async {
                  // 万が一userIdがnullの場合、
                  // 定義の編集/削除をできなくするために空文字を入れる
                  final userId = ref.read(userIdProvider) ?? '';

                  // IconButtonの位置を取得
                  final box = globalKey.currentContext?.findRenderObject()
                      as RenderBox?;
                  final position =
                      box!.localToGlobal(Offset.zero) & const Size(40, 48);

                  late final List<PullDownMenuEntry> items;
                  if (userId == definition.authorId) {
                    items = [
                      PullDownMenuItem(
                        onTap: () {
                          // TODO: 定義の編集画面に遷移する
                        },
                        title: 'この定義を編集',
                        icon: CupertinoIcons.pencil,
                      ),
                      PullDownMenuItem(
                        onTap: () {
                          // TODO(me): 定義を削除する（確認ダイアログを表示）
                        },
                        title: 'この定義を削除',
                        icon: CupertinoIcons.trash,
                      ),
                    ];
                  } else {
                    items = [
                      PullDownMenuItem(
                        onTap: () async {
                          // TODO(me): ユーザーをミュートする
                          // 1. ミュート情報をFirestoreに保存する
                          await ref
                              .read(userConfigServiceProvider.notifier)
                              .addMutedUser(definition.authorId);

                          // 2. 1のセキュリティルールを設定する
                          // 3. ミュート成功したら、ミュートしたユーザーの定義を非表示にする（該当Providerをinvalidate）
                          // 4. ミュート完了のスナックバー出す（解除は設定から〜）
                          // 5. ミュート失敗したら、スナックバー出す（いいねの要領）
                          // 6. ミュート処理中はオーバーレイローディング出す（いいねの要領）
                        },
                        title: 'このユーザーをミュート',
                        icon: CupertinoIcons.speaker_slash,
                      ),
                      PullDownMenuItem(
                        onTap: () {
                          // TODO(me): ユーザーを報告する(Googleフォームを開く)
                        },
                        title: 'このユーザーを報告',
                        icon: CupertinoIcons.flag,
                      ),
                    ];
                  }

                  await showPullDownMenu(
                    context: context,
                    position: position,
                    items: items,
                  );
                },
              ),
            ],
          ),
          body: EasyRefresh(
            header: const CupertinoHeader(),
            onRefresh: () async {
              ref.invalidate(definitionProvider(definitionId));
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                  bottom: 120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AvatarIconWidget(
                          imageUrl: definition.authorImageUrl,
                        ),
                        const SizedBox(width: 16),
                        Text(definition.authorName),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      definition.word,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(definition.definition),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          definition.createdAt.toDisplayFormat(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '作成',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          definition.updatedAt.toDisplayFormat(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '更新',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LikeWidget(definition: definition),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
          ),
          body: const DefinitionDeitailShimmer(),
        );
      },
      error: (error, _) {
        // TODO(me): いい感じのエラー画面を表示させる
        return Scaffold(
          appBar: AppBar(
            title: const Text('詳細'),
          ),
          body: Center(
            child: Text(error.toString()),
          ),
        );
      },
    );
  }
}
