import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../definition_detail/definition_detail_shimmer.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール'),
      ),
      body: const DefinitionDeitailShimmer(),
    );
  }
}
