import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../user_profile/presentation/page/profile_widget_shimmer.dart';

@RoutePage()
class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IndexPage'),
      ),
      body: const ProfileWidgetShimmer(),
    );
  }
}
