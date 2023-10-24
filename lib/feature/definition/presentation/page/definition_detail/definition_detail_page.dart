import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../util/extension/date_time_extension.dart';
import '../../../application/definition_state.dart';
import '../../component/avatar_icon_widget.dart';
import '../../component/like_widget.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('詳細'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // TODO(me): ドロップダウンを表示する
              // 他ユーザーの場合「ミュートか通報」、自分の場合「編集か削除」
            },
          ),
        ],
      ),
      body: definitionAsync.when(
        data: (definition) {
          return EasyRefresh(
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
                        const SizedBox(width: 16),
                        AvatarIconWidget(imageUrl: definition.authorImageUrl),
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
          );
        },
        loading: () {
          // TODO(me): shimmerを表示する
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, _) {
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },
      ),
    );
  }
}
