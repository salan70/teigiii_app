import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'snack_bar.g.dart';

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

  void showSnackBar(String text) {
    final scaffoldMessengerKey = ref.read(scaffoldMessengerKeyProvider);
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
