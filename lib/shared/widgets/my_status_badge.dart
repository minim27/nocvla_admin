import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import 'my_text.dart';

class MyStatusBadge extends StatelessWidget {
  const MyStatusBadge({
    super.key,
    required this.text,
    this.color = MyColors.primary60,
    this.borderColor,
  });

  final String text;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(border: .all(color: borderColor ?? color)),
      child: MyText(
        text: text.toUpperCase(),
        color: color,
        fontSize: 11,
        fontWeight: .w600,
        letterSpacing: 0.88,
      ),
    );
  }
}
