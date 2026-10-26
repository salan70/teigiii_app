import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/auth/application/account_link_service.dart';
import '../../feature/auth/application/auth_state.dart';
import '../../feature/auth/domain/auth_provider_type.dart';
import '../../feature/auth/presentation/confirm_account_discard.dart';
import '../../util/mixin/presentation_mixin.dart';
import '../design_system/design_system.dart';

@RoutePage()
class AccountLinkPage extends ConsumerStatefulWidget {
  const AccountLinkPage({super.key});

  @override
  ConsumerState<AccountLinkPage> createState() => _AccountLinkPageState();
}

class _AccountLinkPageState extends ConsumerState<AccountLinkPage>
    with PresentationMixin {
  Future<void> _link(AuthProviderType provider) async {
    await executeWithOverlayLoading(
      ref,
      inBaseRouteBeforeAction: false,
      inBaseRouteAfterAction: false,
      action: () async {
        await ref
            .read(accountLinkServiceProvider)
            .link(
              provider,
              confirmDiscard: (data) => confirmAccountDiscard(context, data),
              onCredentialFallback: _showCredentialFallback,
            );
      },
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<AuthProviderType?> _showCredentialFallback() async {
    return showDialog<AuthProviderType>(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => DsDialog(
        content: const Padding(
          padding: EdgeInsets.symmetric(horizontal: DsSpacing.containerContent),
          child: Text(
            'この認証方法は、別のサインイン方法で登録されています。\n'
            '以前使用した方法を選択してください。',
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          DsOutlinedButton.tertiary(
            onPressed: () => Navigator.of(dialogContext).pop(),
            text: 'キャンセル',
          ),
          DsOutlinedButton.tertiary(
            onPressed: () =>
                Navigator.of(dialogContext).pop(AuthProviderType.apple),
            text: 'Apple',
          ),
          DsFilledButton.primary(
            onPressed: () =>
                Navigator.of(dialogContext).pop(AuthProviderType.google),
            text: 'Google',
          ),
        ],
      ),
    );
  }

  String _providerLabel(String providerId) {
    switch (providerId) {
      case 'apple.com':
        return 'Apple';
      case 'google.com':
        return 'Google';
      default:
        return providerId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAnonymous = ref.watch(isAnonymousProvider);
    final providers = ref.watch(linkedAuthProvidersProvider);
    final service = ref.watch(accountLinkServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント連携'),
        actions: [
          DsIconButton(
            icon: CupertinoIcons.xmark,
            semanticLabel: '閉じる',
            onPressed: () => context.maybePop(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: DsSpacing.screenContent,
        ),
        children: [
          if (service.hasPendingCleanup) ...[
            const Gap(DsSpacing.section),
            Text(const AccountCleanupPendingException().toString()),
            const Gap(DsSpacing.inline),
            DsFilledButton.primary(
              text: '元の匿名アカウントの削除を再試行',
              onPressed: () async {
                await executeWithOverlayLoading(
                  ref,
                  inBaseRouteBeforeAction: false,
                  inBaseRouteAfterAction: false,
                  errorToastMessage: const AccountCleanupPendingException()
                      .toString(),
                  action: service.retryPendingCleanup,
                );
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ],
          const Gap(DsSpacing.section),
          Text(
            isAnonymous ? 'アカウントを保護する' : '連携済みのアカウント',
            style: context.dsTypography.heading,
          ),
          const Gap(DsSpacing.inline),
          Text(
            isAnonymous
                ? '認証方法を連携すると、機種変更や再インストール後もデータを引き継げます。'
                : 'このアカウントに連携されている認証方法です。',
            style: context.dsTypography.body,
          ),
          const Gap(DsSpacing.section),
          if (providers.isEmpty)
            const Text('連携済みの認証方法はありません。')
          else
            ...providers.map(
              (provider) => Padding(
                padding: const EdgeInsets.only(bottom: DsSpacing.inline),
                child: DsListTile.label(
                  label:
                      '${_providerLabel(provider.providerId)}'
                      '${provider.email == null ? '' : '\n${provider.email}'}',
                  onTap: null,
                ),
              ),
            ),
          if (isAnonymous) ...[
            const Gap(DsSpacing.section),
            DsFilledButton.primary(
              onPressed: () => _link(AuthProviderType.apple),
              text: 'Apple と連携する',
            ),
            const Gap(DsSpacing.inline),
            DsFilledButton.primary(
              onPressed: () => _link(AuthProviderType.google),
              text: 'Google と連携する',
            ),
          ],
          const Gap(DsSpacing.screenEnd),
        ],
      ),
    );
  }
}
