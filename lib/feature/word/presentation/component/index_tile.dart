import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexTile extends StatelessWidget {
  const IndexTile({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Icon(
            CupertinoIcons.chevron_forward,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}
