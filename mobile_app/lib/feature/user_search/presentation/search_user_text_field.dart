import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../core/common_provider/key_provider.dart';
import '../../../core/common_provider/snack_bar_controller.dart';
import '../../../core/design_system/design_system.dart';
import '../../../core/router/app_router.dart';
import '../../user_profile/domain/user_profile.dart';

/// ユーザー ID を検索するフィールド。
///
/// 見た目は [DsSearchField] が持ち、ここは ID 制約・KeyboardActions・遷移を担う。
class SearchUserTextField extends ConsumerStatefulWidget {
  SearchUserTextField({super.key, this.autoFocus = false, this.defaultText});

  final bool autoFocus;
  final String? defaultText;

  final focusNode = FocusNode();

  @override
  ConsumerState<SearchUserTextField> createState() =>
      _SearchUserTextFieldState();
}

class _SearchUserTextFieldState extends ConsumerState<SearchUserTextField> {
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
    // KeyboardActions のスクロール回避は検索欄では不要。
    // disableScroll: true にしないと高さが不定になりレイアウトが崩れる。
    return KeyboardActions(
      disableScroll: true,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: DsSpacing.screenHorizontal,
                  ),
                  child: ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) {
                      final enabled =
                          controller.text.length == UserProfile.publicIdLength;
                      return InkWell(
                        onTap: () {
                          if (!enabled) {
                            return;
                          }
                          context.pushRoute(
                            UserSearchResultRoute(searchWord: controller.text),
                          );
                          controller.text = widget.defaultText ?? '';
                        },
                        child: Text(
                          '検索',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                color: enabled
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.4),
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            ],
          ),
        ],
      ),
      child: DsSearchField(
        focusNode: widget.focusNode,
        controller: controller,
        hintText: '${UserProfile.publicIdLength}桁のIDを入力',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: UserProfile.publicIdLength,
        autofocus: widget.autoFocus,
        onSubmitted: (value) {
          if (value.length != UserProfile.publicIdLength) {
            ref
                .read(snackBarControllerProvider)
                .showErrorSnackBar(
                  '9文字入力してください',
                  ScaffoldMessengerType.baseRoute,
                );
            return;
          }
          controller.text = widget.defaultText ?? '';
          context.pushRoute(UserSearchResultRoute(searchWord: value));
        },
      ),
    );
  }
}
