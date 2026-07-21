import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../core/common_provider/launch_url_controller.dart';
import '../../../util/constant/url.dart';
import '../../../util/mixin/presentation_mixin.dart';
import '../../auth/application/auth_state.dart';
import '../../user_profile/application/user_profile_state.dart';
import '../../user_profile/domain/user_profile.dart';
import '../application/user_config_service.dart';
import '../application/user_config_state.dart';

/// @doc doc/specs/mobile-app-functional-spec.md#13-通報
class OtherUserActionIconButton extends ConsumerWidget with PresentationMixin {
  OtherUserActionIconButton({
    super.key,
    required this.ownerId,
    this.inBaseRoute = true,
    this.reportTargetType,
    this.reportTargetId,
  }) : assert(reportTargetType == null || reportTargetId != null);

  final String ownerId;
  final bool inBaseRoute;
  final ReportTargetType? reportTargetType;
  final String? reportTargetId;

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
                  inBaseRouteBeforeAction: inBaseRoute,
                  inBaseRouteAfterAction: inBaseRoute,
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
                  inBaseRouteBeforeAction: inBaseRoute,
                  inBaseRouteAfterAction: inBaseRoute,
                );
              },
              title: 'このユーザーをミュート',
              icon: CupertinoIcons.speaker,
            );

      return [
        firstItem,
        if (reportTargetType case final targetType?)
          PullDownMenuItem(
            onTap: () async {
              final currentUserId = ref.read(userIdProvider)!;
              final currentUserProfile = await ref.read(
                userProfileProvider(currentUserId).future,
              );
              final url = contentReportFormUrl(
                targetType: targetType,
                targetId: reportTargetId!,
                currentUserPublicId: currentUserProfile.publicId,
                initialReason: switch (targetType) {
                  ReportTargetType.definition => '定義について報告: ',
                  ReportTargetType.word => '言葉について報告: ',
                  ReportTargetType.user => 'ユーザーについて報告: ',
                },
              );
              await ref
                  .read(launchUrlControllerProvider)
                  .launchURL(url, inBaseRoute: inBaseRoute);
            },
            title: switch (targetType) {
              ReportTargetType.definition => 'この定義を報告',
              ReportTargetType.word => 'この言葉を報告',
              ReportTargetType.user => 'このユーザーを報告',
            },
            icon: CupertinoIcons.flag,
          ),
        PullDownMenuItem(
          onTap: () async {
            final currentUserId = ref.read(userIdProvider)!;
            final currentUserProfile = await ref.read(
              userProfileProvider(currentUserId).future,
            );

            final url = userReportFormUrl(
              currentUserPublicId: currentUserProfile.publicId,
              targetUserPublicId: ownerProfile.publicId,
            );
            await ref
                .read(launchUrlControllerProvider)
                .launchURL(url, inBaseRoute: inBaseRoute);
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

            final ownerProfile = await ref.read(
              userProfileProvider(ownerId).future,
            );

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
