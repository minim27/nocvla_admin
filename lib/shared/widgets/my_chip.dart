import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import 'my_text.dart';

class MyChip extends StatelessWidget {
  const MyChip({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const .symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.secondary : null,
          border: .all(color: isSelected ? MyColors.secondary : MyColors.line),
        ),
        child: Center(
          widthFactor: 1,
          child: MyText(
            text: text,
            color: isSelected ? MyColors.primary : MyColors.secondary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
