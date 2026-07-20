import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/router/app_router.dart';
import 'write_definition_base_page.dart';

/// 定義投稿画面へ遷移するFAB
class PostDefinitionFAB extends StatelessWidget {
  const PostDefinitionFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      elevation: 3,
      onPressed: () {
        context.pushRoute(
          DefinitionPostRoute(
            initialDefinitionForWrite: null,
            autoFocusForm: WriteDefinitionFormType.word,
          ),
        );
      },
      child: const Icon(CupertinoIcons.add),
    );
  }
}
