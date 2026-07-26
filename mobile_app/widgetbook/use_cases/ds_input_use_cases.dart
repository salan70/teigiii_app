import 'package:flutter/material.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

/// 入力系の use case。
List<WidgetbookComponent> dsInputComponents() => [
  WidgetbookComponent(
    name: 'DsSearchField',
    useCases: [
      WidgetbookUseCase(
        name: '未入力',
        builder: (context) => const _SearchFieldPreview(hintText: '言葉を検索'),
      ),
      WidgetbookUseCase(
        name: '入力あり（クリアボタン）',
        builder: (context) => const _SearchFieldPreview(
          hintText: '言葉を検索',
          initialText: '二日目のカレー',
        ),
      ),
      WidgetbookUseCase(
        name: '長文',
        builder: (context) => const _SearchFieldPreview(
          hintText: '言葉を検索',
          initialText: 'とても長い検索語をいれて折り返しと省略の挙動を確認する',
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'DsTextField',
    useCases: [
      WidgetbookUseCase(
        name: 'singleLine',
        builder: (context) => const DsTextField.singleLine(
          label: '登録する言葉',
          hintText: '例: 二日目のカレー',
        ),
      ),
      WidgetbookUseCase(
        name: 'singleLine / prominent',
        builder: (context) => const DsTextField.singleLine(
          label: '登録する言葉',
          initialValue: '二日目のカレー',
          size: DsTextFieldSize.prominent,
        ),
      ),
      WidgetbookUseCase(
        name: 'multiline',
        builder: (context) => const DsTextField.multiline(
          label: '定義',
          hintText: '例: 作ってから一晩経ったカレー。ばり美味い',
        ),
      ),
      WidgetbookUseCase(
        name: 'error',
        builder: (context) => const DsTextField.singleLine(
          label: '登録する言葉',
          initialValue: '',
          errorText: '入力してください',
        ),
      ),
      WidgetbookUseCase(
        name: 'readOnly',
        builder: (context) => const DsTextField.singleLine(
          label: '言葉のよみ',
          initialValue: 'ふつかめのかれー',
          readOnly: true,
        ),
      ),
      WidgetbookUseCase(
        name: '長文 / 文字数上限',
        builder: (context) => const DsTextField.multiline(
          label: '定義',
          initialValue:
              '作ってから一晩経ったカレー。'
              '味がなじんで角が取れ、翌日のほうが美味しいと言われることが多い。'
              'ただし保存方法を誤ると危険なので冷蔵庫に入れること。',
          maxLength: 200,
        ),
      ),
    ],
  ),
];

/// 検索欄は controller の寿命を持つため、use case 用に包んでいる。
class _SearchFieldPreview extends StatefulWidget {
  const _SearchFieldPreview({required this.hintText, this.initialText});

  final String hintText;
  final String? initialText;

  @override
  State<_SearchFieldPreview> createState() => _SearchFieldPreviewState();
}

class _SearchFieldPreviewState extends State<_SearchFieldPreview> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 左右余白は DsSearchField が内部に持つため、ここでは重ねない（#280）。
    return DsSearchField(controller: _controller, hintText: widget.hintText);
  }
}
