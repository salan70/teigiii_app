import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../feature/definition/domain/definition.dart';
import '../../../feature/definition/util/write_definition_form_type.dart';
import '../../router/app_router.dart';

/// 定義投稿画面へ遷移するFAB
///
/// 定義投稿画面にて、TextFieldなどに初期表示させたい項目がある場合[definition]として渡す。
/// ない場合はnullを渡す。
class PostDefinitionFAB extends StatelessWidget {
  const PostDefinitionFAB({super.key, required this.definition});

  final Definition? definition;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      elevation: 3,
      onPressed: () {
        context.pushRoute(
          PostDefinitionRoute(
            initialDefinition: definition,
            autoFocusForm: WriteDefinitionFormType.word,
          ),
        );
      },
      child: const Icon(CupertinoIcons.add),
    );
  }
}
