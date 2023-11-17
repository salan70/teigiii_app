import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../util/constant/color_scheme.dart';

part 'toast_controller.g.dart';

@Riverpod(keepAlive: true)
class ToastController extends _$ToastController {
  @override
  void build() {}

  final _fToast = FToast();

  /// FToastを初期化する
  ///
  /// [context]について、
  /// [GlobalKey<ScaffoldMessengerState>]を保持するProviderから取得したいが、
  /// うまく行かなかったため、[BuildContext]を引数で受け取っている
  void initFToast(BuildContext context) {
    _fToast.init(context);
  }

  /// Toastを表示する
  void showToast(String message, {bool causeError = false}) {
    _fToast.removeCustomToast();

    final Widget toast = Container(
      padding:  REdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8).r,
        color: lightColorScheme.onSurface.withOpacity(0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          causeError
              ? Row(
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_circle_fill,
                      color: lightColorScheme.error,
                    ),
                    const SizedBox(width: 8),
                  ],
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Center(
              child: Text(
                message,
                style: TextStyle(
                  color: lightColorScheme.surface,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      ),
    );

    _fToast.showToast(
      child: toast,
      toastDuration:
          causeError ? const Duration(seconds: 4) : const Duration(seconds: 2),
      positionedToastBuilder: (context, child) {
        return Positioned(
          right: 16,
          bottom: 80,
          left: 16,
          child: child,
        );
      },
    );
  }
}
