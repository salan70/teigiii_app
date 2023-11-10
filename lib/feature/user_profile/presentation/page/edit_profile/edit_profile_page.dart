import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/avatar_icon_widget.dart';
import '../../../application/user_profile_for_write_notifier.dart';

@RoutePage()
class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserProfileForWrite =
        ref.watch(userProfileForWriteNotifierProvider);
    final notifier = ref.watch(
      userProfileForWriteNotifierProvider.notifier,
    );

    const avatarSize = AvatarSize.large;

    return asyncUserProfileForWrite.when(
      data: (userProfileForWrite) {
        final canEdit = notifier.canEdit();
        return Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('プロフィール編集')),
            actions: [
              Center(
                child: InkWell(
                  onTap: canEdit ? () async {} : null,
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
                  InkWell(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        AvatarIconWidget(
                          imageUrl: userProfileForWrite.profileImageUrl,
                          avatarSize: avatarSize,
                        ),
                        Container(
                          alignment: AlignmentDirectional.bottomEnd,
                          // AvatarIconWidgetの右下に配置するため、
                          // AvatarIconWidgetの直径と同じサイズのコンテナを作成
                          width: avatarSize.diameter,
                          height: avatarSize.diameter,
                          child: Icon(
                            CupertinoIcons.camera_fill,
                            size: 28,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 8),
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
      error: (error, stackTrace) {
        return const Scaffold(
          body: Center(
            child: Text('エラーが発生しました。'),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
