import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/shimmer_widget.dart';
import '../../../core/router/app_router.dart';
import '../../user_config/application/user_config_state.dart';

@RoutePage()
class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAppVersion = ref.watch(appVersionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 24,
          right: 20,
        ),
        child: ListView(
          children: [
            // 一般
            Text(
              '一般',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.speaker_slash),
              label: 'ミュートの管理',
              onTap: () {}, // TODO(me): ミュート管理画面へ遷移
            ),
            const SizedBox(height: 32),

            // サポート
            Text(
              'サポート',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.question_square),
              label: '使い方',
              onTap: () {}, // TODO(me): 使い方画面へ遷移（WebToでNotion）
            ),
            const SizedBox(height: 24),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.mail),
              label: 'お問い合わせ',
              onTap: () {}, // TODO(me): お問い合わせフォームへ遷移（WebToでGoogleフォーム）
            ),
            const SizedBox(height: 24),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.star),
              label: 'レビューで応援する',
              onTap: () {}, // TODO(me): レビューダイアログを表示
            ),
            const SizedBox(height: 32),

            // アプリについて
            Text(
              'アプリについて',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.doc_text),
              label: '利用規約',
              onTap: () {}, // TODO(me): 利用規約画面へ遷移（WebToでNotion）
            ),
            const SizedBox(height: 24),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.exclamationmark_shield),
              label: 'プライバシーポリシー',
              onTap: () {}, // TODO(me): プライバシーポリシー画面へ遷移（WebToでNotion）
            ),
            const SizedBox(height: 24),
            SettingTileButton(
              trailingIcon: const Icon(CupertinoIcons.tag),
              label: 'ライセンス',
              onTap: () async {
                await context.navigateTo(const MyLicenseRoute());
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(CupertinoIcons.info),
                const SizedBox(width: 8),
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
                const SizedBox(width: 4),
              ],
            ),
            const SizedBox(height: 72),
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () {
                  // TODO(me): アカウント削除の処理
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
          const SizedBox(width: 8),
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
