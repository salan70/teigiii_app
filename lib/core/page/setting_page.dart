import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/common_provider/in_app_review_provider.dart';
import '../../../../core/common_provider/launch_url.dart';
import '../../../../core/common_widget/shimmer_widget.dart';
import '../../../../core/router/app_router.dart';
import '../../../../util/constant/url.dart';
import '../../feature/auth/application/auth_state.dart';
import '../../feature/setting/presentation/delete_account_button.dart';
import '../../feature/user_config/application/user_config_state.dart';
import '../../feature/user_profile/application/user_profile_state.dart';

@RoutePage()
class SettingRouterPage extends AutoRouter {
  const SettingRouterPage({super.key});
}

@RoutePage()
class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAppVersion = ref.watch(appVersionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.xmark),
            onPressed: () async {
              await context.popRoute();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 20,
        ),
        child: ListView(
          children: [
            const Gap(24),
            // 一般
            Text(
              '一般',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Gap(8),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.speaker_slash),
              label: 'ミュートの管理',
              onTap: () {
                context.navigateTo(const UserListMutedRoute());
              },
            ),
            const Gap(32),

            // サポート
            Text(
              'サポート',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Gap(8),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.question_square),
              label: '使い方',
              onTap: () => ref.read(launchURLProvider(howToPageUrl)),
            ),
            const Gap(24),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.mail),
              label: 'お問い合わせ',
              onTap: () {
                final currentUserId = ref.read(userIdProvider)!;
                final currentUserProfile =
                    ref.read(userProfileProvider(currentUserId)).value;
                final url = inquireFormUrl(currentUserProfile?.publicId ?? '');

                ref.read(launchURLProvider(url));
              },
            ),
            const Gap(24),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.star),
              label: 'レビューで応援する',
              onTap: () => ref
                  .read(inAppReviewProvider)
                  .openStoreListing(appStoreId: appleId),
            ),
            const Gap(32),

            // アプリについて
            Text(
              'アプリについて',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Gap(8),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.doc_text),
              label: '利用規約',
              onTap: () => ref.read(launchURLProvider(termPageUrl)),
            ),
            const Gap(24),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.exclamationmark_shield),
              label: 'プライバシーポリシー',
              onTap: () => ref.read(launchURLProvider(privacyPolicyPageUrl)),
            ),
            const Gap(24),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.tag),
              label: 'ライセンス',
              onTap: () async {
                await context.navigateTo(const MyLicenseRoute());
              },
            ),
            const Gap(24),
            Row(
              children: [
                const Icon(CupertinoIcons.info),
                const Gap(8),
                Expanded(
                  child: Text(
                    'バージョン',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: asyncAppVersion.when(
                    data: (appVersion) {
                      return Text(
                        appVersion,
                        style: Theme.of(context).textTheme.titleSmall,
                      );
                    },
                    loading: () {
                      return const ShimmerWidget.rectangular(
                        height: 16,
                        width: 48,
                      );
                    },
                    error: (error, stackTrace) {
                      return Text(
                        '取得できませんでした',
                        style: Theme.of(context).textTheme.titleSmall,
                      );
                    },
                  ),
                ),
                const Gap(4),
              ],
            ),
            const Gap(72),
            const Align(
              alignment: Alignment.topCenter,
              child: DeleteAccountButton(),
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}

/// 全体をタップできる設定項目
class SettingTileButton extends StatelessWidget {
  const SettingTileButton({
    super.key,
    required this.trailingIcon,
    required this.label,
    required this.onTap,
  });

  final Icon trailingIcon;
  final String label;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          trailingIcon,
          const Gap(8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              CupertinoIcons.chevron_forward,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
