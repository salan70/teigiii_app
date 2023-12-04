import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// emptyステートとして使用する [message] を表示させるだけのシンプルな Widget.
class SimpleEmptyWidget extends StatelessWidget {
  const SimpleEmptyWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(40),
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
