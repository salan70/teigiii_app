import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../token/ds_radius.dart';
import '../token/ds_size.dart';
import '../token/ds_theme_context.dart';

/// 検索用の入力欄。
///
/// 入力があるときだけクリアボタンを出す挙動を内部に閉じている。
/// 検索以外の入力には `DsTextField` を使う。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット-261
class DsSearchField extends StatefulWidget {
  const DsSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.onSubmitted,
    this.autofocus = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  });

  /// 入力値の管理。
  final TextEditingController controller;

  /// 未入力時に表示する説明。
  final String hintText;

  /// フォーカス管理。
  final FocusNode? focusNode;

  /// 確定時の処理。
  final ValueChanged<String>? onSubmitted;

  /// 表示直後にフォーカスするかどうか。
  final bool autofocus;

  /// キーボードの種類。
  final TextInputType? keyboardType;

  /// 入力の制限。
  final List<TextInputFormatter>? inputFormatters;

  /// 最大文字数。
  final int? maxLength;

  @override
  State<DsSearchField> createState() => _DsSearchFieldState();
}

class _DsSearchFieldState extends State<DsSearchField> {
  late bool _isEmpty;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.controller.text.isEmpty;
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChanged);
    super.dispose();
  }

  void _handleTextChanged() {
    final isEmpty = widget.controller.text.isEmpty;
    if (isEmpty == _isEmpty) {
      return;
    }
    setState(() {
      _isEmpty = isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.dsColorScheme;

    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      textInputAction: TextInputAction.search,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        prefixIcon: const Icon(CupertinoIcons.search, size: DsSize.iconMedium),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIcon: _isEmpty
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: widget.controller.clear,
                child: const Icon(
                  CupertinoIcons.clear_thick_circled,
                  size: DsSize.iconMedium,
                  semanticLabel: '入力を消去',
                ),
              ),
        suffixIconColor: colorScheme.onSurfaceVariant,
        hintText: widget.hintText,
        filled: true,
        contentPadding: EdgeInsets.zero,
        border: const OutlineInputBorder(
          borderRadius: DsRadius.fieldBorder,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
