import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// @doc doc/specs/mobile-app-functional-spec.md#10-グローバル検索
@RoutePage()
class GlobalSearchPage extends StatelessWidget {
  const GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('検索')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: '言葉またはユーザーを検索',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
