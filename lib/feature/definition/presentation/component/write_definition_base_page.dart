import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/definition_for_write_notifier.dart';
import '../../domain/definition_for_write.dart';
import '../../util/write_definition_form_type.dart';
import 'select_post_type_button.dart';

/// 定義を入力する画面のベースとなる画面。
///
/// この画面に直接遷移はせず、
/// この画面をもとに作成した画面（定義投稿, 定義編集など）へ遷移すること。
class WriteDefinitionBasePage extends ConsumerWidget {
  const WriteDefinitionBasePage({
    super.key,
    this.autoFocusForm,
    required this.definitionForWrite,
    required this.notifier,
    required this.appBarActionWidget,
  });

  /// 遷移時にフォーカスするTextFormField。
  /// どのTextFormFieldにもフォーカスしない場合はnullを渡す。
  final WriteDefinitionFormType? autoFocusForm;
  final DefinitionForWrite definitionForWrite;
  final DefinitionForWriteNotifier notifier;
  final Widget appBarActionWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.xmark),
          onPressed: () async {
            // キーボードを閉じる
            primaryFocus?.unfocus();

            if (!notifier.isChanged()) {
              // 初期表示時から入力内容に変更がない場合、確認ダイアログを表示せずに画面を閉じる
              await context.popRoute();
              return;
            }
            await _showCloseConfirmDialog(context);
          },
        ),
        title: SelectPostTypeButton(
          definitionForWrite: definitionForWrite,
          notifier: notifier,
        ),
        actions: [
          Center(child: appBarActionWidget),
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
                TextFormField(
                  initialValue: definitionForWrite.word,
                  autofocus: autoFocusForm == WriteDefinitionFormType.word,
                  maxLength: definitionForWrite.maxWordLength,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  onChanged: notifier.changeWord,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: InputDecoration(
                    hintText: '例: 二日目のカレー',
                    labelText: '投稿する言葉',
                    errorText: definitionForWrite.outputWordError(),
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                  initialValue: definitionForWrite.wordReading,
                  autofocus:
                      autoFocusForm == WriteDefinitionFormType.wordReading,
                  maxLength: definitionForWrite.maxWordReadingLength,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  onChanged: notifier.changeWordReading,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    hintText: '例: ふつかめのかれー',
                    labelText: '言葉のよみ',
                    errorText: definitionForWrite.outputWordReadingError(),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: definitionForWrite.definition,
                  autofocus:
                      autoFocusForm == WriteDefinitionFormType.definition,
                  maxLength: definitionForWrite.maxDefinitionLength,
                  maxLines: null,
                  onChanged: notifier.changeDefinition,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
