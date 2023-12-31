import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 端末のバックキーや画面操作を受け付けないローディングWidget
///
/// 透明のWidgetで囲い、ダイアログ表示を模している
class OverlayLoadingWidget extends StatelessWidget {
  const OverlayLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface.withOpacity(0),
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoActivityIndicator(
                    radius: 16,
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
