import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';

/// 語句を検索する用の [TextField]。
class SearchWordTextField extends StatefulWidget {
  const SearchWordTextField({
    super.key,
    this.defaultText,
  });

  /// 初期値として表示するテキスト。
  final String? defaultText;

  @override
  State<SearchWordTextField> createState() => _SearchWordTextFieldState();
}

class _SearchWordTextFieldState extends State<SearchWordTextField> {
  late final TextEditingController controller;
  late bool isEmpty;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.defaultText);

    isEmpty = controller.text.isEmpty;

    controller.addListener(() {
      setState(() {
        isEmpty = controller.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        if (value.isEmpty) {
          return;
        }
        controller.text = widget.defaultText ?? '';
        context.pushRoute(
          SearchWordResultRoute(searchWord: value),
        );
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          CupertinoIcons.search,
          size: 20,
        ),
        prefixIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
        suffixIcon: isEmpty
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: controller.clear,
                child: const Icon(
                  CupertinoIcons.clear_thick_circled,
                  size: 20,
                ),
              ),
        suffixIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
        hintText: '語句を検索',
        filled: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
