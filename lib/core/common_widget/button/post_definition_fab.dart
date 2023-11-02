import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';

class PostDefinitionFAB extends StatelessWidget {
  const PostDefinitionFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 3,
      onPressed: () {
        context.pushRoute(const PostDefinitionRoute());
      },
      child: const Icon(CupertinoIcons.add),
    );
  }
}
