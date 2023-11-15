import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../feature/auth/application/auth_state.dart';
import '../../../feature/user_config/application/user_config_service.dart';
import '../../../feature/user_config/application/user_config_state.dart';
import '../../../feature/user_profile/application/user_profile_state.dart';
import '../../../feature/user_profile/domain/user_profile.dart';
import '../../../util/constant/url.dart';
import '../../common_provider/launch_url.dart';

class OtherUserActionIconButton extends ConsumerWidget {
  OtherUserActionIconButton({
    super.key,
    required this.ownerId,
  });

  final String ownerId;
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMutedUserIdList = ref.watch(mutedUserIdListProvider);

    // プルダウンメニューの項目を作成する
    List<PullDownMenuEntry> createMenuItems(
      List<String> mutedUserIdList, {
      required UserProfile ownerProfile,
      required UserProfile currentUserProfile,
    }) {
      late final PullDownMenuEntry firstItem;
      if (mutedUserIdList.contains(ownerId)) {
        firstItem = PullDownMenuItemForUserAction.unmuteUser.item(
          ref: ref,
          targetUserProfile: ownerProfile,
          currentUserProfile: currentUserProfile,
        );
      } else {
        firstItem = PullDownMenuItemForUserAction.muteUser.item(
          ref: ref,
          targetUserProfile: ownerProfile,
          currentUserProfile: currentUserProfile,
        );
      }

      return [
        firstItem,
        PullDownMenuItemForUserAction.reportUser.item(
          ref: ref,
          targetUserProfile: ownerProfile,
          currentUserProfile: currentUserProfile,
        ),
      ];
    }

    return asyncMutedUserIdList.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (mutedUserIdList) {
        // TODO(me): 雑に!で取得しているが、問題ないか確認する
        final ownerProfile = ref.read(userProfileProvider(ownerId)).value!;
        final currentUserId = ref.read(userIdProvider)!;
        final currentUserProfile =
            ref.read(userProfileProvider(currentUserId)).value!;

        final items = createMenuItems(
          mutedUserIdList,
          ownerProfile: ownerProfile,
          currentUserProfile: currentUserProfile,
        );
        return IconButton(
          key: globalKey,
          icon: const Icon(CupertinoIcons.ellipsis),
          onPressed: () async {
            // IconButtonの位置を取得
            final box =
                globalKey.currentContext?.findRenderObject() as RenderBox?;
            final position =
                box!.localToGlobal(Offset.zero) & const Size(40, 48);

            if (!context.mounted) {
              return;
            }

            await showPullDownMenu(
              context: context,
              position: position,
              items: items,
            );
          },
        );
      },
    );
  }
}

enum PullDownMenuItemForUserAction {
  muteUser,
  unmuteUser,
  reportUser;

  PullDownMenuItem item({
    required WidgetRef ref,
    required UserProfile targetUserProfile,
    required UserProfile currentUserProfile,
  }) {
    switch (this) {
      case PullDownMenuItemForUserAction.muteUser:
        return PullDownMenuItem(
          onTap: () async {
            await ref
                .read(userConfigServiceProvider.notifier)
                .muteUser(targetUserProfile.id);
          },
          title: 'このユーザーをミュート',
          icon: CupertinoIcons.speaker_slash,
        );
      case PullDownMenuItemForUserAction.unmuteUser:
        return PullDownMenuItem(
          onTap: () async {
            await ref
                .read(userConfigServiceProvider.notifier)
                .unmuteUser(targetUserProfile.id);
          },
          title: 'このユーザーのミュートを解除',
          icon: CupertinoIcons.speaker,
        );
      case PullDownMenuItemForUserAction.reportUser:
        return PullDownMenuItem(
          onTap: () {
            final url = userReportFormUrl(
              targetUserProfile.publicId,
              currentUserProfile.publicId,
            );
            ref.read(launchURLProvider(url));
          },
          title: 'このユーザーを報告',
          icon: CupertinoIcons.flag,
        );
    }
  }
}
