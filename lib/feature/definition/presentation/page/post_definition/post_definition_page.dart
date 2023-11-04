import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/definition_for_write_notifier.dart';
import 'select_post_type_button.dart';

@RoutePage()
class PostDefinitionPage extends ConsumerWidget {
  const PostDefinitionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinitionForWrite =
        ref.watch(definitionForWriteNotifierProvider(null));
    final definitionForWriteNotifier =
        ref.watch(definitionForWriteNotifierProvider(null).notifier);

    return asyncDefinitionForWrite.when(
      data: (definitionForWrite) {
        final canPost = definitionForWrite.canPost();
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(CupertinoIcons.xmark),
              onPressed: () async {
                // キーボードを閉じる
                primaryFocus?.unfocus();

                if (definitionForWrite.isEmptyAllFields) {
                  // 全フィールドが未入力の場合はダイアログを表示せず戻る
                  await context.popRoute();
                  return;
                }
                await _showCloseConfirmDialog(context);
              },
            ),
            title: const SelectPostTypeButton(definitionId: null),
            actions: [
              Center(
                child: InkWell(
                  onTap: canPost
                      ? () async {
                          await definitionForWriteNotifier.post();
                        }
                      : null,
                  child: Text(
                    '投稿',
                    style: canPost
                        ? Theme.of(context).textTheme.titleLarge
                        : Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.3),
                            ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          body: GestureDetector(
            onTap: () => primaryFocus?.unfocus(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    TextField(
                      autofocus: true,
                      maxLength: 30,
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      onChanged: definitionForWriteNotifier.changeWord,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: InputDecoration(
                        hintText: '例: 二日目のカレー',
                        labelText: '投稿する言葉',
                        errorText: definitionForWrite.outputWordError(),
                        border: InputBorder.none,
                      ),
                    ),
                    TextField(
                      maxLength: 50,
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      onChanged: definitionForWriteNotifier.changeWordReading,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        hintText: '例: ふつかめのかれー',
                        labelText: '言葉のよみ',
                        errorText: definitionForWrite.outputWordReadingError(),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      maxLength: 500,
                      maxLines: null,
                      onChanged: definitionForWriteNotifier.changeDefinition,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        // TODO(me): いいヒントテキストを考える
                        hintText: '例: ばり美味い',
                        labelText: '定義',
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 300),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }

  Future<void> _showCloseConfirmDialog(BuildContext context) async {
    await showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          contentPadding: const EdgeInsets.only(
            top: 40,
            bottom: 16,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('入力した内容は保存されません。'),
              Text('よろしいですか？'),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: const EdgeInsets.only(bottom: 16),
          actions: [
            InkWell(
              onTap: () {
                context.popRoute();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'キャンセル',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
