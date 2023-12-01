import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../core/common_widget/avatar_network_image_widget.dart';
import '../../../../util/constant/default_text_for_ui.dart';
import '../../../../util/mixin/presentation_mixin.dart';
import '../../application/user_profile_for_write_notifier.dart';
import '../../domain/user_profile.dart';

class ChangeableProfileImage extends ConsumerWidget with PresentationMixin {
  ChangeableProfileImage({
    super.key,
    required this.userProfileForWrite,
    required this.globalKey,
  });

  final UserProfile userProfileForWrite;
  final GlobalKey globalKey;

  final avatarSize = AvatarSize.large;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      key: globalKey,
      onTap: () async {
        // 位置を取得
        final box = globalKey.currentContext?.findRenderObject() as RenderBox?;
        final position = box!.localToGlobal(Offset.zero) & const Size(400, 80);

        final notifier = ref.read(userProfileForWriteNotifierProvider.notifier);
        
        await showPullDownMenu(
          context: context,
          position: position,
          items: [
            PullDownMenuItem(
              onTap: () async {
                await executeWithOverlayLoading(
                  ref,
                  action: () async =>
                      notifier.pickAndCropImage(ImageSource.camera),
                  errorLogMessage: '画像選択もしくは切り抜き時にエラーが発生。',
                  errorToastMessage: defaultErrorToastText,
                );
              },
              title: '写真を撮る',
              icon: CupertinoIcons.camera_fill,
            ),
            PullDownMenuItem(
              onTap: () async {
                await executeWithOverlayLoading(
                  ref,
                  action: () async =>
                      notifier.pickAndCropImage(ImageSource.gallery),
                  errorLogMessage: '画像選択もしくは切り抜き時にエラーが発生。',
                  errorToastMessage: defaultErrorToastText,
                );
              },
              title: 'アルバムから選択',
              icon: CupertinoIcons.photo_fill,
            ),
            PullDownMenuItem(
              isDestructive: true,
              onTap: () => notifier.updateCroppedFileState(null),
              title: 'もとの画像に戻す',
              icon: CupertinoIcons.trash_fill,
            ),
          ],
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          userProfileForWrite.croppedFile == null
              ? AvatarNetworkImageWidget(
                  imageUrl: userProfileForWrite.profileImageUrl,
                  avatarSize: avatarSize,
                )
              : Container(
                  width: avatarSize.diameter,
                  height: avatarSize.diameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: FileImage(
                        File(userProfileForWrite.croppedFile!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          Container(
            alignment: AlignmentDirectional.bottomEnd,
            // AvatarIconWidget の右下に配置するため、
            // AvatarIconWidget の直径と同じサイズのコンテナを作成する。
            width: avatarSize.diameter,
            height: avatarSize.diameter,
            child: Icon(
              CupertinoIcons.camera_fill,
              size: 28,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
