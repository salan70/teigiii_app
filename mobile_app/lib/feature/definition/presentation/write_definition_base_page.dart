import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/common_provider/dialog_controller.dart';
import '../../../../core/common_widget/dialog/confirm_dialog.dart';
import '../../../../core/design_system/design_system.dart';
import '../application/definition_for_write_notifier.dart';
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
    required this.notifier,
    required this.appBarActionWidget,
  });

  /// 遷移時にフォーカスする [TextFormField]
  /// どの [TextFormField] にもフォーカスしない場合はnullを渡す。
  final WriteDefinitionFormType? autoFocusForm;
  final DefinitionForWrite definitionForWrite;
  final DefinitionForWriteNotifier notifier;
  final Widget appBarActionWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = definitionForWrite.id != null;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: DsIconButton(
          icon: CupertinoIcons.xmark,
          semanticLabel: '閉じる',
          onPressed: () async {
            // キーボードを閉じる
            primaryFocus?.unfocus();

            if (!notifier.isChanged()) {
              // 初期表示時から入力内容に変更がない場合、確認ダイアログを表示せずに画面を閉じる
              await context.maybePop();
              return;
            }

            // 確認ダイアログを表示
            ref
                .read(dialogControllerProvider)
                .show(
                  ConfirmDialog(
                    confirmMessage: '入力した内容は保存されません。\nよろしいですか？',
                    onAccept: context.maybePop,
                    confirmButtonText: 'OK',
                  ),
                );
          },
        ),
        title: SelectPostTypeButton(
          definitionForWrite: definitionForWrite,
          notifier: notifier,
        ),
        actions: [
          Center(child: appBarActionWidget),
          const Gap(DsSpacing.section),
        ],
      ),
      body: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: Center(
          child: Padding(
            padding: DsSpacing.screenContentInsets,
            child: ListView(
              children: [
                const Gap(DsSpacing.inline),
                DsTextField.multiline(
                  label: '投稿する言葉',
                  hintText: '例: 二日目のカレー',
                  initialValue: definitionForWrite.word,
                  autofocus: autoFocusForm == WriteDefinitionFormType.word,
                  readOnly: isEditing,
                  maxLength: definitionForWrite.maxWordLength,
                  textInputAction: TextInputAction.next,
                  onChanged: notifier.changeWord,
                  errorText: definitionForWrite.outputWordError(),
                  size: DsTextFieldSize.prominent,
                ),
                DsTextField.multiline(
                  label: '言葉のよみ',
                  hintText: '例: ふつかめのかれー',
                  initialValue: definitionForWrite.wordReading,
                  autofocus:
                      autoFocusForm == WriteDefinitionFormType.wordReading,
                  readOnly: isEditing,
                  maxLength: definitionForWrite.maxWordReadingLength,
                  textInputAction: TextInputAction.next,
                  onChanged: notifier.changeWordReading,
                  errorText: definitionForWrite.outputWordReadingError(),
                ),
                const Gap(DsSpacing.item),
                DsTextField.multiline(
                  label: '定義',
                  hintText: '例: 作ってから一晩経ったカレー。ばり美味い',
                  initialValue: definitionForWrite.definition,
                  autofocus:
                      autoFocusForm == WriteDefinitionFormType.definition,
                  maxLength: definitionForWrite.maxDefinitionLength,
                  onChanged: notifier.changeDefinition,
                  size: DsTextFieldSize.prominent,
                ),
                // ignore: ds_hardcoded_spacing
                // 理由: キーボードで隠れないようにするための画面固有の下部余白。
                // 意味を持つ余白ではないためトークン化しない。
                // 追跡: #281
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
