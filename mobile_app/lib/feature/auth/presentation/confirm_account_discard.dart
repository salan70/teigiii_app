import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../domain/account_data_snapshot.dart';

Future<bool> confirmAccountDiscard(
  BuildContext context,
  AccountDataSnapshot data,
) async {
  final editedProfileMessage = data.hasEditedProfile
      ? '\nプロフィール設定も削除されます。'
      : '';
  return await showDialog<bool>(
        context: context,
        builder: (dialogContext) => DsConfirmDialog(
          message:
              'この端末の匿名アカウントが削除されます。\n'
              '定義 ${data.definedWordCount} 件、保存した言葉 ${data.savedWordCount} 件、'
              'フォロー ${data.followingCount} 件$editedProfileMessage\n'
              '削除してアカウントを切り替えますか？',
          confirmButtonText: '削除して切り替える',
          onCancel: () => Navigator.of(dialogContext).pop(false),
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        ),
      ) ??
      false;
}
