import 'package:flutter/material.dart';

/// Overflowに適応したTextウィジェット
class AdaptiveOverflowText extends StatelessWidget {
  const AdaptiveOverflowText({
    required this.text,
    required this.maxLines,
    super.key,
  });

  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    /// 表示するtextがmaxLinesを超えているかどうかを判定する
    bool isTextOverflown() {
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: DefaultTextStyle.of(context).style),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: MediaQuery.of(context).size.width);

      return textPainter.didExceedMaxLines;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
        if (isTextOverflown())
          Align(
            alignment: Alignment.topRight,
            child: Text(
              '続き →',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
      ],
    );
  }
}
