import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../../core/common_widget/avatar_network_image_widget.dart';
import '../../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../../core/common_widget/show_write_close_confirm_dialog.dart';
import '../../../../../util/logger.dart';
import '../../../application/user_profile_for_write_notifier.dart';

@RoutePage()
class EditProfilePage extends ConsumerWidget {
  EditProfilePage({
    super.key,
  });

  final globalKey = GlobalKey();
  final avatarSize = AvatarSize.large;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserProfileForWrite =
        ref.watch(userProfileForWriteNotifierProvider);
    final notifier = ref.watch(userProfileForWriteNotifierProvider.notifier);

    return asyncUserProfileForWrite.when(
      data: (userProfileForWrite) {
        final canEdit = notifier.canEdit();
        final avatarWidget = userProfileForWrite.croppedFile == null
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
              );

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(CupertinoIcons.xmark),
              onPressed: () async {
                // キーボードを閉じる
                primaryFocus?.unfocus();

                if (!notifier.isChanged()) {
                  // 初期表示時から入力内容に変更がない場合、確認ダイアログを表示せずに画面を閉じる
                  await context.popRoute();
                  return;
                }
                await showCloseConfirmDialog(context);
              },
            ),
            title: const Center(child: Text('プロフィール編集')),
            actions: [
              Center(
                child: InkWell(
                  onTap: canEdit
                      ? () async {
                          // キーボードを閉じる
                          primaryFocus?.unfocus();
                          await notifier.edit();
                        }
                      : null,
                  child: Text(
                    '保存',
                    style: canEdit
                        ? Theme.of(context).textTheme.titleLarge
                        : Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.3),
                            ),
                  ),
                ),
              ),
              SizedBox(width: 24.w),
            ],
          ),
          body: GestureDetector(
            onTap: () => primaryFocus?.unfocus(),
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                children: [
                  SizedBox(height: 24.h),
                  InkWell(
                    key: globalKey,
                    onTap: () async {
                      // 位置を取得
                      final box = globalKey.currentContext?.findRenderObject()
                          as RenderBox?;
                      final position =
                          box!.localToGlobal(Offset.zero) & const Size(400, 80);

                      if (!context.mounted) {
                        return;
                      }

                      await showPullDownMenu(
                        context: context,
                        position: position,
                        items: [
                          PullDownMenuItem(
                            onTap: () {
                              notifier.pickAndCropImage(ImageSource.camera);
                            },
                            title: '写真を撮る',
                            icon: CupertinoIcons.camera_fill,
                          ),
                          PullDownMenuItem(
                            onTap: () {
                              notifier.pickAndCropImage(ImageSource.gallery);
                            },
                            title: 'アルバムから選択',
                            icon: CupertinoIcons.photo_fill,
                          ),
                          PullDownMenuItem(
                            isDestructive: true,
                            onTap: notifier.resetCroppedFile,
                            title: 'もとの画像に戻す',
                            icon: CupertinoIcons.trash_fill,
                          ),
                        ],
                      );
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        avatarWidget,
                        Container(
                          alignment: AlignmentDirectional.bottomEnd,
                          // AvatarIconWidgetの右下に配置するため、
                          // AvatarIconWidgetの直径と同じサイズのコンテナを作成
                          width: avatarSize.diameter,
                          height: avatarSize.diameter,
                          child: Icon(
                            CupertinoIcons.camera_fill,
                            size: 28.sp,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    initialValue: userProfileForWrite.name,
                    maxLength: userProfileForWrite.maxNameLength,
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    onChanged: notifier.changeName,
                    style: Theme.of(context).textTheme.titleLarge,
                    decoration: InputDecoration(
                      labelText: '名前',
                      errorText: userProfileForWrite.outputNameError(),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    initialValue: userProfileForWrite.bio,
                    maxLength: userProfileForWrite.maxBioLength,
                    maxLines: null,
                    onChanged: notifier.changeBio,
                    style: Theme.of(context).textTheme.titleLarge,
                    decoration: InputDecoration(
                      labelText: '自己紹介',
                      errorText: userProfileForWrite.outputBioError(),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        // エラー発生後の再読み込み中の場合、trueになる
        if (asyncUserProfileForWrite.isRefreshing) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('プロフィール編集'),
            ),
            body: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
        }

        logger.e('プロフィール編集画面でエラーが発生しました。'
            'error: $error, stackTrace: $stackTrace');
        return Scaffold(
          appBar: AppBar(
            title: const Text('プロフィール編集'),
          ),
          body: Padding(
            padding: REdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: ErrorAndRetryWidget(
                onRetry: () =>
                    ref.invalidate(userProfileForWriteNotifierProvider),
              ),
            ),
          ),
        );
      },
    );
  }
}
