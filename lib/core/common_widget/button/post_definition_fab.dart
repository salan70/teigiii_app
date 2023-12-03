import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../feature/definition/presentation/write_definition_base_page.dart';
import '../../router/app_router.dart';

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
