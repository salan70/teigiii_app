import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_state.dart';
import 'profile_widget.dart';

@RoutePage()
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(me): 雑に!使ってるが、問題ないか確認する
    final userId = ref.watch(userIdProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール'),
      ),
      body:  Column(
        children: [
          ProfileWidget(userId: userId),
        ],
      ),
    );
  }
}
