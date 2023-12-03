import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../core/common_provider/toast_controller.dart';
import '../../../core/router/app_router.dart';
import '../../user_profile/domain/user_profile.dart';

class SearchUserTextField extends ConsumerStatefulWidget {
  SearchUserTextField({
    super.key,
    this.autoFocus = false,
    this.defaultText,
  });

  final bool autoFocus;
  final String? defaultText;

  final focusNode = FocusNode();

  @override
  ConsumerState<SearchUserTextField> createState() =>
      _SearchUserTextFieldState();
}

class _SearchUserTextFieldState extends ConsumerState<SearchUserTextField> {
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
    // 高さを指定しないとエラーになるため、[SizedBox] でラップしている。
    // height は、TextField より大きくする必要がある。
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
              focusNode: widget.focusNode,
              displayArrows: false,
              toolbarButtons: [
                (node) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        if (controller.text.length ==
                            UserProfile.publicIdLength) {
                          context.pushRoute(
                            UserSearchResultRoute(searchWord: controller.text),
                          );
                          controller.text = widget.defaultText ?? '';
                        }
                      },
                      child: Text(
                        '検索',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: controller.text.length ==
                                          UserProfile.publicIdLength
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withOpacity(0.4),
                                ),
                      ),
                    ),
                  );
                }
              ],
            ),
          ],
        ),
        child: TextField(
          focusNode: widget.focusNode,
          controller: controller,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.search,
          // 数字のみ入力可能
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: UserProfile.publicIdLength,
          autofocus: widget.autoFocus,
          onSubmitted: (value) {
            if (value.length != UserProfile.publicIdLength) {
              ref
                  .read(toastControllerProvider.notifier)
                  .showToast('9文字入力してください');
              return;
            }
            controller.text = widget.defaultText ?? '';
            context.pushRoute(UserSearchResultRoute(searchWord: value));
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(
              CupertinoIcons.search,
              size: 20,
            ),
            prefixIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
            suffixIcon: Consumer(
              builder: (context, ref, child) {
                return isEmpty
                    ? const SizedBox.shrink()
                    : GestureDetector(
                        onTap: controller.clear,
                        child: const Icon(
                          CupertinoIcons.clear_thick_circled,
                          size: 20,
                        ),
                      );
              },
            ),
            suffixIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
            hintText: '${UserProfile.publicIdLength}桁のIDを入力',
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
