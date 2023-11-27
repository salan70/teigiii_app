import 'package:flutter/material.dart';

/// emptyステートとして使用する [message] を表示させるだけのシンプルなWidget
class SimpleWidgetForEmpty extends StatelessWidget {
  const SimpleWidgetForEmpty({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
