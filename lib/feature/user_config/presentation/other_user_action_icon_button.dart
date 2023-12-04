import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../core/common_provider/launch_url.dart';
import '../../../util/constant/url.dart';
import '../../../util/mixin/presentation_mixin.dart';
import '../../auth/application/auth_state.dart';
import '../../user_profile/application/user_profile_state.dart';
import '../../user_profile/domain/user_profile.dart';
import '../application/user_config_service.dart';
import '../application/user_config_state.dart';

class OtherUserActionIconButton extends ConsumerWidget with PresentationMixin {
  OtherUserActionIconButton({
    super.key,
    required this.ownerId,
  });

  final String ownerId;
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMutedUserIdList = ref.watch(mutedUserIdListProvider);

    // プルダウンメニューの項目を作成する。
    List<PullDownMenuEntry> createMenuItems({
      required List<String> mutedUserIdList,
      required UserProfile ownerProfile,
    }) {
      final firstItem = (mutedUserIdList.contains(ownerId))
          // owner をミュート済みの場合の MenuItem.
          ? PullDownMenuItem(
              onTap: () async {
                await executeWithOverlayLoading(
                  ref,
                  action: () async => ref
                      .read(userConfigServiceProvider)
                      .unmuteUser(ownerProfile.id),
                  successToastMessage: 'ミュート解除しました。',
                );
              },
              title: 'このユーザーのミュートを解除',
              icon: CupertinoIcons.speaker_slash,
            )
          // owner をミュートしていない場合の MenuItem.
          : PullDownMenuItem(
              onTap: () async {
                await executeWithOverlayLoading(
                  ref,
                  action: () async => ref
                      .read(userConfigServiceProvider)
                      .muteUser(ownerProfile.id),
                  successToastMessage: 'ミュートしました。',
                );
              },
              title: 'このユーザーをミュート',
              icon: CupertinoIcons.speaker,
            );

      return [
        firstItem,
        PullDownMenuItem(
          onTap: () async {
            final currentUserId = ref.read(userIdProvider)!;
            final currentUserProfile =
                await ref.read(userProfileProvider(currentUserId).future);

            final url = userReportFormUrl(
              currentUserPublicId: currentUserProfile.publicId,
              targetUserPublicId: ownerProfile.publicId,
            );
            ref.read(launchURLProvider(url));
          },
          title: 'このユーザーを報告',
          icon: CupertinoIcons.flag,
        ),
      ];
    }

    return asyncMutedUserIdList.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (mutedUserIdList) {
        return IconButton(
          key: globalKey,
          icon: const Icon(CupertinoIcons.ellipsis),
          onPressed: () async {
            // IconButton の位置を取得する。
            final box =
                globalKey.currentContext?.findRenderObject() as RenderBox?;
            final position =
                box!.localToGlobal(Offset.zero) & const Size(40, 48);

            final ownerProfile =
                await ref.read(userProfileProvider(ownerId).future);

            if (!context.mounted) {
              return;
            }

            await showPullDownMenu(
              context: context,
              position: position,
              items: createMenuItems(
                mutedUserIdList: mutedUserIdList,
                ownerProfile: ownerProfile,
              ),
            );
          },
        );
      },
    );
  }
}
