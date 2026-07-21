import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/auth/application/auth_state.dart';
import '../../feature/public_dictionary/presentation/public_dictionary_list.dart';
import '../../feature/user_config/presentation/other_user_action_icon_button.dart';
import '../../feature/user_profile/application/user_profile_state.dart';
import '../../feature/user_profile/presentation/profile_widget.dart';
import '../../util/logger.dart';
import '../common_widget/button/to_search_user_button.dart';
import '../router/app_router.dart';

/// @doc doc/specs/mobile-app-functional-spec.md#12-公開プロフィール
@RoutePage()
class ProfileTopPage extends ConsumerWidget {
  const ProfileTopPage({super.key, required this.targetUserId});

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider)!;
    final asyncProfile = ref.watch(userProfileProvider(targetUserId));
    final isMyProfile = currentUserId == targetUserId;

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              title: asyncProfile.when(
                data: (profile) =>
                    Text(profile.name, overflow: TextOverflow.ellipsis),
                loading: () => const SizedBox.shrink(),
                error: (error, stackTrace) {
                  logger.e('error: $error, stackTrace: $stackTrace');
                  return const Text('プロフィール');
                },
              ),
              actions: [
                isMyProfile
                    ? const ToSearchUserButton()
                    : OtherUserActionIconButton(ownerId: targetUserId),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                ProfileWidget(targetUserId: targetUserId),
                ListTile(
                  title: const Text('いいねした投稿'),
                  trailing: const Icon(CupertinoIcons.chevron_forward),
                  onTap: () => context.pushRoute(
                    LikedDefinitionListRoute(targetUserId: targetUserId),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    '公開辞書',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ]),
            ),
          ],
          body: PublicDictionaryList(userId: targetUserId),
        ),
      ),
    );
  }
}
