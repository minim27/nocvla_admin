import 'package:flutter/material.dart';

import '../utils/my_colors.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.size = 40,
    this.iconSize = 18,
    this.color = MyColors.secondary,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final double size, iconSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? "",
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(border: .all(color: MyColors.line)),
          child: Icon(
            icon,
            size: iconSize,
            color: onTap == null ? MyColors.border : color,
          ),
        ),
      ),
    );
  }
}
