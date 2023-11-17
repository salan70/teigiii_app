import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../component/search_user_text_field.dart';

@RoutePage()
class SearchUserPage extends StatelessWidget {
  const SearchUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ユーザーを探す'),
        ),
        body: Padding(
          padding: REdgeInsets.symmetric(
            vertical: 24,
            horizontal: 52,
          ),
          child: SearchUserTextField(autoFocus: true),
        ),
      ),
    );
  }
}
