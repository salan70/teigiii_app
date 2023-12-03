import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/user_profile/application/user_profile_for_write_notifier.dart';
import '../../feature/user_profile/presentation/changeable_profile_image.dart';
import '../../util/logger.dart';
import '../../util/mixin/presentation_mixin.dart';
import '../common_provider/dialog_controller.dart';
import '../common_widget/avatar_network_image_widget.dart';
import '../common_widget/dialog/confirm_dialog.dart';
import '../common_widget/error_and_retry_widget.dart';
import '../router/app_router.dart';

@RoutePage()
class ProfileEditPage extends ConsumerWidget with PresentationMixin {
  ProfileEditPage({
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

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(CupertinoIcons.xmark),
              onPressed: () async {
                // キーボードを閉じる
                primaryFocus?.unfocus();

                // 初期表示時から入力内容に変更がない場合、確認ダイアログを表示せずに画面を閉じる。
                if (!notifier.isStateChanged()) {
                  await context.popRoute();
                  return;
                }

                // 確認ダイアログを表示する。
                ref.read(dialogControllerProvider).show(
                      ConfirmDialog(
                        confirmMessage: '入力した内容は保存されません。\nよろしいですか？',
                        onAccept: () async => Navigator.of(context)
                            .popUntil((route) => route.isFirst),
                        confirmButtonText: 'OK',
                      ),
                    );
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

                          await executeWithOverlayLoading(
                            ref,
                            action: () async {
                              await notifier.edit();
                              await ref.read(appRouterProvider).pop();
                            },
                            successToastMessage: '保存しました！',
                            errorToastMessage: '保存できませんでした。もう一度お試しください。',
                          );
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
              const SizedBox(width: 24),
            ],
          ),
          body: GestureDetector(
            onTap: () => primaryFocus?.unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                children: [
                  const SizedBox(height: 24),
                  ChangeableProfileImage(
                    userProfileForWrite: userProfileForWrite,
                    globalKey: globalKey,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: userProfileForWrite.name,
                    maxLength: userProfileForWrite.maxNameLength,
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    onChanged: notifier.updateNameState,
                    style: Theme.of(context).textTheme.titleLarge,
                    decoration: InputDecoration(
                      labelText: '名前',
                      errorText: userProfileForWrite.outputNameError(),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: userProfileForWrite.bio,
                    maxLength: userProfileForWrite.maxBioLength,
                    maxLines: null,
                    onChanged: notifier.updateBioState,
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
            padding: const EdgeInsets.symmetric(vertical: 24),
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
