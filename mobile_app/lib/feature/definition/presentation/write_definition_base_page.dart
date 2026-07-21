import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/common_provider/dialog_controller.dart';
import '../../../../core/common_widget/dialog/confirm_dialog.dart';
import '../domain/definition_for_write.dart';
import 'select_post_type_button.dart';

/// 定義を入力する画面のベースとなる画面。
///
/// この画面に直接遷移はせず、
/// この画面をもとに作成した画面（定義投稿, 定義編集など）へ遷移すること。
///
/// @doc doc/specs/legacy-repository-api-mapping.md#フェーズ-4-の挙動変更-例外-まとめ
class WriteDefinitionBasePage extends ConsumerWidget {
  const WriteDefinitionBasePage({
    super.key,
    this.autoFocusForm,
    required this.definitionForWrite,
    required this.onWordChanged,
    required this.onWordReadingChanged,
    required this.onPublicChanged,
    required this.onDefinitionChanged,
    required this.isChanged,
    required this.appBarActionWidget,
    this.onClose,
    this.wordFieldsReadOnly,
    this.bodyActionWidget,
    this.guideWidget,
  });

  /// 遷移時にフォーカスする [TextFormField]
  /// どの [TextFormField] にもフォーカスしない場合はnullを渡す。
  final WriteDefinitionFormType? autoFocusForm;
  final DefinitionForWrite definitionForWrite;
  final ValueChanged<String> onWordChanged;
  final ValueChanged<String> onWordReadingChanged;
  final ValueChanged<bool> onPublicChanged;
  final ValueChanged<String> onDefinitionChanged;
  final bool isChanged;
  final Widget appBarActionWidget;
  final Future<void> Function()? onClose;
  final bool? wordFieldsReadOnly;
  final Widget? bodyActionWidget;
  final Widget? guideWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = wordFieldsReadOnly ?? definitionForWrite.id != null;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.xmark),
          onPressed: () async {
            // キーボードを閉じる
            primaryFocus?.unfocus();

            if (onClose != null) {
              await onClose!();
              return;
            }

            if (!isChanged) {
              // 初期表示時から入力内容に変更がない場合、確認ダイアログを表示せずに画面を閉じる
              await context.popRoute();
              return;
            }

            // 確認ダイアログを表示
            ref
                .read(dialogControllerProvider)
                .show(
                  ConfirmDialog(
                    confirmMessage: '入力した内容は保存されません。\nよろしいですか？',
                    onAccept: context.popRoute,
                    confirmButtonText: 'OK',
                  ),
                );
          },
        ),
        title: SelectPostTypeButton(
          isPublic: definitionForWrite.isPublic,
          onChanged: onPublicChanged,
        ),
        actions: [
          Center(child: appBarActionWidget),
          const Gap(24),
        ],
      ),
      body: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                const Gap(8),
                if (guideWidget case final widget?) ...[widget, const Gap(16)],
                TextFormField(
                  initialValue: definitionForWrite.word,
                  autofocus: autoFocusForm == WriteDefinitionFormType.word,
                  readOnly: isEditing,
                  maxLength: definitionForWrite.maxWordLength,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  onChanged: onWordChanged,
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
                  readOnly: isEditing,
                  maxLength: definitionForWrite.maxWordReadingLength,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  onChanged: onWordReadingChanged,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    hintText: '例: ふつかめのかれー',
                    labelText: '言葉のよみ',
                    errorText: definitionForWrite.outputWordReadingError(),
                    border: InputBorder.none,
                  ),
                ),
                const Gap(16),
                TextFormField(
                  initialValue: definitionForWrite.definition,
                  autofocus:
                      autoFocusForm == WriteDefinitionFormType.definition,
                  maxLength: definitionForWrite.maxDefinitionLength,
                  maxLines: null,
                  onChanged: onDefinitionChanged,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: const InputDecoration(
                    hintText: '例: 作ってから一晩経ったカレー。ばり美味い',
                    labelText: '定義',
                    border: InputBorder.none,
                  ),
                ),
                if (bodyActionWidget case final widget?) ...[
                  const Gap(8),
                  Align(alignment: Alignment.centerRight, child: widget),
                ],
                const Gap(300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Definition新規投稿/編集時に入力するフォームの種類
enum WriteDefinitionFormType { word, wordReading, definition }
