import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../router/app_router.dart';

class ToSettingButton extends StatelessWidget {
  const ToSettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.gear_solid),
      onPressed: () async {
        await context.navigateTo(const SettingRoute());
      },
    );
  }
}
