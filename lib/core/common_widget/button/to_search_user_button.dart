import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';

class ToSearchUserButton extends StatelessWidget {
  const ToSearchUserButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.person_add),
      onPressed: () {
        context.pushRoute(const UserSearchRoute());
      },
    );
  }
}
