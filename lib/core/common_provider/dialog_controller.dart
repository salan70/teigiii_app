import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../router/app_router.dart';

part 'dialog_controller.g.dart';

@riverpod
DialogController dialogController(DialogControllerRef ref) =>
    DialogController(ref);

class DialogController {
  DialogController(this.ref);

  final Ref ref;

  void show(Widget dialog, {bool barrierDismissible = false}) {
    showDialog<void>(
      barrierDismissible: barrierDismissible,
      context: ref.read(appRouterProvider).navigatorKey.currentContext!,
      builder: (context) => dialog,
    );
  }
}
