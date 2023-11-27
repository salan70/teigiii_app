import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../router/app_router.dart';

part 'dialog_controller.g.dart';

@riverpod
class DialogController extends _$DialogController {
  @override
  void build() {}

  void show(Widget dialog, {bool barrierDismissible = false}) {
    showDialog<void>(
      barrierDismissible: barrierDismissible,
      context: ref.read(appRouterProvider).navigatorKey.currentContext!,
      builder: (context) => dialog,
    );
  }
}
