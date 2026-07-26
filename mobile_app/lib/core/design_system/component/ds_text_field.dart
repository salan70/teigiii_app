import 'package:flutter/material.dart';

import '../token/ds_theme_context.dart';

/// 入力欄の文字量。
enum DsTextFieldSize {
  /// 見出し相当の大きさ。言葉そのものなど短く主となる入力。
  prominent,

  /// 本文相当の大きさ。読みや補足の入力。
  standard,
}

/// 検索以外の汎用テキスト入力。
///
/// `InputDecoration` や `TextStyle` は公開 API で受け取らない。
///
/// @doc doc/specs/mobile-app-design-system.md#初期コンポーネント最低セット261
class DsTextField extends StatelessWidget {
  /// 1 行で収まることを想定した入力。
  const DsTextField.singleLine({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.maxLength,
    this.autofocus = false,
    this.readOnly = false,
    this.size = DsTextFieldSize.standard,
    this.textInputAction,
  }) : isMultiline = false;

  /// 複数行になりうる入力。
  const DsTextField.multiline({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.maxLength,
    this.autofocus = false,
    this.readOnly = false,
    this.size = DsTextFieldSize.standard,
    this.textInputAction,
  }) : isMultiline = true;

  /// 入力欄の見出し。
  final String label;

  /// 入力例などの説明。
  final String? hintText;

  /// 入力値の管理。[initialValue] とは併用しない。
  final TextEditingController? controller;

  /// 初期値。[controller] とは併用しない。
  final String? initialValue;

  /// フォーカス管理。
  final FocusNode? focusNode;

  /// エラー内容。null ならエラーなし。
  final String? errorText;

  /// 入力が変わったときの処理。
  final ValueChanged<String>? onChanged;

  /// 確定時の処理。
  final ValueChanged<String>? onSubmitted;

  /// 最大文字数。
  final int? maxLength;

  /// 表示直後にフォーカスするかどうか。
  final bool autofocus;

  /// 読み取り専用かどうか。
  final bool readOnly;

  /// 文字量。
  final DsTextFieldSize size;

  /// キーボードの確定キーの種類。
  final TextInputAction? textInputAction;

  /// 複数行になりうるかどうか。
  final bool isMultiline;

  @override
  Widget build(BuildContext context) {
    final typography = context.dsTypography;
    final style = switch (size) {
      DsTextFieldSize.prominent => typography.heading,
      DsTextFieldSize.standard => typography.itemTitle,
    };

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      autofocus: autofocus,
      readOnly: readOnly,
      maxLength: maxLength,
      // null にすると入力量に応じて行が増える。
      maxLines: isMultiline ? null : 1,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      style: style,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: errorText,
        border: InputBorder.none,
      ),
    );
  }
}
