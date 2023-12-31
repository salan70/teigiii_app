import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../feature/user_search/presentation/search_user_text_field.dart';

@RoutePage()
class UserSearchPage extends StatelessWidget {
  const UserSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ユーザーを探す'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 40,
          ),
          child: SearchUserTextField(autoFocus: true),
        ),
      ),
    );
  }
}
