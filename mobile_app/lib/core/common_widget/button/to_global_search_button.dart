import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';

/// @doc doc/specs/mobile-app-functional-spec.md#2-3-共通ヘッダー
class ToGlobalSearchButton extends StatelessWidget {
  const ToGlobalSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('global-search-button'),
      tooltip: '検索',
      icon: const Icon(Icons.search),
      onPressed: () => context.pushRoute(const GlobalSearchRoute()),
    );
  }
}
