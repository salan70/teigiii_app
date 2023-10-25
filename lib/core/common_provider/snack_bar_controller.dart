import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'snack_bar_controller.g.dart';

@riverpod
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey(
  ScaffoldMessengerKeyRef ref,
) {
  return GlobalKey<ScaffoldMessengerState>();
}

@riverpod
class SnackBarController extends _$SnackBarController {
  @override
  void build() {}

  /// SnackBarを表示する
  ///
  /// [causeError]がtrueの場合は4000ミリ秒 (デフォルト)、
  /// falseの場合は2000ミリ秒表示させる
  void showSnackBar(String text, {required bool causeError}) {
    final scaffoldMessengerKey = ref.read(scaffoldMessengerKeyProvider);
    // すでに表示中のSnackBarがあれば非表示にする
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        duration: causeError
            ? const Duration(milliseconds: 4000)
            : const Duration(milliseconds: 2000),
        content: Text(text),
      ),
    );
  }
}
