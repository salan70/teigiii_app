import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../core/common_provider/entered_text_state.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/user_profile.dart';

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
      height: 80.h,
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
                    padding: REdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        if (controller.text.length ==
                            UserProfile.publicIdLength) {
                          context.pushRoute(
                            SearchUserResultRoute(searchWord: controller.text),
                          );
                          controller.text = defaultText ?? '';
                        }
                      },
                      child: Consumer(
                        builder: (context, ref, child) {
                          final enteredText = ref.watch(enteredTextProvider);
                          return Text(
                            '検索',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: enteredText.length ==
                                          UserProfile.publicIdLength
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withOpacity(0.4),
                                ),
                          );
                        },
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
          maxLength: UserProfile.publicIdLength,
          autofocus: autoFocus,
          onChanged: ref.read(enteredTextProvider.notifier).updateText,
          // TODO(me): Android端末にて、現状のonSubmittedで使用感に問題ないか確認する
          // 空の場合や、文字数が足りない場合など、値が無効な場合の処理を追加する必要があるかも
          onSubmitted: (value) {
            if (value.isEmpty) {
              return;
            }
            controller.text = defaultText ?? '';
            context.pushRoute(SearchUserResultRoute(searchWord: value));
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              CupertinoIcons.search,
              size: 20.sp,
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
            hintText: '${UserProfile.publicIdLength}桁のIDを入力',
            filled: true,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40).r,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
