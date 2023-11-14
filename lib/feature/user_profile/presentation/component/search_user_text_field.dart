import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../core/common_provider/entered_text_state.dart';
import '../../../../core/router/app_router.dart';

class SearchUserTextField extends ConsumerWidget {
  SearchUserTextField({
    super.key,
    this.autoFocus = false,
    this.defaultText,
  });

  final bool autoFocus;
  final String? defaultText;

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enteredTextProvider =
        enteredTextNotifierProvider(EnterField.searchUser);

    final controller = TextEditingController(text: defaultText);

    // 詳しいことは分かっていないが、高さを指定しないとエラーになるため、[SizedBox]でラップしている
    // heightは、TextFieldより大きくする必要がある
    return SizedBox(
      height: 80,
      child: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
          keyboardBarColor: Theme.of(context).colorScheme.surface,
          keyboardBarElevation: 0.1,
          nextFocus: false,
          actions: [
            KeyboardActionsItem(
              focusNode: focusNode,
              displayArrows: false,
              toolbarButtons: [
                (node) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        final enteredText = ref.read(enteredTextProvider);
                        if (enteredText.length == 9) {
                          controller.text = defaultText ?? '';
                          context.pushRoute(
                            SearchUserResultRoute(
                              searchId: ref.read(enteredTextProvider),
                            ),
                          );
                        }
                      },
                      child: Text(
                        '検索',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  );
                }
              ],
            ),
          ],
        ),
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.search,
          // 数字のみ入力可能
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 9,
          autofocus: autoFocus,
          onChanged: ref.read(enteredTextProvider.notifier).updateText,
          onSubmitted: (value) {
            if (value.isEmpty) {
              return;
            }
            controller.text = defaultText ?? '';
            context.pushRoute(
              SearchUserResultRoute(searchId: value),
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
                final enteredText = ref.watch(enteredTextProvider);
                return enteredText.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          controller.clear();
                          ref.read(enteredTextProvider.notifier).clearText();
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
            hintText: '9桁のIDを入力',
            filled: true,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
