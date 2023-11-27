import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_provider/entered_text_state.dart';
import '../../../../core/router/app_router.dart';

class SearchWordTextField extends ConsumerWidget {
  const SearchWordTextField({
    super.key,
    this.defaultText,
  });

  final String? defaultText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: defaultText,
    );

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onChanged: ref
          .read(enteredTextNotifierProvider(EnterField.searchWord).notifier)
          .updateText,
      onSubmitted: (value) {
        if (value.isEmpty) {
          return;
        }
        controller.text = defaultText ?? '';
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
        suffixIcon: Consumer(
          builder: (context, ref, child) {
            final enteredText =
                ref.watch(enteredTextNotifierProvider(EnterField.searchWord));
            return enteredText.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      controller.clear();
                      ref
                          .read(
                            enteredTextNotifierProvider(EnterField.searchWord)
                                .notifier,
                          )
                          .clearText();
                    },
                    child: const Icon(
                      CupertinoIcons.clear_thick_circled,
                      size: 20,
                    ),
                  )
                : const SizedBox.shrink();
          },
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
