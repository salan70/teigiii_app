import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/router/app_router.dart';

/// 言葉を検索するフィールド。
///
/// 見た目と入力の仕様は [DsSearchField] が持ち、ここは遷移先だけを担う。
class SearchWordTextField extends StatefulWidget {
  const SearchWordTextField({super.key, this.defaultText});

  /// 初期値として表示するテキスト。
  final String? defaultText;

  @override
  State<SearchWordTextField> createState() => _SearchWordTextFieldState();
}

class _SearchWordTextFieldState extends State<SearchWordTextField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.defaultText);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsSearchField(
      controller: controller,
      hintText: '言葉を検索',
      onSubmitted: (value) {
        if (value.isEmpty) {
          return;
        }
        controller.text = widget.defaultText ?? '';
        context.pushRoute(WordSearchResultRoute(searchWord: value));
      },
    );
  }
}
