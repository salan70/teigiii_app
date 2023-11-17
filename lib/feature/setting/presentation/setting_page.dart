import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common_provider/launch_url.dart';
import '../../../core/common_widget/shimmer_widget.dart';
import '../../../core/router/app_router.dart';
import '../../../util/constant/url.dart';
import '../../auth/application/auth_state.dart';
import '../../user_config/application/user_config_state.dart';
import '../../user_profile/application/user_profile_state.dart';

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
        padding: REdgeInsets.only(
          left: 24,
          right: 20,
        ),
        child: ListView(
          children: [
            SizedBox(height: 24.h),
            // 一般
            Text(
              '一般',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 8.h),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.speaker_slash),
              label: 'ミュートの管理',
              onTap: () {
                context.navigateTo(const MutedUserListRoute());
              },
            ),
            SizedBox(height: 32.h),

            // サポート
            Text(
              'サポート',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 8.h),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.question_square),
              label: '使い方',
              onTap: () {}, // TODO(me): 使い方画面へ遷移（WebToでNotion）
            ),
            SizedBox(height: 24.h),
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
            SizedBox(height: 24.h),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.star),
              label: 'レビューで応援する',
              onTap: () {}, // TODO(me): レビューダイアログを表示
            ),
            SizedBox(height: 32.h),

            // アプリについて
            Text(
              'アプリについて',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 8.h),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.doc_text),
              label: '利用規約',
              onTap: () {}, // TODO(me): 利用規約画面へ遷移（WebToでNotion）
            ),
            SizedBox(height: 24.h),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.exclamationmark_shield),
              label: 'プライバシーポリシー',
              onTap: () {}, // TODO(me): プライバシーポリシー画面へ遷移（WebToでNotion）
            ),
            SizedBox(height: 24.h),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.tag),
              label: 'ライセンス',
              onTap: () async {
                await context.navigateTo(const MyLicenseRoute());
              },
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                const Icon(CupertinoIcons.info),
                SizedBox(width: 8.w),
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
                      return ShimmerWidget.rectangular(
                        height: 16.h,
                        width: 48.w,
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
                SizedBox(width: 4.w),
              ],
            ),
            SizedBox(height: 72.h),
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () async {
                  // TODO(me): アカウント削除の処理
                  // await ref.read(authServiceProvider.notifier).deleteUser();
                },
                child: Text(
                  'アカウント削除',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            ),
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
          SizedBox(width: 8.w),
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
              size: 20.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
