import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'key_provider.dart';

part 'snack_bar_controller.g.dart';

@riverpod
SnackBarController snackBarController(SnackBarControllerRef ref) =>
    SnackBarController(ref);

class SnackBarController {
  SnackBarController(this.ref);

  final Ref ref;

  /// 処理が成功したことを伝える SnackBar を表示する。
  void showSuccessSnackBar(String text, ScaffoldMessengerType type) {
    // すでに表示中の SnackBar があれば非表示にする。
    ref
        .read(scaffoldMessengerKeyProvider(type))
        .currentState
        ?.hideCurrentSnackBar();
    ref.read(scaffoldMessengerKeyProvider(type)).currentState?.showSnackBar(
          _BaseSnackBar(
            text: text,
            duration: const Duration(milliseconds: 2000),
          ),
        );
  }

  /// エラーが発生したことを伝える SnackBar を表示する。
  void showErrorSnackBar(String text, ScaffoldMessengerType type) {
    // すでに表示中の SnackBar があれば非表示にする。
    ref
        .read(scaffoldMessengerKeyProvider(type))
        .currentState
        ?.hideCurrentSnackBar();
    ref.read(scaffoldMessengerKeyProvider(type)).currentState?.showSnackBar(
          _BaseSnackBar(
            text: text,
            duration: const Duration(milliseconds: 4000),
          ),
        );
  }
}

class _BaseSnackBar extends SnackBar {
  _BaseSnackBar({
    required String text,
    required super.duration,
  }) : super(
          content: Text(text),
          margin: const EdgeInsets.all(16),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        );
}
