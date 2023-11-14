import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../component/search_user_text_field.dart';

@RoutePage()
class SearchUserResultPage extends StatelessWidget {
  const SearchUserResultPage({super.key, required this.searchId});

  final String searchId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ユーザーを探す'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 36,
                ),
                child: SearchUserTextField(defaultText: searchId),
              ),
              const Text('ユーザーが見つかりませんでした'),
            ],
          ),
        ),
      ),
    );
  }
}
