import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/auth/application/auth_state.dart';
import '../../../feature/user_profile/application/user_profile_state.dart';
import '../../../feature/user_profile/presentation/avatar_network_image_widget.dart';
import '../../router/app_router.dart';

/// @doc doc/specs/mobile-app-functional-spec.md#2-3-共通ヘッダー
class AccountMenuButton extends ConsumerWidget {
  const AccountMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider);
    if (currentUserId == null) {
      return const SizedBox.shrink();
    }

    final userProfile = ref.watch(userProfileProvider(currentUserId));
    return PopupMenuButton<_AccountMenuAction>(
      key: const Key('account-menu-button'),
      tooltip: 'アカウントメニュー',
      onSelected: (action) async {
        switch (action) {
          case _AccountMenuAction.publicProfile:
            await context.pushRoute(
              ProfileTopRoute(targetUserId: currentUserId),
            );
          case _AccountMenuAction.editProfile:
            await context.pushRoute(ProfileEditRoute());
          case _AccountMenuAction.settings:
            await context.pushRoute(const SettingRouterRoute());
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _AccountMenuAction.publicProfile,
          child: Text('公開プロフィール'),
        ),
        PopupMenuItem(
          value: _AccountMenuAction.editProfile,
          child: Text('プロフィール編集'),
        ),
        PopupMenuItem(value: _AccountMenuAction.settings, child: Text('設定')),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: userProfile.when(
          data: (profile) => AvatarNetworkImageWidget(
            imageUrl: profile.avatarUrl,
            userId: profile.id,
            avatarSize: AvatarSize.small,
          ),
          loading: () => const SizedBox.square(
            dimension: 32,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, _) => const Icon(Icons.account_circle, size: 32),
        ),
      ),
    );
  }
}

enum _AccountMenuAction { publicProfile, editProfile, settings }
